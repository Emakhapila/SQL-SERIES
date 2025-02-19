SELECT *
FROM dbo.layoffs ;


SELECT MAX(total_laid_off)
FROM dbo.layoffs ;

-- Looking at Percentage to see how big these layoffs were

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM dbo.layoffs ;


-- Which companies had 1 which is basically 100 percent of they company laid off
SELECT *
FROM dbo.layoffs
WHERE percentage_laid_off = 1 
ORDER BY total_laid_off DESC;
-- these are mostly startups it looks like who all went out of business during this time

-- Companies that had a lot of funding

SELECT *
FROM dbo.layoffs
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC ;
-- Britishvolt leads with the top amount in funding

-- Looking at the company and the sum of total laid off

SELECT company, SUM(total_laid_off) Sum_total_laid_off
FROM dbo.layoffs
GROUP BY company
ORDER BY 2 DESC ;

-- Looking at the date ranges

SELECT MIN([date]), MAX([date])
FROM dbo.layoffs ;

-- Looking at the industry most affected by layoffs

SELECT industry, SUM(total_laid_off) Sum_total_laid_off
FROM dbo.layoffs
GROUP BY industry
ORDER BY 2 DESC ;
-- Consumer Leading with the most layoffs and Manufucturing having the least amount of layoffs

-- Looking at the countries affected
 SELECT country, SUM(total_laid_off) Sum_total_laid_off
 FROM dbo.layoffs
 GROUP BY country
 ORDER BY 2 DESC;
 -- United states was the most affected. Poland was the least affected

 -- Date series

 SELECT [date], SUM(total_laid_off) Sum_total_laid_off
 FROM dbo.layoffs
 GROUP BY [date]
 ORDER BY 1 DESC ;

 -- Date Series by year

 SELECT YEAR([date]) Year_, SUM(total_laid_off) Sum_laid_off
 FROM dbo.layoffs
 GROUP BY YEAR([date])
 ORDER BY 1 DESC ;
 -- 2022 has the most number of layoffs


 -- Looking at the stage of the company

 SELECT stage company_stage, SUM(total_laid_off) Sum_laid_off
 FROM dbo.layoffs
 GROUP BY stage
 ORDER BY 2 DESC ;


 -- Rolling Total of layoffs

 WITH Rolling_Total 
 AS
 (
SELECT 
    SUBSTRING([date], 6, 2) AS [Month], 
    SUM(total_laid_off) AS Sum_laid_off
FROM dbo.layoffs
WHERE[date] IS NOT NULL
GROUP BY SUBSTRING([date], 6, 2)
)
SELECT [Month], Sum_laid_off,
SUM(Sum_laid_off) OVER(ORDER BY [Month]) AS Rolling_total
FROM Rolling_Total
ORDER BY [Month] ASC;

-- Using this(below) to rank which years they laid out the most employees
-- We want the highest one based off on the laid off to be ranked number one
-- We need o do a CTE
SELECT company, YEAR([date]) , SUM(total_laid_off) 
FROM dbo.layoffs
GROUP BY company, YEAR([date])
ORDER BY 3 DESC ;

WITH Company_Year (company,Years,Total_laid_off)
AS
(
	SELECT company, YEAR([date]), SUM(total_laid_off)
	FROM dbo.layoffs
	GROUP BY company, YEAR([date])
)
SELECT *, DENSE_RANK() OVER(PARTITION BY Years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE Years IS NOT NULL
ORDER BY Ranking;

-- Filtering on the ranking to return the top 5 companies per year by adding another CTE and querying on top of that


WITH Company_Year (company,Years,Total_laid_off)
AS
(
	SELECT company, YEAR([date]), SUM(total_laid_off)
	FROM dbo.layoffs
	GROUP BY company, YEAR([date])
), Company_Year_Rank
AS
(
	SELECT *, DENSE_RANK() OVER(PARTITION BY Years ORDER BY total_laid_off DESC) AS Ranking
	FROM Company_Year
	WHERE Years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5
;




