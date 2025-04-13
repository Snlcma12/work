from flask import Flask, render_template, request, redirect, url_for, session, flash 
from werkzeug.security import generate_password_hash, check_password_hash
import mysql.connector
from functools import wraps
from config import DB_CONFIG

app = Flask(__name__)
app.secret_key = 'your-secret-key-123'  # Замените на реальный секретный ключ

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
        cursor.execute("SELECT test_id, title AS test_name FROM tests")
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
        email = request.form.get('email', '').strip()

        if not username or not password:
            flash('Логин и пароль обязательны для заполнения', 'danger')
            return redirect(url_for('register'))

        if len(username) > 50:
            flash('Логин слишком длинный (максимум 50 символов)', 'danger')
            return redirect(url_for('register'))

        conn = get_db_connection()
        cursor = conn.cursor()
        try:
            cursor.execute("SELECT * FROM users WHERE username = %s", (username,))
            if cursor.fetchone():
                flash('Этот логин уже занят', 'danger')
                return redirect(url_for('register'))

            password_hash = generate_password_hash(password)
            cursor.execute(
                "INSERT INTO users (username, password_hash, email) VALUES (%s, %s, %s)",
                (username, password_hash, email)
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
                flash('Вход выполнен успешно!', 'success')
                next_page = request.args.get('next') or url_for('index')
                return redirect(next_page)
            
            flash('Неверный логин или пароль', 'danger')
            return redirect(url_for('login'))
        finally:
            cursor.close()
            conn.close()

    return render_template('login.html')

@app.route('/logout')
def logout():
    session.clear()
    flash('Вы успешно вышли из системы', 'info')
    return redirect(url_for('index'))

@app.route('/test/<int:test_id>', methods=['GET', 'POST'])
@login_required
def take_test(test_id):
    if request.method == 'POST':
        conn = get_db_connection()
        cursor = conn.cursor()
        try:
            # Подсчет баллов
            score = 0
            answers = request.form.getlist('answers')
            
            if not answers:
                flash('Пожалуйста, выберите хотя бы один ответ', 'warning')
                return redirect(url_for('take_test', test_id=test_id))

            for option_id in answers:
                cursor.execute("SELECT is_correct FROM options WHERE option_id = %s", (option_id,))
                result = cursor.fetchone()
                if result and result[0]:
                    score += 1

            # Сохранение результата
            cursor.execute(
                """INSERT INTO results 
                (user_id, test_id, score) 
                VALUES (%s, %s, %s)""",
                (session['user_id'], test_id, score)
            )
            conn.commit()
            
            flash(f'Тест завершен! Ваш результат: {score}', 'success')
            return redirect(url_for('test_results', test_id=test_id, score=score))
        except Exception as e:
            conn.rollback()
            flash(f'Ошибка при сохранении результатов: {str(e)}', 'danger')
            return redirect(url_for('take_test', test_id=test_id))
        finally:
            cursor.close()
            conn.close()

    # GET запрос - отображение теста
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        # Проверка существования теста
        cursor.execute("SELECT title AS test_name FROM tests WHERE test_id = %s", (test_id,))
        test = cursor.fetchone()
        if not test:
            flash('Тест не найден', 'danger')
            return redirect(url_for('index'))

        # Получение вопросов и вариантов ответов
        cursor.execute("SELECT question_id, question_text FROM questions WHERE test_id = %s", (test_id,))
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
            test_id=test_id,
            test_name=test['test_name'],
            questions=questions
        )
    except Exception as e:
        flash(f'Ошибка загрузки теста: {str(e)}', 'danger')
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
def create_test():
    if request.method == 'POST':
        conn = get_db_connection()
        cursor = conn.cursor()
        
        try:
            # Сохраняем тест
            cursor.execute(
                "INSERT INTO tests (title, description) VALUES (%s, %s)",
                (request.form['title'], request.form['description'])
            )
            test_id = cursor.lastrowid

            # Сохраняем вопросы
            for q_idx, question in enumerate(request.form.getlist('question')):
                cursor.execute(
                    "INSERT INTO questions (test_id, question_text) VALUES (%s, %s)",
                    (test_id, question)
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