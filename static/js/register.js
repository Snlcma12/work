function showRoleFields() {
    const role = document.querySelector('select[name="role"]').value;
    document.getElementById('groupField').style.display = role === 'student' ? 'block' : 'none';
    document.getElementById('departmentField').style.display = role === 'teacher' ? 'block' : 'none';
}
window.onload = showRoleFields;