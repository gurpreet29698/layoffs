select *  from layoffs_staging2;

select max(total_laid_off)
from layoffs_staging2;

select * 
from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc;

select company, sum(total_laid_off) as total
from layoffs_staging2
group by company
order by total desc;

select industry, sum(total_laid_off) 
from layoffs_staging2
group by industry
order by 2 desc;

select country, sum(total_laid_off) 
from layoffs_staging2
group by country
order by 2 desc;

select min(`date`), max(`date`)
from layoffs_staging2;

select substr(`date`, 1, 7), sum(total_laid_off)
from layoffs_staging2
group by substr(`date`, 1,7)
order by 1 desc;

select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc;

select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;

with cumulative_total as 
(
select substr(`date`, 1, 7) as `month`, sum(total_laid_off) as total
from layoffs_staging2
where substr(`date`, 1, 7) is not null
group by substr(`date`, 1,7)
order by 1 desc
)
select `month`,total, sum(total) over(order by `month`) as cumulative_total
from cumulative_total;

select company, year(`date`), sum(total_laid_off) 
from layoffs_staging2
group by company, year(`date`)
order by 3 desc;

with company_year (company, years, total) as 
(
select company, year(`date`), sum(total_laid_off) 
from layoffs_staging2
group by company, year(`date`)
order by 3 desc
), company_year_rank as
(
select *,
dense_rank() over( partition by years order by total desc) as ranking
from company_year 
where years is not null
)
select * from company_year_rank
where ranking <=5;

with industry_year (industry, years, total) as 
(
select industry, year(`date`), sum(total_laid_off)
from layoffs_staging2
where industry is not null
group by industry,  year(`date`)
order by 3 desc
), industry_rank as
(
select *, 
dense_rank() over(partition by years order by total desc ) as ranking2
from industry_year
where years is not null
)
select * from industry_rank
where ranking2 <=3;

select * from layoffs_staging2;













