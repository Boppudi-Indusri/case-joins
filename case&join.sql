--Create three tables: employees (id, name, department_id, salary), departments (id, name), and contractors (id, name, hourly_rate).
 create table employees(id int primary key,name varchar(20),
    -> department_id int,
    -> salary decimal(10,2));
 create table departments(id int primary key,
    -> name varchar(20));

create table contractors(id int primary key,name varchar(20),
    -> hourly_rate decimal(10,2));
	
--2.Insert at least five rows into each table, ensuring that at least one department has no employees and at least one employee has no matching department.
INSERT INTO departments (id, name) VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Sales'),
(4, 'Finance'),
(5, 'Marketing');

INSERT INTO employees (id, name, department_id, salary) VALUES
(1, 'Ravi', 1, 35000),
(2, 'Priya', 2, 50000),
(3, 'Arun', 2, 45000),
(4, 'Sita', 3, 40000),
(5, 'Kiran', 4, 55000),
(6, 'Rahul', 99, 30000);

INSERT INTO contractors (id, name, hourly_rate) VALUES
(1, 'John', 500),
(2, 'Meena', 650),
(3, 'David', 750),
(4, 'Anil', 600),
(5, 'Sneha', 800);

--3.Write an INNER JOIN query that returns employee name, department name, and salary for all employees that have a matching department.
select employees.name as emp_name,
    -> departments.name as dept_name,
    -> employees.salary as emp_sal
    -> from employees
    -> inner join departments
    -> on employees.department_id=departments.id;
--4.Write a LEFT JOIN query that returns all departments and the names of employees belonging to each department, displaying NULL for employee fields where a department has no staff.
 select departments.name,employees.name
    -> from employees
    -> left join
    -> departments
    -> on
    -> departments.id=employees.department_id;
	
--5.Write a query using a CASE expression to add a derived column salary_band that categorizes employee salaries as 'Low' (< 50000), 'Medium' (50000‑100000), or 'High' (> 100000).
SELECT
    name,
    salary,
    CASE
        WHEN salary < 50000 THEN 'Low'
        WHEN salary BETWEEN 50000 AND 100000 THEN 'Medium'
        WHEN salary > 100000 THEN 'High'
    END AS salary_band
FROM employees;
--6.Combine a LEFT JOIN with the previous CASE expression to produce a report showing department name, employee name, and salary band, including departments without employees.

SELECT
    departments.name AS department_name,
    employees.name AS employee_name,
    CASE
        WHEN employees.salary < 50000 THEN 'Low'
        WHEN employees.salary BETWEEN 50000 AND 100000 THEN 'Medium'
        WHEN employees.salary > 100000 THEN 'High'
    END AS salary_band
FROM departments
LEFT JOIN employees
    ON departments.id = employees.department_id;
	
--7.Write a FULL OUTER JOIN (or equivalent UNION of LEFT and RIGHT joins if the RDBMS lacks FULL) between employees and contractors that lists all individuals, a column indicating the source table ('Employee' or 'Contractor'), and applies a CASE expression to label the compensation as 'Salary' for employees and 'Hourly' for contractors
SELECT
    employees.name AS individual_name,
    'Employee' AS source_table,
    employees.salary AS compensation,
    CASE
        WHEN employees.id IS NOT NULL THEN 'Salary'
        ELSE 'Hourly'
    END AS compensation_type
FROM employees
LEFT JOIN contractors
    ON employees.id = contractors.id

UNION

SELECT
    contractors.name AS individual_name,
    'Contractor' AS source_table,
    contractors.hourly_rate AS compensation,
    CASE
        WHEN contractors.id IS NOT NULL THEN 'Hourly'
        ELSE 'Salary'
    END AS compensation_type
FROM employees
RIGHT JOIN contractors
    ON employees.id = contractors.id;