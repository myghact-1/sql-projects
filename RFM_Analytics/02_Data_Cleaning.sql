CREATE OR REPLACE VIEW v_clean_retail AS
SELECT
    invoice_no,
    stock_code,
    TRIM(description) AS description,
    quantity,
    invoice_date,
    unit_price,
    ROUND((quantity * unit_price)::NUMERIC, 2) AS total_amount,
    customer_id,
    country
FROM
    raw_retail
WHERE
    customer_id IS NOT NULL
    AND customer_id != ''
    AND quantity > 0
    AND unit_price > 0;