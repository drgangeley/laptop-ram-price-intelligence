# Laptop & RAM Price Intelligence Data Warehouse

A small PostgreSQL data warehouse built from two product-listing CSV files: laptop listings and RAM-module listings.

The project follows a simple Bronze → Silver → Gold flow, similar to the stages used in Data With Baraa's SQL data warehouse project.

## Business question

A laptop retailer or repair/upgrade service wants to compare laptop prices and memory configurations, compare RAM-module prices, and find laptop/RAM combinations that are worth checking for a possible upgrade.

This project helps answer:

- How do listed laptop prices compare by brand?
- How much installed RAM do the laptops have?
- Which laptop listings show a higher stated maximum RAM than their installed RAM?
- What RAM generations, capacities and form factors appear in the RAM catalogue?
- How much does a listed RAM module cost per GB?
- Which laptop/RAM combinations look like possible upgrade candidates based on the fields available?

## Source files

| File | Rows | One row represents |
|---|---:|---|
| `data/source/laptop_ram_trend.csv` | 379 | One laptop listing |
| `data/source/Ram_Prices.csv` | 22 | One RAM-module listing |

Both files contain Brand, Name, Current Price, Lowest Price, Highest Price, Features, Specs, Best Buy Link and Product URL.

The Product URL fields point to PriceBefore product pages. The original scraper script and original collection date were not included with the CSVs. The project does not pretend that the profiling script was the web scraper. See `scraper/README.md` and `docs/SOURCE_ATTRIBUTION.md`.

## Architecture

```text
Two CSV files
    |
    v
BRONZE
  laptop_listing_raw
  ram_listing_raw
    |
    v
SILVER
  laptop_product
  ram_module
    |
    v
GOLD
  dim_laptop
  dim_ram_module
  fact_laptop_price
  fact_ram_price
  vw_ram_upgrade_candidates
    |
    v
SQL checks and business analysis
```

- Bronze keeps the incoming fields as text.
- Silver cleans brand labels, converts prices to numbers and extracts selected RAM details from the specifications.
- Gold provides simple views for analysis.

The editable diagram is `docs/architecture/laptop_ram_warehouse.drawio`.

## Tools

- Python and pandas for checking the CSV files.
- PostgreSQL for storing and transforming the data.
- pgAdmin 4 for running SQL and importing CSV files.
- VS Code for editing Python, SQL and documentation.
- Draw.io for the architecture diagram.

## Run the project



Run the SQL files in this order:

1. `sql/01_create_schemas_and_bronze.sql`
2. Import both CSV files into the Bronze tables using pgAdmin.
3. `sql/02_create_silver_tables.sql`
4. `sql/03_load_silver.sql`
5. Run `CALL silver.load_silver();`
6. `sql/04_create_gold_views.sql`
7. `sql/05_quality_checks.sql`
8. `sql/06_analytics.sql`

See `docs/SQL_EXPLAINED.md` for plain-language explanations.

## Important data limitations

- The files are one collection of product listings, not a dated price history.
- Lowest Price and Highest Price are values supplied by the source. Their difference is not a measured price change over time.
- The files do not contain sales, stock, purchase cost or profit, so the project does not calculate actual margin or demand.
- A possible RAM upgrade match is not a compatibility guarantee. Check the exact laptop model's memory slots, soldered RAM, speed and manufacturer specifications before making a recommendation.

To study actual price movement, collect the same product URLs again on later dates and keep a separate dated row for every observation.

## Repository layout

```text
README.md
data/source/
scripts/
docs/
```

