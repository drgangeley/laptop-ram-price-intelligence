# 💻 Laptop & RAM Price Intelligence Data Warehouse


Welcome to the **Laptop & RAM Price Intelligence Data Warehouse** repository! 🚀  
This project demonstrates a modern, end-to-end PostgreSQL data warehouse built using the **Medallion Architecture (Bronze → Silver → Gold)**. It ingests raw product listings for laptops and RAM modules, cleans and standardizes specifications, and delivers an analytical star schema for pricing and hardware upgrade intelligence.

---

## 🏗️ Data Architecture

The data architecture follows the **Medallion** pattern with three distinct layers:

```text
  [ Source CSVs ] ──► [ Bronze Layer ] ──► [ Silver Layer ] ──► [ Gold Layer ] ──► [ Business Analytics ]
   (Raw Files)         (Raw Ingestion)      (Cleaned & Parsed)    (Star Schema)       (SQL Insights)
```

1. **Bronze Layer:** Stores raw data as-is from the source CSV files (`laptop_listing_raw`, `ram_listing_raw`). All columns are ingested as `TEXT` via SQL load scripts to preserve original source fidelity and prevent load failures.
2. **Silver Layer:** Performs data cleansing, standardization, and enrichment (`laptop_product`, `ram_module`). Standardizes brand names, casts price strings into numeric formats, and parses RAM capacity, generation, and form factor from unstructured spec text.
3. **Gold Layer:** Houses business-ready data modeled into a **Star Schema** (`dim_laptop`, `dim_ram_module`, `fact_laptop_price`, `fact_ram_price`) alongside an analytical candidate-matching view (`vw_ram_upgrade_candidates`).

*Editable Draw.io architecture diagram: `docs/architecture/laptop_ram_warehouse.drawio`*

---

## 📖 Project Overview

This project builds an analytical foundation for a laptop retailer or repair/upgrade service to evaluate device pricing, component unit economics, and memory upgrade potential.

### Key Project Components:
* **Data Architecture:** Designing a three-layer Medallion warehouse in PostgreSQL.
* **ETL Pipelines:** Writing SQL load scripts (`bronze.load_bronze()`) and transformation stored procedures (`silver.load_silver()`) to ingest, clean, parse, and transform raw listing data.
* **Data Modeling:** Structuring dimension tables, fact tables, and upgrade-matching views in the Gold layer.
* **Data Quality & Analytics:** Validating transformations via automated SQL checks and answering core business questions.

---

## 🎯 Business Requirements & Objectives

### Objective
Develop a PostgreSQL data warehouse to compare laptop prices and memory configurations, evaluate RAM module unit costs, and identify viable laptop-to-RAM upgrade pairings.

### Analytical Questions Answered
* **Brand Pricing:** How do listed laptop prices compare across different brands?
* **Installed Memory:** How much installed RAM do listed laptops currently ship with?
* **Upgrade Headroom:** Which laptop listings advertise a higher stated maximum RAM than their installed RAM?
* **Catalogue Composition:** What RAM generations, capacities, and form factors exist in the RAM catalogue?
* **Cost Efficiency:** What is the listed price per GB for each RAM module?
* **Upgrade Candidates:** Which laptop and RAM module combinations represent potential upgrade matches based on available specifications?

---

## 📂 Data Sources & Specifications

The warehouse is built from two static e-commerce product-listing CSV files:

| File Path | Rows | Granularity |
| :--- | :---: | :--- |
| `data/source/laptop_ram_trend.csv` | 379 | One laptop listing |
| `data/source/Ram_Prices.csv` | 22 | One RAM-module listing |

* **Source Schema:** Both files share `Brand`, `Name`, `Current Price`, `Lowest Price`, `Highest Price`, `Features`, `Specs`, `Best Buy Link`, and `Product URL`.
* **Source Provenance:** Product URLs reference **PriceBefore** product pages. Original scraper scripts and extraction timestamps were not supplied with the source datasets; local Python profiling scripts are strictly separated from data collection (see `docs/SOURCE_ATTRIBUTION.md`).

---

## 🛠️ Tools & Prerequisites

* **PostgreSQL (14+):** Core relational database engine hosting the Bronze, Silver, and Gold schemas.
* **pgAdmin 4 / psql:** Database management and SQL script execution.
* **Python (3.9+) & Pandas:** Exploratory data profiling and source file validation.
* **Draw.io:** System and data flow diagramming.
* **VS Code:** Development environment for SQL, Python, and Markdown documentation.

---

## 🚀 Execution Order

Run the SQL scripts from `scripts/` in **pgAdmin 4** (or `psql`) in the exact sequence below:

1. `scripts/01_create_schemas_and_bronze.sql` — Creates `bronze`, `silver`, and `gold` schemas and raw Bronze tables.
2. `scripts/02_load_bronze.sql` *(and `CALL bronze.load_bronze();` if using a stored procedure)* — Loads `laptop_ram_trend.csv` and `Ram_Prices.csv` directly into the Bronze tables.
3. `scripts/03_create_silver_tables.sql` — Creates cleaned Silver tables with typed columns.
4. `scripts/04_load_silver.sql` — Creates the Silver transformation stored procedure.
5. `CALL silver.load_silver();` — Executes the Bronze-to-Silver ETL pipeline.
6. `scripts/05_create_gold_views.sql` — Builds Gold dimension, fact, and upgrade candidate views.
7. `scripts/06_quality_checks.sql` — Runs data integrity and transformation validation tests.
8. `scripts/07_analytics.sql` — Executes business intelligence queries.

---

## ⚠️ Important Data Limitations

* **Static Snapshot:** The CSVs represent a single point-in-time collection of listings, not a historical time series.
* **Supplied Price Bounds:** `Lowest Price` and `Highest Price` are static fields provided by the source; their difference does not measure tracked price volatility over time. *(Tracking true price movement requires periodic re-collection of the same Product URLs with dated observation records).*
* **No Commercial Metrics:** Sales volume, inventory levels, wholesale cost, and profit margins are unavailable and excluded from calculations.
* **Hardware Verification Required:** Upgrade matches in `vw_ram_upgrade_candidates` reflect specification alignment only—not a physical compatibility guarantee. Always confirm physical memory slot availability, soldered RAM configurations, supported clock speeds, and OEM specifications before recommending an upgrade.

---

## 📁 Repository Structure

```text
laptop-ram-price-intelligence-dw/
├── data/
│   └── source/                  # Raw input datasets (laptop_ram_trend.csv, Ram_Prices.csv)
├── docs/
│   ├── architecture/            # Draw.io data warehouse diagram
│   └── buisness problem.md    # Source origin and provenance details
├── scripts/                     # SQL ETL, DDL, QA, analytics & Python profiling scripts
└── README.md                    # Project overview and documentation
```
