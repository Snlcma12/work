function showRoleFields() {
    const role = document.querySelector('select[name="role"]').value;
    document.getElementById('groupField').style.display = role === 'student' ? 'block' : 'none';
    document.getElementById('departmentField').style.display = role === 'teacher' ? 'block' : 'none';
}

function validateForm() {
    const role = document.querySelector('select[name="role"]').value;
    const group = document.querySelector('input[name="group"]').value.trim();
    const department = document.querySelector('input[name="department"]').value.trim();

    if (!role) {
        alert('Выберите роль');
        return false;
    }
    if (role === 'student' && !group) {
        alert('Введите номер группы');
        return false;
    }
    if (role === 'teacher' && !department) {
        alert('Введите название кафедры');
        return false;
    }
    return true;
}

function toggleInstruction() {
    const modal = document.getElementById('instructionModal');
    modal.style.display = modal.style.display === 'block' ? 'none' : 'block';
}

function closeModal() {
    document.getElementById('instructionModal').style.display = 'none';
}

// Закрытие модального окна при клике вне его области
window.onclick = function(event) {
    const modal = document.getElementById('instructionModal');
    if (event.target === modal) {
        modal.style.display = 'none';
    }
}

window.onload = showRoleFields;
