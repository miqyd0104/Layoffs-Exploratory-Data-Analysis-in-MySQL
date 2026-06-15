USE world_layoffs;

SELECT *
FROM layoffs_clean;

SELECT MIN(`date`) AS start_date,
       MAX(`date`) AS end_date
FROM layoffs_clean;

SELECT company,
       SUM(total_laid_off) AS total_laid_off
FROM layoffs_clean
GROUP BY company
ORDER BY total_laid_off DESC;

SELECT industry,
       SUM(total_laid_off) AS total_laid_off
FROM layoffs_clean
GROUP BY industry
ORDER BY total_laid_off DESC;
SELECT country,
       SUM(total_laid_off) AS total_laid_off
FROM layoffs_clean
GROUP BY country
ORDER BY total_laid_off DESC;



WITH monthly_totals AS
(
    SELECT DATE_FORMAT(`date`, '%Y-%m') AS month,
           SUM(total_laid_off) AS total_laid_off
    FROM layoffs_clean
    WHERE `date` IS NOT NULL
    GROUP BY DATE_FORMAT(`date`, '%Y-%m')
)

SELECT month,
       total_laid_off,
       SUM(total_laid_off) OVER(ORDER BY month) AS rolling_total_layoffs
FROM monthly_totals;


WITH company_year AS
(
    SELECT company,
           YEAR(`date`) AS year,
           SUM(total_laid_off) AS total_laid_off
    FROM layoffs_clean
    WHERE `date` IS NOT NULL
    GROUP BY company, YEAR(`date`)
),

company_rank AS
(
    SELECT company,
           year,
           total_laid_off,
           DENSE_RANK() OVER
           (
               PARTITION BY year
               ORDER BY total_laid_off DESC
           ) AS ranking
    FROM company_year
)

SELECT *
FROM company_rank
WHERE ranking <= 5
ORDER BY year, ranking;
































