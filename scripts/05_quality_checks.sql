-- 1. Check how many rows loaded.
SELECT 'Laptop' AS table_name, COUNT(*) AS total_rows
FROM silver.laptop_product
UNION ALL
SELECT 'RAM', COUNT(*)
FROM silver.ram_module;

-- 2. Check laptop any missing name or URL.
SELECT *
FROM silver.laptop_product
WHERE product_name IS NULL OR product_url IS NULL;

-- 3. Check RAM any missing name or URL.
SELECT *
FROM silver.ram_module
WHERE product_name IS NULL OR product_url IS NULL;

-- 4. Check prices correct order.
SELECT product_name, lowest_price_inr, current_price_inr, highest_price_inr
FROM silver.laptop_product
WHERE lowest_price_inr > current_price_inr
   OR current_price_inr > highest_price_inr;

SELECT product_name, lowest_price_inr, current_price_inr, highest_price_inr
FROM silver.ram_module
WHERE lowest_price_inr > current_price_inr
   OR current_price_inr > highest_price_inr;

-- 5. Check RAM details missing.
SELECT product_name, specs
FROM silver.laptop_product
WHERE installed_ram_gb IS NULL
   OR ram_type IS NULL;

-- 6. Check RAM capacity.
SELECT product_name, specs
FROM silver.ram_module
WHERE capacity_gb IS NULL
   OR ram_type IS NULL;


