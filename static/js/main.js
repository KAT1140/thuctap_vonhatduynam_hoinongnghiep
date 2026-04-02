// Hỗ trợ chức năng tương tác
document.addEventListener('DOMContentLoaded', function() {
    // Xác nhận xóa
    const deleteButtons = document.querySelectorAll('[data-confirm]');
    deleteButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            if (!confirm(this.getAttribute('data-confirm'))) {
                e.preventDefault();
            }
        });
    });

    // Auto-hide alerts
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });
});

// Hàm định dạng ngày
function formatDate(date) {
    return new Date(date).toLocaleDateString('vi-VN');
}

// Hàm tìm kiếm bảng
function filterTable(inputId, tableId) {
    const input = document.getElementById(inputId);
    const table = document.getElementById(tableId);
    const rows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr');

    input.addEventListener('keyup', function() {
        const filter = this.value.toUpperCase();
        for (let i = 0; i < rows.length; i++) {
            const text = rows[i].textContent || rows[i].innerText;
            rows[i].style.display = text.toUpperCase().indexOf(filter) > -1 ? '' : 'none';
        }
    });
}
