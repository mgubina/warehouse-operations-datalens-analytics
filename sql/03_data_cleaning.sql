-- ========================================================
-- СКРИПТЫ ВАЛИДАЦИИ И ПРОВЕРКИ КАЧЕСТВА ДАННЫХ (DATA CLEANING & QUALITY)
-- ========================================================

-- 1. Проверка на дубликаты операций по сборке
SELECT order_id, sku_line_id, COUNT(*)
FROM warehouse_operations
GROUP BY order_id, sku_line_id
HAVING COUNT(*) > 1;

-- 2. Проверка на аномальные интервалы (время завершения раньше времени начала)
SELECT *
FROM warehouse_operations
WHERE order_completed_at < order_received_at;

-- 3. Проверка наличия незавершенных операций (пустые даты завершения)
SELECT COUNT(*) AS total_uncompleted_orders
FROM warehouse_operations
WHERE order_completed_at IS NULL;

-- 4. Проверка на некорректные или нулевые показатели выработки
SELECT *
FROM warehouse_operations
WHERE lines_collected <= 0;