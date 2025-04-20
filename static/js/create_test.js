document.addEventListener('DOMContentLoaded', function() {
    try {
        let questionIndex = 1;
        const questionsContainer = document.getElementById('questionsContainer');
        const addQuestionBtn = document.getElementById('addQuestion');

        if (!questionsContainer || !addQuestionBtn) {
            throw new Error('Требуемые элементы не найдены в DOM');
        }

        // Функция клонирования вопроса
        const cloneQuestion = () => {
            const template = document.querySelector('.question-block');
            if (!template) {
                throw new Error('Шаблон вопроса не найден');
            }
            return template.cloneNode(true);
        };

        // Добавление нового вопроса
        addQuestionBtn.addEventListener('click', function() {
            const newQuestion = cloneQuestion();
            const newIndex = questionIndex++;
            
            // Обновляем индексы
            const label = newQuestion.querySelector('label');
            if (label) {
                label.textContent = `Вопрос ${newIndex + 1}`;
            }
            
            newQuestion.querySelectorAll('input, textarea').forEach(input => {
                if (input.name) {
                    input.name = input.name.replace(/\[\d+\]/g, `[${newIndex}]`);
                }
                if (input.type === 'checkbox') {
                    input.checked = false;
                } else if (input.type === 'number') {
                    input.value = '1'; // значение по умолчанию для балла
                } else {
                    input.value = '';
                }
            });
            
            newQuestion.querySelectorAll('[type="checkbox"]').forEach(cb => cb.checked = false);
            
            questionsContainer.appendChild(newQuestion);
        });

        // Обработчики событий
        questionsContainer.addEventListener('click', function(e) {
            if (e.target.classList.contains('add-option')) {
                const optionsContainer = e.target.previousElementSibling;
                const optionTemplate = optionsContainer.querySelector('.option-item');
        
                if (optionTemplate) {
                    const newOption = optionTemplate.cloneNode(true);
                    newOption.querySelector('input[type="text"]').value = '';
                    newOption.querySelector('input[type="checkbox"]').checked = false;
                    optionsContainer.appendChild(newOption);
                }
            }
        
            if (e.target.classList.contains('remove-option')) {
                const optionItem = e.target.closest('.option-item');
                if (optionItem) {
                    const optionsContainer = optionItem.parentElement;
                    const optionCount = optionsContainer.querySelectorAll('.option-item').length;
        
                    if (optionCount > 1) {
                        optionItem.remove();
                    } else {
                        alert('Должен быть хотя бы один вариант ответа.');
                    }
                }
            }
        });
        

    } catch (error) {
        console.error('Error in test creation form:', error);
        alert('Произошла ошибка при загрузке формы. Пожалуйста, обновите страницу.');
    }
});