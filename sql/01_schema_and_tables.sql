-- Создание таблицы операций склада
CREATE TABLE IF NOT EXISTS warehouse_operations (
    operation_id INT PRIMARY KEY,
    order_id INT,
    sku_line_id INT,
    employee_name VARCHAR(100),
    warehouse_zone VARCHAR(50),
    lines_collected INT,
    has_error BOOLEAN,
    order_received_at TIMESTAMP,
    order_completed_at TIMESTAMP
);

-- Создание таблицы логов приемки
CREATE TABLE IF NOT EXISTS receiving_logs (
    supply_id INT PRIMARY KEY,
    supplier_name VARCHAR(100),
    arrival_time TIMESTAMP,
    placed_time TIMESTAMP
);

-- Создание таблицы логов времени сотрудников
CREATE TABLE IF NOT EXISTS employee_time_logs (
    log_id INT PRIMARY KEY,
    shift_date DATE,
    employee_fio VARCHAR(100),
    activity_type VARCHAR(100),
    duration_minutes INT
);