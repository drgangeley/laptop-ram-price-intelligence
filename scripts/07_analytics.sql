-- QUESTION 1: Average laptop price by brand.
SELECT
    brand,
    COUNT(*) AS laptop_count,
    ROUND(AVG(current_price_inr), 2) AS average_price_inr
FROM silver.laptop_product
GROUP BY brand
ORDER BY average_price_inr DESC;

-- QUESTION 2: How much RAM do the listed laptops have?
SELECT
    installed_ram_gb,
    ram_type,
    COUNT(*) AS laptop_count
FROM silver.laptop_product
GROUP BY installed_ram_gb, ram_type
ORDER BY installed_ram_gb, ram_type;

-- QUESTION 3: Which laptops show room for more RAM according to the listed specifications?
SELECT
    brand,
    product_name,
    current_price_inr,
    installed_ram_gb,
    max_ram_gb,
    max_ram_gb - installed_ram_gb AS ram_headroom_gb
FROM silver.laptop_product
WHERE max_ram_gb > installed_ram_gb
ORDER BY ram_headroom_gb DESC;

-- QUESTION 4: Compare RAM module prices per GB.
SELECT
    brand,
    product_name,
    capacity_gb,
    ram_type,
    form_factor,
    current_price_inr,
    ROUND(current_price_inr / capacity_gb, 2) AS price_per_gb
FROM silver.ram_module
WHERE capacity_gb > 0
ORDER BY price_per_gb;

-- QUESTION 5: Compare low and high listed prices for RAM products.
SELECT
    product_name,
    current_price_inr,
    lowest_price_inr,
    highest_price_inr,
    highest_price_inr - lowest_price_inr AS listed_price_range
FROM silver.ram_module
ORDER BY listed_price_range DESC;

-- QUESTION 6: Show possible laptop and RAM upgrade matches.
SELECT *
FROM gold.vw_ram_upgrade_candidates
ORDER BY laptop_name;
