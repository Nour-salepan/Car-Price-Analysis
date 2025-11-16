#  Car Price Analysis Using SQL

*A Beginner-Friendly SQL Portfolio Project*

[the dataset url](https://www.kaggle.com/datasets/ayeshasiddiqa123/cars-pre)

## 📌 Project Overview

This project analyzes a real-world car price dataset using **PostgreSQL**.  
It demonstrates my skills in:

- SQL table design  
- Data cleaning and validation  
- Writing SQL queries (basic → advanced)  
- Performing data analysis  
- Presenting insights clearly  
- Building a professional GitHub project  

This is my **first SQL project**, created to showcase my SQL and analytical skills to employers.

##  Dataset Description

**File:** `car_price_prediction_.csv`

| Column | Description |
|--------|-------------|
| car_id | Unique ID of each listing |
| brand | Car manufacturer |
| model | Model name |
| year | Manufacturing year |
| engine_size | Engine capacity (L) |
| fuel_type | Petrol, Diesel, Electric |
| transmission | Manual or Automatic |
| mileage | Distance traveled |
| condition | New / Used / Like New |
| price | Price in USD |

## 🧱 Database Schema (PostgreSQL)

```sql
CREATE TABLE car_prices (
    car_id INT,
    brand VARCHAR(50),
    model VARCHAR(50),
    year INT,
    engine_size FLOAT,
    fuel_type VARCHAR(20),
    transmission VARCHAR(20),
    mileage INT,
    condition VARCHAR(20),
    price FLOAT
);
```

## 🧹 Data Cleaning Queries

### 1. Check for missing values
```sql
SELECT 
    COUNT(*) FILTER (WHERE brand IS NULL) AS missing_brand,
    COUNT(*) FILTER (WHERE year IS NULL) AS missing_year,
    COUNT(*) FILTER (WHERE engine_size IS NULL) AS missing_engine_size,
    COUNT(*) FILTER (WHERE price IS NULL) AS missing_price
FROM car_prices;
```

### 2. Find duplicate records
```sql
SELECT 
    brand, model, year, engine_size, fuel_type, transmission, mileage, condition, 
    COUNT(*) AS duplicates
FROM car_prices
GROUP BY brand, model, year, engine_size, fuel_type, transmission, mileage, condition
HAVING COUNT(*) > 1;
```

## 📊 Analysis Queries (Basic to Advanced)

### 🟢 Basic Queries

#### 3. Average price per brand
```sql
SELECT brand, AVG(price) AS average_price
FROM car_prices
GROUP BY brand
ORDER BY average_price DESC;
```

#### 4. Count cars by transmission type
```sql
SELECT transmission, COUNT(*) AS car_count
FROM car_prices
GROUP BY transmission
ORDER BY car_count DESC;
```

#### 5. Average mileage by condition
```sql
SELECT condition, AVG(mileage) AS average_mileage
FROM car_prices
GROUP BY condition
ORDER BY average_mileage DESC;
```

#### 6. Newest model year per brand
```sql
SELECT brand, MAX(year) AS most_recent_model_year
FROM car_prices
GROUP BY brand
ORDER BY most_recent_model_year DESC;
```

#### 7. Top 10 most expensive cars
```sql
SELECT DISTINCT
    brand,
    model,
    price,
    RANK() OVER (ORDER BY price DESC) AS price_rank 
FROM car_prices
ORDER BY price_rank
LIMIT 10;
```

[top 10 most expensive cars](https://github.com/Nour-salepan/Car-Price-Analysis/blob/main/images/image-1)

### 🟡 Intermediate Queries

#### 8. Cars priced above dataset average
```sql
SELECT brand, model, price
FROM car_prices
WHERE price > (SELECT AVG(price) FROM car_prices);
```

#### 9. Min, max, and avg price per brand
```sql
SELECT brand, MIN(price) AS min_price, MAX(price) AS max_price, AVG(price) AS avg_price
FROM car_prices
GROUP BY brand
ORDER BY brand;
```

#### 10. Cars with mileage above average within their condition
```sql
WITH avg_mileage_cte AS (
    SELECT condition, AVG(mileage) AS avg_mileage
    FROM car_prices
    GROUP BY condition
)
SELECT cp.*
FROM car_prices cp
JOIN avg_mileage_cte a ON cp.condition = a.condition
WHERE cp.mileage > a.avg_mileage;
```

### 🔵 Advanced Queries

#### 11. Top 10 most expensive cars (Window Function)
```sql
SELECT DISTINCT
    brand,
    model,
    price,
    RANK() OVER (ORDER BY price DESC) AS price_rank 
FROM car_prices
ORDER BY price_rank
LIMIT 10;
```

#### 12. Brand-level price stats (Window Functions)
```sql
SELECT DISTINCT
    brand,
    MIN(price) OVER (PARTITION BY brand) AS min_price,
    MAX(price) OVER (PARTITION BY brand) AS max_price,
    AVG(price) OVER (PARTITION BY brand) AS avg_price
FROM car_prices
ORDER BY brand;
```

#### 13. Compare price across engine size ranges
```sql
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
SELECT engine_size_range, AVG(price) AS average_price
FROM engine_size_ranges
GROUP BY engine_size_range
ORDER BY average_price DESC;
```

## 📌 Key Insights

- Luxury brands show the highest average prices.  
- Mileage strongly affects used-vehicle pricing.  
- Engine size ranges reveal clear pricing patterns.  
- Newer model years usually have higher prices.  
- Electric and hybrid vehicles follow different pricing trends.

## 🛠️ Tools Used

- PostgreSQL  
- pgAdmin  
- VS Code  
- Git & GitHub  
- SQL (CTEs, window functions, aggregations)

## 📁 Project Structure

```
📦 car-price-sql-project
 ┣ 📄 README.md
 ┣ 📄 queries.sql
 ┣ 📄 schema.sql
 ┗ 📄 car_price_prediction_.csv
```

## ⭐ Support

If you find this project helpful, please star the repository!




