CREATE OR REPLACE PROCEDURE silver.load_silver()
LANGUAGE plpgsql
AS $$
DECLARE
    started_at TIMESTAMPTZ;
    finished_at TIMESTAMPTZ;
BEGIN
    RAISE NOTICE '========================================';
    RAISE NOTICE 'Loading Silver Layer';
    RAISE NOTICE '========================================';

    
    RAISE NOTICE 'Loading laptop products';

    TRUNCATE TABLE silver.laptop_product;

    INSERT INTO silver.laptop_product
    (
        product_url,
        brand_raw,
        brand,
        product_name,
        current_price_inr,
        lowest_price_inr,
        highest_price_inr,
        installed_ram_gb,
        max_ram_gb,
        ram_type,
        ram_form_factor,
        features,
        specs,
        best_buy_link
    )
    SELECT
        TRIM(product_url_raw),
        TRIM(brand_raw),
        CASE
            WHEN UPPER(TRIM(brand_raw)) IN ('ASUS', 'ASUS-TUF') THEN 'ASUS'
            WHEN LOWER(TRIM(brand_raw)) = 'acer' THEN 'Acer'
            WHEN TRIM(brand_raw) IN ('Dell', '𝗗𝗲𝗹𝗹Laptop', '𝗗𝗲𝗹𝗹Model', '𝗗𝗲𝗹𝗹ModeI') THEN 'Dell'
            WHEN TRIM(brand_raw) IN ('Lenovo', '𝗟𝗲𝗻𝗼𝘃𝗼Model', 'Lenovo-LOQ') THEN 'Lenovo'
            WHEN TRIM(brand_raw) IN ('HP', '𝗛𝗣𝗣𝗿𝗼𝗯𝗼𝗼𝗸Model', '𝗛𝗣𝗲𝗹𝗶𝘁𝗲𝗯𝗼𝗼𝗸', '𝗛𝗣𝗲𝗹𝗶𝘁𝗲𝗯𝗼𝗼𝗸Model') THEN 'HP'
            ELSE TRIM(brand_raw)
        END,
        TRIM(name_raw),
        REPLACE(REPLACE(TRIM(current_price_raw), '₹', ''), ',', '')::NUMERIC(12,2),
        REPLACE(REPLACE(TRIM(lowest_price_raw), '₹', ''), ',', '')::NUMERIC(12,2),
        REPLACE(REPLACE(TRIM(highest_price_raw), '₹', ''), ',', '')::NUMERIC(12,2),
        SUBSTRING(specs_raw FROM 'RAM Memory Installed ([0-9]+) GB')::INTEGER,
        SUBSTRING(specs_raw FROM 'Ram Memory Maximum Size ([0-9]+) GB')::INTEGER,
        CASE
            WHEN specs_raw ILIKE '%LPDDR5X%' OR name_raw ILIKE '%LPDDR5X%' THEN 'LPDDR5X'
            WHEN specs_raw ILIKE '%LPDDR5%' OR specs_raw ILIKE '%LPDDR 5%' OR name_raw ILIKE '%LPDDR5%' THEN 'LPDDR5'
            WHEN specs_raw ILIKE '%LPDDR4X%' OR name_raw ILIKE '%LPDDR4X%' THEN 'LPDDR4X'
            WHEN specs_raw ILIKE '%LPDDR4%' OR specs_raw ILIKE '%LPDDR 4%' OR name_raw ILIKE '%LPDDR4%' THEN 'LPDDR4'
            WHEN specs_raw ILIKE '%DDR5%' OR name_raw ILIKE '%DDR5%' THEN 'DDR5'
            WHEN specs_raw ILIKE '%DDR4%' OR name_raw ILIKE '%DDR4%' THEN 'DDR4'
            WHEN specs_raw ILIKE '%DDR3%' OR name_raw ILIKE '%DDR3%' THEN 'DDR3'
            ELSE NULL
        END,
        CASE
            WHEN specs_raw ILIKE '%SODIMM%' OR specs_raw ILIKE '%SO-DIMM%'
              OR features_raw ILIKE '%SODIMM%' OR features_raw ILIKE '%SO-DIMM%' THEN 'SO-DIMM'
            WHEN specs_raw ILIKE '%UDIMM%' OR features_raw ILIKE '%UDIMM%' THEN 'UDIMM'
            WHEN specs_raw ILIKE '%DIMM%' OR features_raw ILIKE '%DIMM%' THEN 'DIMM'
            ELSE NULL
        END,
        features_raw,
        specs_raw,
        best_buy_link_raw
    FROM bronze.laptop_listing_raw;

    RAISE NOTICE 'Laptop products loaded';

    
    RAISE NOTICE 'Loading RAM modules';

    TRUNCATE TABLE silver.ram_module;

    INSERT INTO silver.ram_module
    (
        product_url,
        brand_raw,
        brand,
        product_name,
        current_price_inr,
        lowest_price_inr,
        highest_price_inr,
        capacity_gb,
        ram_type,
        speed_mhz,
        form_factor,
        features,
        specs,
        best_buy_link
    )
    SELECT
        TRIM(product_url_raw),
        TRIM(brand_raw),
        CASE
            WHEN UPPER(TRIM(brand_raw)) = 'KINGSTON' THEN 'Kingston'
            WHEN UPPER(TRIM(brand_raw)) = 'G.SKILL' THEN 'G.SKILL'
            WHEN TRIM(brand_raw) = 'Sk' THEN 'SK Hynix'
            WHEN TRIM(brand_raw) = '4GB' THEN 'Unknown'
            ELSE TRIM(brand_raw)
        END,
        TRIM(name_raw),
        REPLACE(REPLACE(TRIM(current_price_raw), '₹', ''), ',', '')::NUMERIC(12,2),
        REPLACE(REPLACE(TRIM(lowest_price_raw), '₹', ''), ',', '')::NUMERIC(12,2),
        REPLACE(REPLACE(TRIM(highest_price_raw), '₹', ''), ',', '')::NUMERIC(12,2),
        SUBSTRING(UPPER(name_raw) FROM '([0-9]+) ?GB')::INTEGER,
        CASE
            WHEN specs_raw ILIKE '%LPDDR5X%' OR name_raw ILIKE '%LPDDR5X%' THEN 'LPDDR5X'
            WHEN specs_raw ILIKE '%LPDDR5%' OR name_raw ILIKE '%LPDDR5%' THEN 'LPDDR5'
            WHEN specs_raw ILIKE '%LPDDR4X%' OR name_raw ILIKE '%LPDDR4X%' THEN 'LPDDR4X'
            WHEN specs_raw ILIKE '%LPDDR4%' OR name_raw ILIKE '%LPDDR4%' THEN 'LPDDR4'
            WHEN specs_raw ILIKE '%DDR5%' OR name_raw ILIKE '%DDR5%' THEN 'DDR5'
            WHEN specs_raw ILIKE '%DDR4%' OR name_raw ILIKE '%DDR4%' THEN 'DDR4'
            WHEN specs_raw ILIKE '%DDR3%' OR name_raw ILIKE '%DDR3%' THEN 'DDR3'
            ELSE NULL
        END,
        SUBSTRING(UPPER(specs_raw) FROM '([0-9]{3,5}) MHZ')::INTEGER,
        CASE
            WHEN specs_raw ILIKE '%SODIMM%' OR specs_raw ILIKE '%SO-DIMM%'
              OR name_raw ILIKE '%SODIMM%' OR name_raw ILIKE '%SO-DIMM%' THEN 'SO-DIMM'
            WHEN specs_raw ILIKE '%UDIMM%' OR name_raw ILIKE '%UDIMM%' THEN 'UDIMM'
            WHEN specs_raw ILIKE '%DIMM%' OR name_raw ILIKE '%DIMM%' THEN 'DIMM'
            ELSE 'Unknown'
        END,
        features_raw,
        specs_raw,
        best_buy_link_raw
    FROM bronze.ram_listing_raw;

    RAISE NOTICE 'RAM modules loaded';
    RAISE NOTICE 'Silver Layer loading completed';
    RAISE NOTICE '========================================';
END;
$$;


CALL silver.load_silver();
