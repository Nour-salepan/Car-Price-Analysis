-- checking for missing values in each column
SELECT 
    COUNT(*) FILTER (WHERE brand IS NULL) AS missing_brand,
    COUNT(*) FILTER (WHERE year IS NULL) AS missing_year,
    COUNT(*) FILTER (WHERE engine_size IS NULL) AS missing_engine_size,
    COUNT(*) FILTER (WHERE price IS NULL) AS missing_price
FROM car_prices;

-- finding duplicate entries based on all columns except the primary key
SELECT brand, model, year, engine_size, fuel_type, transmission, mileage, condition, COUNT(*) AS duplicates
FROM car_prices
GROUP BY brand, model, year, engine_size, fuel_type, transmission, mileage, condition
HAVING COUNT(*) > 1;



-- 1 Find the average price of cars for each brand.
SELECT brand, AVG(price) AS average_price
FROM car_prices
GROUP BY brand
ORDER BY average_price desc;
-- using window function
SELECT DISTINCT
    brand,
    AVG(price) over(PARTITION BY brand) AS average_price
FROM car_prices
ORDER BY 2 DESC;

-- 2 Count how many cars exist for each transmission type.
SELECT  
    transmission, 
    Count(*) AS car_count
FROM 
    car_prices
GROUP BY transmission
ORDER BY car_count DESC;

-- 3 Show the average mileage of cars grouped by their condition (New, Used, etc.).
SELECT 
    condition, 
    AVG(mileage) AS average_mileage 
FROM car_prices
GROUP BY condition
ORDER BY average_mileage DESC;

-- 4 Find the newest model year available for each brand.
SELECT 
    brand, 
    MAX(year) AS most_recent_model_year
FROM car_prices
GROUP BY brand
ORDER BY most_recent_model_year DESC;

-- 5 List the top 5 most expensive cars along with their brand and model.
SELECT 
    brand, 
    model, 
    price
FROM car_prices
ORDER BY price DESC
LIMIT 5;

--  using window function
SELECT DISTINCT
    brand,
    model,
    price,
    RANK() OVER (ORDER BY price DESC) AS price_rank 
FROM car_prices
ORDER BY price_rank
LIMIT 10;

--part two: quit challenging queries
    SELECT 
        avg(price) as avg_price
    FROM car_prices
 

-- List all cars whose price is above the overall dataset average.

SELECT 
    brand, 
    model, 
    price
FROM car_prices
WHERE price > (SELECT AVG(price) FROM car_prices);

--  using cte
WITH avg_price_cte AS (
    SELECT AVG(price) AS avg_price
    FROM car_prices
)
SELECT 
    brand, 
    model, 
    price
FROM car_prices, avg_price_cte
WHERE car_prices.price > avg_price_cte.avg_price;


-- For each brand, show the minimum, maximum, and average price in one result.
SELECT 
    brand,
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    AVG(price) AS avg_price
FROM car_prices
GROUP BY brand
ORDER BY brand;

-- using window function
SELECT DISTINCT
    brand,
    MIN(price) OVER (PARTITION BY brand) AS min_price,
    MAX(price) OVER (PARTITION BY brand) AS max_price,
    AVG(price) OVER (PARTITION BY brand) AS avg_price
FROM car_prices
ORDER BY brand;

-- Find all cars that have mileage above the average mileage of their condition category.
WITH avg_mileage_cte AS (
    SELECT 
        condition, 
        AVG(mileage) AS avg_mileage
    FROM car_prices
    GROUP BY condition
)
SELECT 
    car_prices.*
FROM car_prices
JOIN avg_mileage_cte ON car_prices.condition = avg_mileage_cte.condition
WHERE car_prices.mileage > avg_mileage_cte.avg_mileage;

-- Determine whether engine size has a correlation with price by comparing price averages across engine size ranges (e.g., 0–2.0L, 2.0–3.0L, etc.).
WITH engine_size_ranges AS (
    SELECT 
        CASE 
            WHEN engine_size < 2.0 THEN '0-2.0L'
            WHEN engine_size >= 2.0 AND engine_size < 3.0 THEN '2.0-3.0L'
            WHEN engine_size >= 3.0 AND engine_size < 4.0 THEN '3.0-4.0L'
            ELSE '4.0L+'
        END AS engine_size_range,
        price
    FROM car_prices
)
SELECT 
    engine_size_range,
    AVG(price) AS average_price
FROM engine_size_ranges
GROUP BY engine_size_range
ORDER BY average_price DESC;