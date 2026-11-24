

-- Create the three layers.
CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;


CREATE TABLE IF NOT EXISTS bronze.laptop_listing_raw
(
    brand_raw          TEXT,
    name_raw           TEXT,
    current_price_raw  TEXT,
    lowest_price_raw   TEXT,
    highest_price_raw  TEXT,
    features_raw       TEXT,
    specs_raw          TEXT,
    best_buy_link_raw  TEXT,
    product_url_raw    TEXT
);

-- Bronze RAM table: keep the source values as TEXT.
CREATE TABLE IF NOT EXISTS bronze.ram_listing_raw
(
    brand_raw          TEXT,
    name_raw           TEXT,
    current_price_raw  TEXT,
    lowest_price_raw   TEXT,
    highest_price_raw  TEXT,
    features_raw       TEXT,
    specs_raw          TEXT,
    best_buy_link_raw  TEXT,
    product_url_raw    TEXT
);
