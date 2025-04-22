function initializeTimer() {
    const timerContainer = document.getElementById('timer');
    const timerElement = document.getElementById('time');
    const timeLimit = parseInt(document.getElementById('timer-data').dataset.timeLimit);

    if (timeLimit > 0) {
        let timeLeft = timeLimit * 60;
        timerContainer.style.display = 'block';

        const timer = setInterval(() => {
            timeLeft--;
            const minutes = Math.floor(timeLeft / 60);
            const seconds = timeLeft % 60;
            timerElement.textContent = `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;

            if(timeLeft <= 0) {
                clearInterval(timer);
                document.getElementById('testForm').submit();
            }
        }, 1000);
    }
}

// Инициализация при загрузке страницы
document.addEventListener('DOMContentLoaded', initializeTimer);