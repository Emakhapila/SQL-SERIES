SELECT TOP (1000) [company]
      ,[location]
      ,[industry]
      ,[total_laid_off]
      ,[percentage_laid_off]
      ,[date]
      ,[stage]
      ,[country]
      ,[funds_raised_millions]
  FROM [Staff_Layoffs].[dbo].[layoffs]

  SELECT *
  FROM dbo.layoffs ;


  -- 1. Remove Duplicates
  -- 2. Standardise the data
  -- 3. Null Values
  -- 4. Remove Any Columns


 SELECT *
INTO layoffs_staging
FROM layoffs
WHERE 1 = 0;

SELECT *
FROM dbo.layoffs_staging ;

-- Removing Duplicates
/* Comma After SELECT *:

You need a comma (,) after SELECT * to separate the columns from the ROW_NUMBER() function. 
ORDER BY Clause in ROW_NUMBER():

The ROW_NUMBER() window function requires an ORDER BY clause within the OVER() clause. 
If you don't care about the order, you can use ORDER BY (SELECT NULL) as a placeholder.
Backticks for Column Names:

In SQL Server, use square brackets [] instead of backticks ` for column names. 
For example, [date] is the correct way to reference the date column.

What This Query Does
The ROW_NUMBER() function assigns a unique number to each row within the specified partition.

The PARTITION BY clause groups the rows by the columns company, industry, total_laid_off, percentage_laid_off, and [date].

The ORDER BY (SELECT NULL) ensures that the rows are numbered arbitrarily within each partition.*/

SELECT *,
    ROW_NUMBER() OVER(
        PARTITION BY company, industry, total_laid_off, percentage_laid_off, [date]
        ORDER BY (SELECT NULL)
    ) AS row_num
FROM dbo.layoffs;

-- This will return only the duplicate rows.

WITH duplicate_cte AS (
SELECT *,
	 ROW_NUMBER() OVER(
        PARTITION BY company, industry, total_laid_off, percentage_laid_off, [date],country, funds_raised_millions,stage
        ORDER BY (SELECT NULL)
) AS row_num
FROM dbo.layoffs
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1 ;


SELECT *
FROM dbo.layoffs
WHERE company = 'Casper' ;

/* Step 2: Delete Duplicates
To delete the duplicates, modify the query to use a DELETE statement instead of SELECT. 
CTE Approach:

The WITH CTE clause defines a Common Table Expression that assigns a row_num to each row within the specified partition.

The DELETE FROM CTE statement deletes rows where row_num > 1 (i.e., duplicates).*/

WITH duplicate_cte AS (
SELECT *,
	ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, percentage_laid_off, [date],country, funds_raised_millions,stage
	ORDER BY(SELECT NULL)
    ) AS row_num
FROM dbo.layoffs
)
DELETE 
FROM duplicate_cte 
WHERE row_num > 1 ;

SELECT *
FROM dbo.layoffs ;


-- 2. Standardising data - Finding issues in the data and fixing them

SELECT company, TRIM(company) Trim_company
FROM dbo.layoffs ;


-- Updating the table

UPDATE dbo.layoffs
SET company = TRIM(company) ;

-- Looking at the industry

SELECT *
FROM dbo.layoffs
WHERE industry LIKE 'Crypto%' ;

-- Updating the industry

UPDATE dbo.layoffs
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%' ;

-- Checking to see if it worked

SELECT DISTINCT industry
FROM dbo.layoffs ;

-- Looking at Location

SELECT *
FROM dbo.layoffs ;

SELECT DISTINCT [location]
FROM dbo.layoffs
ORDER BY 1 ;

-- Looking at country

SELECT DISTINCT country
FROM dbo.layoffs
ORDER BY 1 ;

-- Using a Trim to fix
-- Using trailing to get rid of the period

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country) AS country
FROM dbo.layoffs
ORDER BY 1 ;

UPDATE dbo.layoffs
SET country =  TRIM(TRAILING '.' FROM country)   
WHERE country LIKE 'United States%' ;

-- Checking to see if it worked 

SELECT DISTINCT country
FROM dbo.layoffs
ORDER BY 1 ;


-- Time series change

SELECT [date],
	CONVERT(DATE, [date], 101) AS Converted_date
FROM dbo.layoffs ;

UPDATE dbo.layoffs
SET [date] = CONVERT(DATE, [date], 101) ;

SELECT *
FROM dbo.layoffs ;


-- 3. Working with Nulls and blank values

SELECT *
FROM dbo.layoffs
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


SELECT *
FROM dbo.layoffs
WHERE industry IS NULL
OR industry = '' ;

-- Try to see if any of those columns have data that is populatable

SELECT *
FROM dbo.layoffs
WHERE company = 'Airbnb' ;

-- Populating using the travel industry

SELECT *
FROM dbo.layoffs d1
JOIN dbo.layoffs d2
	ON	d1.location = d2.location
	AND d1.company = d2.company
WHERE (d1.industry IS NULL OR d1.industry = ''  )
AND d2.industry IS NOT NULL;


UPDATE dbo.layoffs
SET industry = NULL
WHERE industry = '' ;



UPDATE  d1
SET d1.industry = d2.industry
FROM dbo.layoffs d1
JOIN dbo.layoffs d2
	ON d1.company = d2.company
WHERE (d1.industry IS NULL OR d1.industry = '')
AND d2.industry IS NOT NULL ;



-- 4. Removing columns and rows that are necessary.

SELECT *
FROM dbo.layoffs 
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL ;

DELETE 
FROM dbo.layoffs 
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL ;


SELECT *
FROM dbo.layoffs ;



