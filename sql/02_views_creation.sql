-- Создаем "Представление" (виртуальную идеальную таблицу)
CREATE OR REPLACE VIEW v_warehouse_perfect_mart AS
SELECT 
    -- 1. Забираем операционные данные лога и сразу переименовываем на русский язык
    op.operation_id AS id_операции,
    op.order_id AS номер_заказа,
    op.sku_line_id AS номер_строки,
    op.employee_name AS фио_сборщика,
    op.warehouse_zone AS зона_склада,
    op.lines_collected AS собрано_строк,
    op.has_error AS наличие_ошибки,
    
    -- Оставляем полные таймстампы со временем для точного расчета SLA в минутах
    op.order_received_at AS время_начала_сборки,
    op.order_completed_at AS время_завершения_сборки,
    
    -- 2. Подтягиваем данные из таблицы мощностей склада
    cap.total_pallet_places AS всего_паллето_мест,
    cap.occupied_pallet_places AS занято_паллето_мест,
    cap.goods_category_abc AS проблемная_категория,
    cap.cost_of_storage AS затраты_на_хранение

FROM warehouse_operations op
-- Мы принудительно преобразуем дату-время в чистую дату (CAST AS DATE), чтобы связать таблицы
LEFT JOIN warehouse_capacity cap ON op.order_received_at::date = cap.date_ref;

-- public.v_employee_utilization исходный текст

CREATE OR REPLACE VIEW public.v_employee_utilization
AS SELECT shift_date,
    employee_fio,
    sum(
        CASE
            WHEN activity_type::text = 'Работа (Сборка)'::text THEN duration_minutes
            ELSE 0
        END) AS work_minutes,
    sum(
        CASE
            WHEN activity_type::text = 'Ожидание техники'::text THEN duration_minutes
            ELSE 0
        END) AS wait_minutes,
    round(sum(
        CASE
            WHEN activity_type::text = 'Работа (Сборка)'::text THEN duration_minutes
            ELSE 0
        END)::numeric * 100.0 / 720::numeric, 1) AS utilization_rate_pct
   FROM employee_time_logs
  GROUP BY shift_date, employee_fio;
  
  -- public.v_dock_to_stock исходный текст

CREATE OR REPLACE VIEW public.v_dock_to_stock
AS SELECT supply_id,
    supplier_name,
    arrival_time::date AS supply_date,
    round(EXTRACT(epoch FROM placed_time - arrival_time) / 3600.0, 2) AS dock_to_stock_hours
   FROM receiving_logs;
   