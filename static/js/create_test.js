document.addEventListener('DOMContentLoaded', function() {
    try {
        let questionIndex = 1;
        const questionsContainer = document.getElementById('questionsContainer');
        const addQuestionBtn = document.getElementById('addQuestion');

        if (!questionsContainer || !addQuestionBtn) {
            throw new Error('Требуемые элементы не найдены в DOM');
        }

        // Функция обновления индексов вариантов
        const updateOptionValues = (questionBlock, qIndex) => {
            const optionItems = questionBlock.querySelectorAll('.option-item');
            optionItems.forEach((option, oIndex) => {
                const checkbox = option.querySelector('input[type="checkbox"]');
                if (checkbox) {
                    checkbox.name = `correct[${qIndex}][]`;
                    checkbox.value = oIndex;
                }
            });
        };

        // Функция клонирования вопроса
        const cloneQuestion = () => {
            const template = document.querySelector('.question-block');
            if (!template) {
                throw new Error('Шаблон вопроса не найден');
            }
            const newQuestion = template.cloneNode(true);

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
                    input.value = '1';
                } else {
                    input.value = '';
                }
            });

            // Обновляем value у чекбоксов
            updateOptionValues(newQuestion, newIndex);

            return newQuestion;
        };

        // Добавление нового вопроса
        addQuestionBtn.addEventListener('click', function() {
            const newQuestion = cloneQuestion();
            questionsContainer.appendChild(newQuestion);
        });

        // Обработчики событий внутри контейнера вопросов
        questionsContainer.addEventListener('click', function(e) {
            if (e.target.classList.contains('add-option')) {
                const questionBlock = e.target.closest('.question-block');
                const optionsContainer = questionBlock.querySelector('.options-container');
                const optionItems = optionsContainer.querySelectorAll('.option-item');
                const optionTemplate = optionItems[0];

                if (optionTemplate) {
                    const newOption = optionTemplate.cloneNode(true);
                    const textInput = newOption.querySelector('input[type="text"]');
                    const checkbox = newOption.querySelector('input[type="checkbox"]');

                    if (textInput) textInput.value = '';
                    if (checkbox) checkbox.checked = false;

                    optionsContainer.appendChild(newOption);

                    // Обновляем индексы чекбоксов
                    const qIndexMatch = checkbox.name.match(/\[(\d+)\]/);
                    const qIndex = qIndexMatch ? parseInt(qIndexMatch[1]) : 0;
                    updateOptionValues(questionBlock, qIndex);
                }
            }

            if (e.target.classList.contains('remove-option')) {
                const optionItem = e.target.closest('.option-item');
                const optionsContainer = optionItem.parentElement;
                const questionBlock = e.target.closest('.question-block');

                if (optionsContainer.querySelectorAll('.option-item').length > 1) {
                    optionItem.remove();

                    // Обновить индексы после удаления
                    const checkbox = optionsContainer.querySelector('input[type="checkbox"]');
                    const qIndexMatch = checkbox.name.match(/\[(\d+)\]/);
                    const qIndex = qIndexMatch ? parseInt(qIndexMatch[1]) : 0;
                    updateOptionValues(questionBlock, qIndex);
                } else {
                    alert('Должен быть хотя бы один вариант ответа.');
                }
            }
        });

    } catch (error) {
        console.error('Error in test creation form:', error);
        alert('Произошла ошибка при загрузке формы. Пожалуйста, обновите страницу.');
    }
});
