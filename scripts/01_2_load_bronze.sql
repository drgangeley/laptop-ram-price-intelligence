
CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE
    start_time TIMESTAMPTZ;
    end_time TIMESTAMPTZ;
    batch_start_time TIMESTAMPTZ;
    batch_end_time TIMESTAMPTZ;
BEGIN
    batch_start_time := clock_timestamp();

    RAISE NOTICE '================================================';
    RAISE NOTICE 'Loading Bronze Layer';
    RAISE NOTICE '================================================';

    RAISE NOTICE '------------------------------------------------';
    RAISE NOTICE 'Loading Laptop Data';
    RAISE NOTICE '------------------------------------------------';

    -- Load laptop listings
    start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating Table: bronze.laptop_listing_raw';
    TRUNCATE TABLE bronze.laptop_listing_raw;

    RAISE NOTICE '>> Inserting Data Into: bronze.laptop_listing_raw';
    COPY bronze.laptop_listing_raw
    FROM 'Your directory'
    WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

    end_time := clock_timestamp();
    RAISE NOTICE '>> Laptop Load Duration: % seconds',
        ROUND(EXTRACT(EPOCH FROM (end_time - start_time))::numeric, 2);
    RAISE NOTICE '>> -------------';

    RAISE NOTICE '------------------------------------------------';
    RAISE NOTICE 'Loading RAM Data';
    RAISE NOTICE '------------------------------------------------';

    -- Load RAM module listings
    start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating Table: bronze.ram_listing_raw';
    TRUNCATE TABLE bronze.ram_listing_raw;

    RAISE NOTICE '>> Inserting Data Into: bronze.ram_listing_raw';
    COPY bronze.ram_listing_raw
    FROM 'C:/Projects/Laptop_RAM_Price_Intelligence_Simple_SQL/data/source/Ram_Prices.csv'
    WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

    end_time := clock_timestamp();
    RAISE NOTICE '>> RAM Load Duration: % seconds',
        ROUND(EXTRACT(EPOCH FROM (end_time - start_time))::numeric, 2);
    RAISE NOTICE '>> -------------';

    batch_end_time := clock_timestamp();

    RAISE NOTICE '================================================';
    RAISE NOTICE 'Loading Bronze Layer is Completed';
    RAISE NOTICE 'Total Load Duration: % seconds',
        ROUND(EXTRACT(EPOCH FROM (batch_end_time - batch_start_time))::numeric, 2);
    RAISE NOTICE '================================================';

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '================================================';
        RAISE NOTICE 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        RAISE NOTICE 'Error Message: %', SQLERRM;
        RAISE NOTICE 'Error Code: %', SQLSTATE;
        RAISE NOTICE '================================================';
        RAISE;
END;
$$;


CALL bronze.load_bronze();
