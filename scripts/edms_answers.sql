-- 1. 
-- edms database creation
create database edms;

\c edms;

-- create department table
create table department (
  dep_id integer not null primary key,
  dep_name varchar(20) not null,
  dep_location varchar(15) not null
);

-- create salary_grade table
create table salary_grade (
  grade integer not null primary key,
  min_salary integer not null,
  max_salary integer not null
);

-- create employees table
create table employees (
  emp_id integer not null primary key,
  emp_name varchar(15) not null,
  job_name varchar(10) not null,
  manager_id integer,
  hire_date date not null,
  salary decimal(10,2) not null,
  commission decimal(7,2),
  dep_id integer not null,
  foreign key (dep_id) references department(dep_id) on update cascade
);

--insert department data
insert into department
values 
(1001, 'FINANCE', 'SYDNEY'),
(2001, 'AUDIT', 'MELBOURNE'),
(3001, 'MARKETING', 'PERTH'),
(4001, 'PRODUCTION', 'BRISBANE');

--insert salary_grade data
insert into salary_grade
values
(1,800,1300),
(2,1301,1500),
(3,1501,2100),
(4,2101,3100),
(5,3101,9999);


-- insert employees data
insert into employees
values
(68319,'KAYLING','PRESIDENT', null, '1991-11-18', 6000.00, null, 1001),
(66928, 'BLAZE', 'MANAGER', 68319, '1991-05-01', 2750.00, null, 3001),
(67832, 'CLARE', 'MANAGER', 68319, '1991-06-09', 2550.00, null, 1001),
(65646, 'JONAS', 'MANAGER', 68319, '1991-04-02', 2957.00, null, 2001),
(67858, 'SCARLET', 'ANALYST', 65646, '1997-04-19', 3100.00, null, 2001),
(69062 , 'FRANK' , 'ANALYST' , 65646 , '1991-12-03' , 3100.00 , null , 2001),
(63679 , 'SANDRINE' , 'CLERK' , 69062 , '1990-12-18' , 900.00 , null , 2001),
(64989 , 'ADELYN' , 'SALESMAN' , 66928 , '1991-02-20' , 1700.00 , 400.00 , 3001),
(65271 , 'WADE' , 'SALESMAN' , 66928 , '1991-02-22' , 1350.00 , 600.00 , 3001),
(66564 , 'MADDEN' , 'SALESMAN' , 66928 , '1991-09-28' , 1350.00 , 1500.00 , 3001),
(68454 , 'TUCKER' , 'SALESMAN' , 66928 , '1991-09-08' , 1600.00 , 0.00 , 3001),
(68736 , 'ADNRES' , 'CLERK' , 67858 , '1997-05-23' , 1200.00 , null , 2001),
(69000 , 'JULIUS' , 'CLERK' , 66928 , '1991-12-03' , 1050.00 , null , 3001),
(69324 , 'MARKER' , 'CLERK' , 67832 , '1992-01-23' , 1400.00 , null , 1001);

-- 2. No managers with salary between 1500 and 2500
select emp_name
from employees 
where job_name = 'MANAGER' and salary between 1500 and 2500;

-- 3. ADELYN AND MADDEN
select emp_name
from employees
where job_name = 'SALESMAN' and (salary + coalesce(commission,0.0)) > 2000;

-- 4. KAYLING, CLARE, AND MARKER
select emp_name
from employees a natural join department b
where dep_location='SYDNEY';

-- 5. SCARLET AND FRANK
select a.emp_name
from employees a inner join employees b 
on a.manager_id = b.emp_id
where a.salary > b.salary;

--6. WADE AND MADDEN
select emp_name
from employees a, salary_grade b
where b.grade = 2 
and (a.salary >= b.min_salary and a.salary <= b.max_salary) 
and a.job_name = 'SALESMAN';

--7.
--  emp_name | grade
-- ----------+-------
--  SANDRINE |     1
--  ADNRES   |     1
--  JULIUS   |     1
--  WADE     |     2
--  MADDEN   |     2
--  MARKER   |     2
--  ADELYN   |     3
--  TUCKER   |     3
--  BLAZE    |     4
--  CLARE    |     4
--  JONAS    |     4
--  SCARLET  |     4
--  FRANK    |     4
--  KAYLING  |     5
select a.emp_name, b.grade 
from employees a, salary_grade b 
where (a.salary >= b.min_salary and a.salary <= b.max_salary)
order by b.grade;

-- 8. BLAZE
select distinct(b.emp_name)
from employees a inner join employees b 
on a.manager_id = b.emp_id
where a.job_name='SALESMAN';


-- 9. AUDIT
select dep_name
from department
where dep_location = 'MELBOURNE';

-- 10. KAYLING AND BLAZE 
select b.emp_name
from employees a inner join employees b 
on a.manager_id = b.emp_id
group by b.emp_name
having count(b.emp_name) >= 3;

-- 11.
select emp_name, to_char((salary + (salary*0.15)),'$999G999D000') as "increased salary"
from  employees;

-- 12. 
select (emp_name || '-' || job_name) as "Employee & Job" 
from employees;

-- 13.
select emp_name, to_char(hire_date, 'Month DD, YYYY') as "Hire date"
from employees;

-- 14.
select emp_name
from employees
where date_part('month',hire_date) = 1;

-- 15.
select hire_date, job_name, emp_name
from employees
where hire_date < '1992-12-31';

-- 16.
select emp_id, emp_name, salary, age(now(),hire_date) as "YOE"
from employees
where age(now(),hire_date) > interval '10 years';

-- 17.
select emp_name
from employees
where emp_name ~ 'AR';

-- 18.
select grade, min_salary, max_salary,
  case 
  when (min_salary>2000 and max_salary<10000) then 'Supervisor'
  when (min_salary>1000 and max_salary<1999) then 'Team Leader'
  when (min_salary>700 and max_salary<999) then 'Administrative'
  else ''
  end as "nature of task"
from salary_grade;

-- 19.
select emp_name, emp_id, salary, coalesce(commission,0.0) as commission
from employees;

-- 20.
select * 
from employees
where commission is not null;






