

CREATE OR REPLACE VIEW gold.dim_laptop AS
SELECT
    product_url AS laptop_id,
    brand,
    product_name,
    installed_ram_gb,
    max_ram_gb,
    ram_type,
    ram_form_factor
FROM silver.laptop_product;

CREATE OR REPLACE VIEW gold.dim_ram_module AS
SELECT
    product_url AS ram_id,
    brand,
    product_name,
    capacity_gb,
    ram_type,
    speed_mhz,
    form_factor
FROM silver.ram_module;


CREATE OR REPLACE VIEW gold.fact_laptop_price AS
SELECT
    product_url AS laptop_id,
    current_price_inr,
    lowest_price_inr,
    highest_price_inr,
    CASE
        WHEN installed_ram_gb > 0
        THEN ROUND(current_price_inr / installed_ram_gb, 2)
        ELSE NULL
    END AS laptop_price_per_ram_gb
FROM silver.laptop_product;


CREATE OR REPLACE VIEW gold.fact_ram_price AS
SELECT
    product_url AS ram_id,
    current_price_inr,
    lowest_price_inr,
    highest_price_inr,
    capacity_gb,
    CASE
        WHEN capacity_gb > 0
        THEN ROUND(current_price_inr / capacity_gb, 2)
        ELSE NULL
    END AS ram_price_per_gb
FROM silver.ram_module;


CREATE OR REPLACE VIEW gold.vw_ram_upgrade_candidates AS
SELECT
    l.product_name AS laptop_name,
    l.brand AS laptop_brand,
    l.installed_ram_gb,
    l.max_ram_gb,
    r.product_name AS ram_module_name,
    r.brand AS ram_brand,
    r.capacity_gb,
    r.current_price_inr AS ram_price_inr,
    l.ram_type
FROM silver.laptop_product l
JOIN silver.ram_module r
    ON l.ram_type = r.ram_type
WHERE l.ram_form_factor = 'SO-DIMM'
  AND r.form_factor = 'SO-DIMM'
  AND l.max_ram_gb > l.installed_ram_gb
  AND r.capacity_gb <= l.max_ram_gb - l.installed_ram_gb;
