
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



