create database projects;

use projects;
select * from hr;

alter table hr
change column ï»¿id emp_id varchar(20) not null;

describe hr;

select birthdate from hr;

set sql_safe_updates =0;

-- how to update the date format
update hr 
set birthdate = case 
when birthdate like '%/%' then date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
when birthdate like '%-%' then date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
else null
end;

alter table hr
modify column birthdate date;

-- how to update the date format
update hr
set hire_date = case
when hire_date like '%/%' then date_format( str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
when hire_date like '%-%' then date_format( str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
else null
end;

alter table hr
modify column hire_date date;

select hire_date from hr;
select termdate from hr;

-- how to update the date format
UPDATE hr
SET termdate = DATE(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS not NULL
  AND termdate != ' '
  AND termdate != ' ';

UPDATE hr
SET termdate = NULL where termdate = '0000-00-00';

alter table hr
modify column termdate date;

alter table hr
add column age int;

-- how to calculate the age 
update hr
set age = timestampdiff(Year, birthdate, curdate());

select birthdate, age from hr;

-- how to find the minimum age and maximum age
select min(age) as youngest,
 max(age) as oldest
 from hr;
 
 select distinct(count(*)) as total_count from hr where age>18;
 
 select count(termdate) as termdated_count from hr where age>18;

 
 
 -- 1. What is the gender breakdown of employees in the company?
select gender, count(*) as count
from hr 
where termdate is null and age >= 18
group by gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?
select race, count(*) as count 
from hr 
where termdate is null and age >= 18
group by race
order by count(*) desc;


-- 3. What is the age distribution of employees in the company?
select min(age) as Youngest,
max(age) as Oldest
from hr
where termdate is null and age >= 18;

select
case 
when age >= 18 and age <= 24 then '18-24'
when age >= 25 and age <= 34 then '25-34'
when age >= 35 and age <= 44 then '35-44'
when age >= 45 and age <= 54 then '45-54'
when age >= 55 and age <= 64 then '55-64'

else '+65'
end as Age_Group, 
count(*) as count
from hr
where termdate is null and age >= 18
group by Age_Group
order by Age_Group;




-- -- 3. What is the Gender-Age distribution of employees in the company?
select
case 
when age >= 18 and age <= 24 then '18-24'
when age >= 25 and age <= 34 then '25-34'
when age >= 35 and age <= 44 then '35-44'
when age >= 45 and age <= 54 then '45-54'
when age >= 55 and age <= 64 then '55-64'

else '+65'
end as Age_Group , gender, 
count(*) as count
from hr
where termdate is null and age >= 18
group by Age_Group, gender
order by Age_Group, gender;



-- 4. How many employees work at headquarters versus remote locations?

select location, count(*) as count
 from hr
 where termdate is null and age >= 18
 group by location;
 
 
 -- 5. What is the average length of employment for employees who have been terminated?

select 
avg(datediff(termdate, hire_date))/365 as avg_lenght_employment 
from hr where termdate <= curdate() and age >= 18;

-- How does the gender distribution vary across departments ?

select department, gender, count(*) as count 
from hr
where termdate is null and age >= 18
 group by department, gender
 order by department;

 -- 7. What is the distribution of job titles across the company?
select jobtitle, gender, count(*) as count 
from hr
where termdate is null and age >= 18
 group by jobtitle, gender
 order by jobtitle Desc;
 
 
 -- 8. Which department has the highest turnover rate?
select department,
total_count,
terminated_count,
terminated_count/total_count as termination_rate
from (
select department,
count(*) as total_count,
sum( case when termdate <= curdate() then 1 else 0 end ) as terminated_count
from hr
where age >= 18
group by department
) as subquery
order by termination_rate desc;


-- 9. What is the distribution of employees across locations by state?
select location_state, count(*) as count
from hr
where termdate is null and age >= 18
group by location_state
order by count desc;



-- 10. How has the company's employee count changed over time based on hire and term dates?

select 
year,
hires,
terminations,
hires-terminations as net_change,
round((hires-terminations)/hires *100, 2) as net_change_percent
from(
select 
year(hire_date) as year,
count(*) as hires,
sum(case when termdate <= curdate() then 1 else 0 end) as terminations
from hr
where age >= 18
group by year(hire_date)
) as subquery
order by year asc;

select termdate from hr;



-- 11. What is the tenure distribution for each department?
select department, round(avg(datediff(termdate, hire_date)/365), 2) as avg_tenure
from hr
where  termdate <= curdate() and age >= 18
group by department;





