/** Data cleaning **/

select * from layoffs;

create table layoffs_staging
like layoffs;

insert layoffs_staging
select * from layoffs;

select * from layoffs_staging;

/** Removing duplicates **/

select *,
row_number() over
(
partition by company, location, industry,total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
) as row_num
from layoffs_staging;

with dupli_cte as
(
select *,
row_number() over(
partition by company, location, industry,total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
) as row_num
from layoffs_staging
)
select * 
from dupli_cte
where row_num > 1;


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from layoffs_staging2;

insert into layoffs_staging2
select * ,
row_number() over(
partition by company, location, industry,total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
) as row_num
from layoffs_staging;

select * from layoffs_staging2
where row_num > 1;

delete 
from layoffs_staging2
where row_num > 1;

select * from layoffs_staging2;

/** standardization of data **/

select distinct company, trim(company)
from layoffs_staging2;

update layoffs_staging2
set company = trim(company);

select distinct location
 from layoffs_staging2;

select distinct industry
from layoffs_staging2
order by 1;

select * from layoffs_staging2
where industry like 'Crypto%';

update layoffs_staging2
set industry = 'Crypto'
where industry like'Crypto%';

select * from layoffs_staging2
where industry like 'Crypto%';

select distinct industry
 from layoffs_staging2
 order by 1;

select distinct country
from layoffs_staging2
order by country asc;

select distinct country
from layoffs_staging2
where country like 'United States%';

update layoffs_staging2
set country = 'United States'
where country like 'United States%';

update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

alter table layoffs_staging2
modify column `date` date;

update layoffs_staging2
set industry = null
where industry = '';

select *
from layoffs_staging2
where industry is null;

select * from  layoffs_staging2
where company = 'Airbnb';

select * from layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company = t2.company and t1.location = t2.location
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

update layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company = t2.company and t1.location = t2.location
set t1.industry = t2.industry
where t1.industry is null 
and t2.industry is not null;

select * from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

delete from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

select * from layoffs_staging2;

alter table layoffs_staging2
drop column row_num;

select * from layoffs_staging2;


































