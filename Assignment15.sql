create database testdb;
use testdb;
CREATE TABLE employees (
    emp_no      INT             NOT NULL,
    birth_date  DATE            NOT NULL,
    first_name  VARCHAR(14)     NOT NULL,
    last_name   VARCHAR(16)     NOT NULL,
    gender      ENUM ('M','F')  NOT NULL,    
    hire_date   DATE            NOT NULL,
    PRIMARY KEY (emp_no)
);

CREATE TABLE departments (
    dept_no     CHAR(4)         NOT NULL,
    dept_name   VARCHAR(40)     NOT NULL,
    PRIMARY KEY (dept_no),
    UNIQUE  KEY (dept_name)
);

CREATE TABLE dept_manager (
   emp_no       INT             NOT NULL,
   dept_no      CHAR(4)         NOT NULL,
   from_date    DATE            NOT NULL,
   to_date      DATE            NOT NULL,
   FOREIGN KEY (emp_no)  REFERENCES employees (emp_no)    ON DELETE CASCADE,
   FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
   PRIMARY KEY (emp_no,dept_no)
); 

CREATE TABLE dept_emp (
    emp_no      INT             NOT NULL,
    dept_no     CHAR(4)         NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no)  REFERENCES employees   (emp_no)  ON DELETE CASCADE,
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,dept_no)
);

CREATE TABLE titles (
    emp_no      INT             NOT NULL,
    title       VARCHAR(50)     NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,title, from_date)
); 

CREATE TABLE salaries (
    emp_no      INT             NOT NULL,
    salary      INT             NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no, from_date)
); 

-- Insert employees
INSERT INTO employees (emp_no, birth_date, first_name, last_name, gender, hire_date) VALUES
(1001, '1980-01-15', 'John', 'Doe', 'M', '2005-03-01'),
(1002, '1978-07-23', 'Jane', 'Smith', 'F', '2006-07-01'),
(1003, '1985-05-15', 'Robert', 'Brown', 'M', '2007-05-15'),
(1004, '1990-10-12', 'Alice', 'Davis', 'F', '2008-11-01'),
(1005, '1983-03-09', 'Charlie', 'Johnson', 'M', '2009-02-20'),
(1006, '1992-08-24', 'Eva', 'Martinez', 'F', '2010-09-12'),
(1007, '1976-04-05', 'Greg', 'Thomas', 'M', '2011-01-01');

-- Insert departments
INSERT INTO departments (dept_no, dept_name) VALUES
('d001', 'Human Resources'),
('d002', 'Finance'),
('d003', 'IT'),
('d004', 'Marketing');

-- Insert dept_manager
INSERT INTO dept_manager (emp_no, dept_no, from_date, to_date) VALUES
(1001, 'd001', '2005-03-01', '2010-03-01'),
(1002, 'd002', '2006-07-01', '2011-07-01'),
(1003, 'd003', '2007-05-15', '2012-05-15');

-- Insert dept_emp
INSERT INTO dept_emp (emp_no, dept_no, from_date, to_date) VALUES
(1001, 'd001', '2005-03-01', '2010-03-01'),
(1002, 'd002', '2006-07-01', '2011-07-01'),
(1003, 'd003', '2007-05-15', '2012-05-15'),
(1004, 'd001', '2008-11-01', '2013-11-01'),
(1004, 'd003', '2013-11-02', '2018-11-02'),
(1005, 'd002', '2009-02-20', '2014-02-20'),
(1006, 'd004', '2010-09-12', '2015-09-12'),
(1007, 'd001', '2011-01-01', '2016-01-01'),
(1007, 'd004', '2016-01-02', '2021-01-02');

-- Insert titles
INSERT INTO titles (emp_no, title, from_date, to_date) VALUES
(1001, 'HR Manager', '2005-03-01', '2010-03-01'),
(1002, 'Finance Manager', '2006-07-01', '2011-07-01'),
(1003, 'IT Manager', '2007-05-15', '2012-05-15'),
(1004, 'HR Specialist', '2008-11-01', '2013-11-01'),
(1005, 'Finance Specialist', '2009-02-20', '2014-02-20'),
(1006, 'Marketing Specialist', '2010-09-12', '2015-09-12'),
(1007, 'HR Manager', '2011-01-01', '2016-01-01'),
(1007, 'Marketing Manager', '2016-01-02', NULL);

-- Insert salaries
INSERT INTO salaries (emp_no, salary, from_date, to_date) VALUES
(1001, 60000, '2005-03-01', '2010-03-01'),
(1002, 70000, '2006-07-01', '2011-07-01'),
(1003, 80000, '2007-05-15', '2012-05-15'),
(1004, 50000, '2008-11-01', '2013-11-01'),
(1005, 55000, '2009-02-20', '2014-02-20'),
(1006, 65000, '2010-09-12', '2015-09-12'),
(1007, 90000, '2011-01-01', '2016-01-01'),
(1007, 95000, '2016-01-02', '2021-01-02');

-- Problem 1
-- Find the number of Male (M) and Female (F) employees in the database and order the counts in descending order.


SELECT gender, COUNT(*) AS num_employees
FROM employees
GROUP BY gender
ORDER BY num_employees DESC;

-- problem2
-- Find the average salary by employee title, round to 2 decimal places and order by descending order.
SELECT title, ROUND(AVG(salary), 2) AS avg_salary
FROM titles
JOIN salaries ON titles.emp_no = salaries.emp_no
GROUP BY title
ORDER BY avg_salary DESC;

-- Problem3
-- Find all the employees that have worked in at least 2 departments. Show their first name, last_name and the number of departments they work in. Display all results in ascending order

SELECT e.first_name, e.last_name, COUNT(de.dept_no) AS num_departments
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
GROUP BY e.emp_no
HAVING COUNT(de.dept_no) >= 2
ORDER BY e.first_name ASC, e.last_name ASC;

-- Problem 4

-- Display the first name, last name, and salary of the highest payed employee.

SELECT e.first_name, e.last_name, s.salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
ORDER BY s.salary DESC
LIMIT 1;

-- Problem 5

-- Display the first name, last name, and salary of the *second* highest payed employee.

SELECT e.first_name, e.last_name, s.salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
ORDER BY s.salary DESC
LIMIT 1 OFFSET 1;

-- Problem 6

-- Display the month and total hires for the month with the most hires. 

SELECT MONTH(hire_date) AS hire_month, COUNT(*) AS total_hires
FROM employees
GROUP BY hire_month
ORDER BY total_hires DESC
LIMIT 1;

-- Problem 7 

-- Display each department and the age of the youngest employee at hire date.

SELECT d.dept_name, MIN(YEAR(hire_date) - YEAR(birth_date)) AS youngest_age
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
GROUP BY d.dept_name;

-- Problem 8

-- Find all the employees that do not contain vowels in their first name and display the department they work in.

SELECT e.first_name, e.last_name, d.dept_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE e.first_name NOT REGEXP '[AEIOUaeiou]';