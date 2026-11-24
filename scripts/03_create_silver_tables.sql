

CREATE TABLE IF NOT EXISTS silver.laptop_product
(
    product_url          TEXT PRIMARY KEY,
    brand_raw            TEXT,
    brand                TEXT,
    product_name         TEXT,
    current_price_inr    NUMERIC(12,2),
    lowest_price_inr     NUMERIC(12,2),
    highest_price_inr    NUMERIC(12,2),
    installed_ram_gb     INTEGER,
    max_ram_gb           INTEGER,
    ram_type             TEXT,
    ram_form_factor      TEXT,
    features             TEXT,
    specs                TEXT,
    best_buy_link        TEXT
);

CREATE TABLE IF NOT EXISTS silver.ram_module
(
    product_url          TEXT PRIMARY KEY,
    brand_raw            TEXT,
    brand                TEXT,
    product_name         TEXT,
    current_price_inr    NUMERIC(12,2),
    lowest_price_inr     NUMERIC(12,2),
    highest_price_inr    NUMERIC(12,2),
    capacity_gb          INTEGER,
    ram_type             TEXT,
    speed_mhz            INTEGER,
    form_factor          TEXT,
    features             TEXT,
    specs                TEXT,
    best_buy_link        TEXT
);
