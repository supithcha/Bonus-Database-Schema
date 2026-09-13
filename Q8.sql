DROP DATABASE IF EXISTS ConnectXPortalWebsiteforResellers;
CREATE DATABASE IF NOT EXISTS ConnectXPortalWebsiteforResellers;

-- ============================================================================
-- 1. SCHEMA
-- ============================================================================

DROP TABLE IF EXISTS Bonus;
DROP TABLE IF EXISTS Title;
DROP TABLE IF EXISTS Worker;

CREATE TABLE Worker (
    WORKER_ID     INT PRIMARY KEY,
    FIRST_NAME    VARCHAR(50)    NOT NULL,
    LAST_NAME     VARCHAR(50)    NOT NULL,
    SALARY        DECIMAL(12,2)  NOT NULL,   -- annual salary
    JOINING_DATE  DATETIME       NOT NULL,
    DEPARTMENT    VARCHAR(50)    NOT NULL
);

CREATE TABLE Bonus (
    BONUS_ID       INT PRIMARY KEY,           -- surrogate key; not in source CSV
    WORKER_REF_ID  INT            NOT NULL,   -- FK -> Worker.WORKER_ID
    BONUS_AMOUNT   DECIMAL(12,2)  NOT NULL,
    BONUS_DATE     DATETIME       NOT NULL,
    CONSTRAINT fk_bonus_worker FOREIGN KEY (WORKER_REF_ID) REFERENCES Worker(WORKER_ID)
);

CREATE TABLE Title (
    WORKER_REF_ID  INT           NOT NULL,   -- FK -> Worker.WORKER_ID
    WORKER_TITLE   VARCHAR(50)   NOT NULL,
    AFFECTED_FROM  DATETIME      NOT NULL,
    PRIMARY KEY (WORKER_REF_ID),
    CONSTRAINT fk_title_worker FOREIGN KEY (WORKER_REF_ID) REFERENCES Worker(WORKER_ID)
);


-- ============================================================================
-- 2. SAMPLE DATA (from the supplied Worker.csv / Bonus.csv / Title.csv)
-- ============================================================================

INSERT INTO Worker (WORKER_ID, FIRST_NAME, LAST_NAME, SALARY, JOINING_DATE, DEPARTMENT) VALUES
(1,  'Monika',   'Arora',    100000, '2014-02-20 09:00:00', 'HR'),
(2,  'Niharika', 'Verma',    80000,  '2014-06-11 09:00:00', 'Admin'),
(3,  'Vishal',   'Singhal',  300000, '2014-02-20 09:00:00', 'HR'),
(4,  'Amitabh',  'Singh',    500000, '2014-02-20 09:00:00', 'Admin'),
(5,  'Vivek',    'Bhati',    500000, '2014-06-11 09:00:00', 'Admin'),
(6,  'Vipul',    'Diwan',    200000, '2014-06-11 09:00:00', 'Account'),
(7,  'Satish',   'Kumar',    75000,  '2014-01-20 09:00:00', 'Account'),
(8,  'Geetika',  'Chauhan',  90000,  '2014-04-11 09:00:00', 'Admin'),
(9,  'Mo',       'Ar',       90000,  '2014-02-20 09:00:00', 'Account'),
(10, 'Ni',       'Ver',      80000,  '2014-06-11 09:00:00', 'Admin'),
(11, 'Vi',       'Sing',     300000, '2014-02-20 09:00:00', 'HR'),
(12, 'Ami',      'Singh',    500000, '2014-02-20 09:00:00', 'Admin'),
(13, 'Viv',      'Bha',      500000, '2014-06-11 09:00:00', 'Admin'),
(14, 'Vipul',    'Diwan',    200000, '2014-06-11 09:00:00', 'Admin'),
(15, 'Satish',   'Kumar',    75000,  '2014-01-20 09:00:00', 'Account'),
(16, 'Gee',      'Cha',      85000,  '2014-04-11 09:00:00', 'Account');

INSERT INTO Bonus (BONUS_ID, WORKER_REF_ID, BONUS_AMOUNT, BONUS_DATE) VALUES
(1, 1, 5000, '2016-02-20 00:00:00'),
(2, 2, 3000, '2016-06-11 00:00:00'),
(3, 3, 4000, '2016-02-20 00:00:00'),
(4, 1, 4500, '2016-02-20 00:00:00'),
(5, 2, 3500, '2016-06-11 00:00:00');

INSERT INTO Title (WORKER_REF_ID, WORKER_TITLE, AFFECTED_FROM) VALUES
(1, 'Manager',       '2016-02-20 00:00:00'),
(2, 'Executive',     '2016-06-11 00:00:00'),
(8, 'Executive',     '2016-06-11 00:00:00'),
(5, 'Manager',       '2016-06-11 00:00:00'),
(4, 'Asst. Manager', '2016-06-11 00:00:00'),
(7, 'Executive',     '2016-06-11 00:00:00'),
(6, 'Lead',          '2016-06-11 00:00:00'),
(3, 'Lead',          '2016-06-11 00:00:00');


-- ============================================================================
-- 3. PART A — REQUIRED QUERIES
-- ============================================================================

-- ----------------------------------------------------------------------------
-- A1. Average salary of each department
-- ----------------------------------------------------------------------------
SELECT
    DEPARTMENT,
    AVG(SALARY) AS AVG_SALARY
FROM Worker
GROUP BY DEPARTMENT;


-- ----------------------------------------------------------------------------
-- A2. Number of employees in each department, ordered most to least
-- ----------------------------------------------------------------------------
SELECT
    DEPARTMENT,
    COUNT(*) AS EMPLOYEE_COUNT
FROM Worker
GROUP BY DEPARTMENT
ORDER BY EMPLOYEE_COUNT DESC;


-- ----------------------------------------------------------------------------
-- A3. Employees who share the same salary as at least one other employee
-- ----------------------------------------------------------------------------
SELECT
    w.WORKER_ID,
    w.FIRST_NAME,
    w.LAST_NAME,
    w.SALARY
FROM Worker w
WHERE w.SALARY IN (
    SELECT SALARY
    FROM Worker
    GROUP BY SALARY
    HAVING COUNT(*) > 1
)
ORDER BY w.SALARY, w.WORKER_ID;


-- ----------------------------------------------------------------------------
-- A4. Department that pays the most total bonus
-- ----------------------------------------------------------------------------
SELECT
    w.DEPARTMENT,
    SUM(b.BONUS_AMOUNT) AS TOTAL_BONUS
FROM Bonus b
JOIN Worker w ON w.WORKER_ID = b.WORKER_REF_ID
GROUP BY w.DEPARTMENT
ORDER BY TOTAL_BONUS DESC
LIMIT 1;


-- ----------------------------------------------------------------------------
-- A5. Employee with the highest (salary + total bonus) in each department
-- ----------------------------------------------------------------------------
WITH EmployeeTotal AS (
    SELECT
        w.WORKER_ID,
        w.FIRST_NAME,
        w.LAST_NAME,
        w.DEPARTMENT,
        w.SALARY + COALESCE(SUM(b.BONUS_AMOUNT), 0) AS TOTAL_COMP
    FROM Worker w
    LEFT JOIN Bonus b ON b.WORKER_REF_ID = w.WORKER_ID
    GROUP BY w.WORKER_ID, w.FIRST_NAME, w.LAST_NAME, w.DEPARTMENT, w.SALARY
),
Ranked AS (
    SELECT
        *,
        RANK() OVER (PARTITION BY DEPARTMENT ORDER BY TOTAL_COMP DESC) AS rnk
    FROM EmployeeTotal
)
SELECT
    DEPARTMENT,
    FIRST_NAME,
    LAST_NAME,
    TOTAL_COMP
FROM Ranked
WHERE rnk = 1
ORDER BY DEPARTMENT;


-- ----------------------------------------------------------------------------
-- A6. Title with the highest combined salary in each department
-- ----------------------------------------------------------------------------
WITH WorkerTitle AS (
    SELECT
        w.WORKER_ID,
        w.DEPARTMENT,
        w.SALARY,
        COALESCE(t.WORKER_TITLE, 'Executive') AS TITLE
    FROM Worker w
    LEFT JOIN Title t ON t.WORKER_REF_ID = w.WORKER_ID
),
TitleTotal AS (
    SELECT
        DEPARTMENT,
        TITLE,
        SUM(SALARY) AS TOTAL_SALARY
    FROM WorkerTitle
    GROUP BY DEPARTMENT, TITLE
),
Ranked AS (
    SELECT
        *,
        RANK() OVER (PARTITION BY DEPARTMENT ORDER BY TOTAL_SALARY DESC) AS rnk
    FROM TitleTotal
)
SELECT
    DEPARTMENT,
    TITLE,
    TOTAL_SALARY
FROM Ranked
WHERE rnk = 1
ORDER BY DEPARTMENT;
)
ORDER BY tt.DEPARTMENT;
