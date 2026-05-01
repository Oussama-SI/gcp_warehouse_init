
-- Create Table From Query (CTAS)
CREATE OR REPLACE TABLE `covid.oxford_policy_tracker`
PARTITION BY date
OPTIONS (
  partition_expiration_days = 2175
)
AS
SELECT *
FROM `bigquery-public-data.covid19_govt_response.oxford_policy_tracker`
WHERE alpha_3_code NOT IN ('GBR', 'BRA', 'CAN', 'USA');


-- create dataset
CREATE SCHEMA IF NOT EXISTS `covid`;

-- Create Table From Query (CTAS)
CREATE OR REPLACE TABLE `covid_data.country_area_data`
AS
SELECT * FROM `bigquery-public-data.census_bureau_international.country_names_area`


-- mobility_data
CREATE OR REPLACE TABLE `covid_data.mobility_data`
AS
SELECT * FROM `bigquery-public-data.covid19_google_mobility.mobility_report`

-- clean rows with empty contries and population 
DELETE FROM `covid_data.oxford_policy_tracker_by_countries`
where population IS NULL OR country_area IS NULL;


-- ETL
MERGE `covid.cases` T
USING `staging.covid_updates` S
ON T.country = S.country AND T.report_date = S.report_date
WHEN MATCHED THEN
  UPDATE SET confirmed_cases = S.confirmed_cases
WHEN NOT MATCHED THEN
  INSERT (country, report_date, confirmed_cases)
  VALUES (S.country, S.report_date, S.confirmed_cases);

-- MetaData
SELECT *
FROM `covid.INFORMATION_SCHEMA.TABLES`;


SELECT 
    name,
    SUM(ps.product_qty) FILTER (WHERE type = 'product') AS products_number,
    STRING_AGG(c.name, ', ') AS categories,
    EXTRACT(DAY FROM ps.date) AS last_modified,
    COALESCE(DATE_DIFF(CURRENT_DATE(), ps.create_date, DAY), 0) AS product_age,
    RANK() OVER (ORDER BY MAX(ps.sold_price) DESC) AS classement
FROM (
    SELECT * EXCEPT(weight, price, color_ids, missions, warehouse_id)
    FROM orduct_set.product_stock
) AS ps
LEFT JOIN staging.product_category c 
    ON ps.categ_id = c.id
WHERE active = TRUE
GROUP BY 
    name,
    ps.date,
    ps.create_date,
    ps.sold_price
ORDER BY products_number ASC;


WITH ps AS (
  SELECT * EXCEPT(weight, price, color_ids, missions, warehouse_id)
  FROM product_set.product_stock
)

SELECT 
    name,
    SUM(IF(type = 'product', ps.product_qty, 0)) AS products_number,
    STRING_AGG(c.name, ', ') AS categories,
    MAX(ps.date) AS last_modified,
    COALESCE(DATE_DIFF(CURRENT_DATE(), ps.create_date, DAY), 0) AS product_age,
    RANK() OVER (ORDER BY MAX(ps.sold_price) DESC) AS classement
FROM ps
LEFT JOIN staging.product_category c 
    ON ps.categ_id = c.id
WHERE active = TRUE
GROUP BY 
    name,
    ps.create_date
ORDER BY products_number ASC;

