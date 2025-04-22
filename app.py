from flask import Flask, render_template, request, redirect, url_for, session, flash 
from werkzeug.security import generate_password_hash, check_password_hash
import mysql.connector
from datetime import datetime
from functools import wraps
from config import DB_CONFIG

app = Flask(__name__)
app.secret_key = '40b5ab78b31a19cd5f003f8be1f011597caa3b267fa5af9e73513f77ca34509c'  
def get_db_connection():
    return mysql.connector.connect(**DB_CONFIG)

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_id' not in session:
            flash('Пожалуйста, войдите в систему для доступа к этой странице', 'warning')
            return redirect(url_for('login', next=request.url))
        return f(*args, **kwargs)
    return decorated_function

@app.route('/')
def index():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        if 'role' in session and session['role'] == 'student':
            cursor.execute("""
                SELECT 
                    test_id, 
                    title AS test_name,
                    attempts_allowed,
                    time_limit,
                    available_until 
                FROM tests 
                WHERE group_name = %s OR group_name IS NULL
            """, (session.get('group_name'),))
        else:
            # Для преподавателей и других ролей выбираем те же поля
            cursor.execute("""
                SELECT 
                    test_id, 
                    title AS test_name,
                    attempts_allowed,
                    time_limit,
                    available_until 
                FROM tests
            """)
        tests = cursor.fetchall()
        return render_template('index.html', tests=tests)
    except Exception as e:
        flash(f'Ошибка загрузки тестов: {str(e)}', 'danger')
        return render_template('index.html', tests=[])
    finally:
        cursor.close()
        conn.close()

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form.get('username', '').strip()
        password = request.form.get('password', '').strip()
        email = request.form.get('email', '').strip() or None  # Сохраняем пустую почту как None
        role = request.form.get('role', '').strip()
        group = request.form.get('group', '').strip()
        department = request.form.get('department', '').strip()

        # Проверка обязательных полей
        if not username or not password or not role:
            flash('Логин, пароль и роль обязательны для заполнения', 'danger')
            return redirect(url_for('register'))
        
        # Валидация длины пароля
        if len(password) < 8:
            flash('Пароль должен содержать не менее 8 символов', 'danger')
            return redirect(url_for('register'))

        # Валидация роли
        if role not in ('student', 'teacher'):
            flash('Некорректная роль', 'danger')
            return redirect(url_for('register'))
        
        # Проверка группы/кафедры в зависимости от роли
        if role == 'student' and not group:
            flash('Для студента необходимо указать группу', 'danger')
            return redirect(url_for('register'))
        if role == 'teacher' and not department:
            flash('Для преподавателя необходимо указать кафедру', 'danger')
            return redirect(url_for('register'))
        
        if len(username) > 50:
            flash('Логин слишком длинный (максимум 50 символов)', 'danger')
            return redirect(url_for('register'))

        conn = get_db_connection()  # Перемещаем подключение БД выше
        cursor = conn.cursor()
        try:
            # Проверка уникальности логина
            cursor.execute("SELECT * FROM users WHERE username = %s", (username,))
            if cursor.fetchone():
                flash('Этот логин уже занят', 'danger')
                return redirect(url_for('register'))

            # Проверка уникальности почты (если email указан)
            if email:
                cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
                if cursor.fetchone():
                    flash('Эта почта уже используется', 'danger')
                    return redirect(url_for('register'))

            password_hash = generate_password_hash(password)
            cursor.execute(
                """INSERT INTO users 
                (username, password_hash, email, role, group_name, department) 
                VALUES (%s, %s, %s, %s, %s, %s)""",
                (username, password_hash, email, role, group or None, department or None)
            )
            conn.commit()
            flash('Регистрация успешна! Теперь вы можете войти', 'success')
            return redirect(url_for('login'))
        except mysql.connector.Error as err:
            conn.rollback()
            flash(f'Ошибка базы данных: {err}', 'danger')
            return redirect(url_for('register'))
        finally:
            cursor.close()
            conn.close()

    return render_template('register.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form.get('username', '').strip()
        password = request.form.get('password', '').strip()

        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        try:
            cursor.execute("SELECT * FROM users WHERE username = %s", (username,))
            user = cursor.fetchone()

            if user and check_password_hash(user['password_hash'], password):
                session['user_id'] = user['user_id']
                session['username'] = user['username']
                session['role'] = user['role']
                session['group_name'] = user['group_name']
                flash('Вход выполнен успешно!', 'success')
                next_page = request.args.get('next') or url_for('index')
                return redirect(next_page)
            
            flash('Неверный логин или пароль', 'danger')
            return redirect(url_for('login'))
        finally:
            cursor.close()
            conn.close()

    return render_template('login.html')

def teacher_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if session.get('role') != 'teacher':
            flash('Доступ запрещен: только для преподавателей.', 'danger')
            return redirect(url_for('index'))
        return f(*args, **kwargs)
    return decorated_function


@app.route('/logout')
def logout():
    session.clear()
    flash('Вы успешно вышли из системы', 'info')
    return redirect(url_for('index'))

@app.route('/test/<int:test_id>', methods=['GET', 'POST'])
@login_required
def take_test(test_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    try:
        # Получаем полные данные теста
        cursor.execute("""
            SELECT 
                test_id, 
                title, 
                description, 
                attempts_allowed, 
                time_limit, 
                available_until 
            FROM tests 
            WHERE test_id = %s
            AND (available_until IS NULL OR available_until >= NOW())
        """, (test_id,))
        test = cursor.fetchone()

        # Проверка существования теста
        if not test:
            flash('Тест не найден или срок его действия истек', 'danger')
            return redirect(url_for('index'))

        # Проверка количества попыток
        if test['attempts_allowed'] > 0:
            cursor.execute("""
                SELECT COUNT(*) AS attempts 
                FROM results 
                WHERE test_id = %s AND user_id = %s
            """, (test_id, session['user_id']))
            attempts = cursor.fetchone()['attempts']
            
            if attempts >= test['attempts_allowed']:
                flash('Превышено допустимое количество попыток', 'danger')
                return redirect(url_for('index'))

        # Обработка отправки теста
        if request.method == 'POST':
            result_id = session.get('current_result_id')
            
            if not result_id:
                flash('Сессия теста не найдена', 'danger')
                return redirect(url_for('index'))

            # Подсчет баллов
            score = 0
            answers = request.form.getlist('answers')
            
            if not answers:
                flash('Вы не ответили ни на один вопрос', 'warning')
                return redirect(url_for('take_test', test_id=test_id))

            for option_id in answers:
                cursor.execute("""
                    SELECT o.is_correct, q.score
                    FROM options o
                    JOIN questions q ON o.question_id = q.question_id
                    WHERE o.option_id = %s
                """, (option_id,))
                result = cursor.fetchone()
                
                if result and result['is_correct']:
                    score += result['score']

            # Обновление результата
            cursor.execute("""
                UPDATE results 
                SET score = %s, 
                    end_time = NOW()
                WHERE result_id = %s
            """, (score, result_id))
            
            session.pop('current_result_id', None)
            conn.commit()
            
            flash(f'Тест завершен! Ваш результат: {score}', 'success')
            return redirect(url_for('test_results', test_id=test_id))

        # Обработка GET запроса (начало теста)
        if request.method == 'GET':
            # Создаем новую запись о попытке
            cursor.execute("""
                INSERT INTO results 
                (user_id, test_id, score, start_time)  # Добавлено поле score
                VALUES (%s, %s, 0, NOW())             # Установлено временное значение 0
            """, (session['user_id'], test_id))
            conn.commit()
            
            session['current_result_id'] = cursor.lastrowid

            # Получаем вопросы и варианты ответов
            cursor.execute("""
                SELECT question_id, question_text 
                FROM questions 
                WHERE test_id = %s
            """, (test_id,))
            questions = cursor.fetchall()
            
            for question in questions:
                cursor.execute("""
                    SELECT option_id, option_text 
                    FROM options 
                    WHERE question_id = %s
                    ORDER BY option_id
                """, (question['question_id'],))
                question['options'] = cursor.fetchall()

            return render_template(
                'test.html',
                test=test,
                questions=questions
            )

    except mysql.connector.Error as err:
        conn.rollback()
        flash(f'Ошибка базы данных: {err}', 'danger')
        return redirect(url_for('index'))
        
    except Exception as e:
        flash(f'Ошибка: {str(e)}', 'danger')
        return redirect(url_for('index'))
        
    finally:
        cursor.close()
        conn.close()

@app.route('/test/<int:test_id>/results')
@login_required
def test_results(test_id):
    score = request.args.get('score', 0)
    return render_template(
        'test_results.html',
        score=score,
        test_id=test_id,
        username=session.get('username')
    )

@app.route('/my-results')
@login_required
def my_results():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT r.score, r.date, t.title AS test_name, t.test_id
            FROM results r
            JOIN tests t ON r.test_id = t.test_id
            WHERE r.user_id = %s
            ORDER BY r.date DESC
        """, (session['user_id'],))
        
        results = cursor.fetchall()
        return render_template('my_results.html', results=results)
    except Exception as e:
        flash(f'Ошибка при загрузке результатов: {str(e)}', 'danger')
        return redirect(url_for('index'))
    finally:
        cursor.close()
        conn.close()

@app.route('/create-test', methods=['GET', 'POST'])
@login_required
@teacher_required
def create_test():
    if request.method == 'POST':
        conn = get_db_connection()
        cursor = conn.cursor()
        
        try:
            available_until = request.form['available_until'] or None
            if available_until:
                available_until = datetime.strptime(available_until, '%Y-%m-%dT%H:%M')

            cursor.execute(
                """INSERT INTO tests 
                (title, description, group_name, attempts_allowed, time_limit, available_until)
                VALUES (%s, %s, %s, %s, %s, %s)""",
                (request.form['title'],
                 request.form['description'],
                 request.form['group_name'],
                 request.form['attempts'],
                 request.form['time_limit'],
                 available_until)
            )
            test_id = cursor.lastrowid

            # Сохраняем вопросы
            for q_idx, question in enumerate(request.form.getlist('question')):
                score = request.form.get(f'score[{q_idx}]', 1, type=int)
                cursor.execute(
                    "INSERT INTO questions (test_id, question_text, score) VALUES (%s, %s, %s)",
                    (test_id, question, score)
                )
                question_id = cursor.lastrowid

                # Сохраняем варианты ответов
                options = request.form.getlist(f'options[{q_idx}][]')
                correct = request.form.getlist(f'correct[{q_idx}][]')
                
                for opt_idx, option in enumerate(options):
                    cursor.execute(
                        """INSERT INTO options 
                        (question_id, option_text, is_correct) 
                        VALUES (%s, %s, %s)""",
                        (question_id, option, str(opt_idx) in correct)
                    )

            conn.commit()
            flash('Тест успешно создан!', 'success')
            return redirect(url_for('index'))
            
        except Exception as e:
            conn.rollback()
            flash(f'Ошибка при создании теста: {str(e)}', 'danger')
            return redirect(url_for('create_test'))
        finally:
            cursor.close()
            conn.close()

    return render_template('create_test.html')

if __name__ == '__main__':
    app.run(debug=True)