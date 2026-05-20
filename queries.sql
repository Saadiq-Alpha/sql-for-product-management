-- =========================================================================
-- TITLE: End-to-End SQL Basics & Relational Logic
-- PLATFORM: SQLBolt Training Track (Exercises 1 - 18 + Analytics Subqueries)
-- AUTHOR: Muhammad Saadiq
-- PURPOSE: Proof-of-work showcasing foundational data retrieval, multi-table 
--          joins, aggregations, database mutations, and cohort filtering.
-- =========================================================================

-- -------------------------------------------------------------------------
-- EXERCISE 1: Basic SELECT Queries
-- Focus: Understanding table scanning and isolating single/multiple variables.
-- -------------------------------------------------------------------------

-- Task 1: Find the title of each film
SELECT title 
FROM movies;

-- Task 2: Find the director of each film
SELECT director 
FROM movies;

-- Task 3: Find the title and director of each film
SELECT title, director 
FROM movies;

-- Task 4: Find the title and year of each film
SELECT title, year 
FROM movies;

-- Task 5: Find all the information about each film (Full Table Scan)
SELECT * FROM movies;


-- -------------------------------------------------------------------------
-- EXERCISE 2: Filtering with WHERE Constraints
-- Focus: Isolating specific cohorts using numerical boundaries and range conditions.
-- -------------------------------------------------------------------------

-- Task 1: Find the movie with a row id of 6
SELECT id, title 
FROM movies 
WHERE id = 6;

-- Task 2: Find the movies released in the years between 2000 and 2010
SELECT title 
FROM movies 
WHERE year BETWEEN 2000 AND 2010;

-- Task 3: Find the movies not released in the years between 2000 and 2010
SELECT title 
FROM movies 
WHERE year NOT BETWEEN 2000 AND 2010;

-- Task 4: Find the first 5 Pixar movies and their release year
SELECT title, year 
FROM movies 
WHERE year <= 2003;


-- -------------------------------------------------------------------------
-- EXERCISE 3: String Filtering (Wildcards & Pattern Matching)
-- Focus: Querying text fields using operators like LIKE and wildcards.
-- -------------------------------------------------------------------------

-- Task 1: Find all the Toy Story movies
SELECT title 
FROM movies 
WHERE title LIKE 'Toy Story%';

-- Task 2: Find all the movies directed by John Lasseter
SELECT title, director 
FROM movies 
WHERE director = 'John Lasseter';

-- Task 3: Find all the movies (and director) not directed by John Lasseter
SELECT title, director 
FROM movies 
WHERE director != 'John Lasseter';

-- Task 4: Find all the WALL-* movies
SELECT * FROM movies 
WHERE title LIKE 'WALL-%';


-- -------------------------------------------------------------------------
-- EXERCISE 4: Sorting & Pagination (ORDER BY, LIMIT, OFFSET)
-- Focus: Ranking results and handling data pagination for cleaner presentation.
-- -------------------------------------------------------------------------

-- Task 1: List all directors of Pixar movies (alphabetically), without duplicates
SELECT DISTINCT director 
FROM movies 
ORDER BY director ASC;

-- Task 2: List the last four Pixar movies released (ordered from most recent to least)
SELECT * FROM movies 
ORDER BY year DESC 
LIMIT 4;

-- Task 3: List the first five Pixar movies sorted alphabetically
SELECT * FROM movies 
ORDER BY title ASC 
LIMIT 5;

-- Task 4: List the next five Pixar movies sorted alphabetically (Pagination Logic)
SELECT * FROM movies 
ORDER BY title ASC 
LIMIT 5 OFFSET 5;


-- -------------------------------------------------------------------------
-- REVIEW 1: Comprehensive Selection Practice
-- Focus: Combining geo-filtering, coordinate sorting, and boundary checks.
-- -------------------------------------------------------------------------

-- Task 1: List all the Canadian cities and their populations
SELECT city, country, population 
FROM north_american_cities 
WHERE country = 'Canada';

-- Task 2: Order all the cities in the United States by their latitude from north to south
SELECT * FROM north_american_cities 
WHERE country = 'United States' 
ORDER BY latitude DESC;

-- Task 3: List all the cities west of Chicago, ordered from west to east
SELECT city, longitude 
FROM north_american_cities 
WHERE longitude < -87.629798 
ORDER BY longitude ASC;

-- Task 4: List the two largest cities in Mexico (by population)
SELECT * FROM north_american_cities 
WHERE country = 'Mexico' 
ORDER BY population DESC 
LIMIT 2;

-- Task 5: List the third and fourth largest cities (by population) in the US and their population
SELECT city, country, population 
FROM north_american_cities 
WHERE country = 'United States' 
ORDER BY population DESC 
LIMIT 2 OFFSET 2;


-- -------------------------------------------------------------------------
-- EXERCISE 6: Multi-Table Joins (INNER JOIN)
-- Focus: Combining related operational data (Movies) with commercial performance metrics (BoxOffice).
-- -------------------------------------------------------------------------

-- Task 1: Find the domestic and international sales for each movie
SELECT * FROM movies 
INNER JOIN boxoffice 
    ON movies.id = boxoffice.movie_id;

-- Task 2: Show sales numbers for movies that performed better internationally than domestically
SELECT * FROM movies 
INNER JOIN boxoffice 
    ON movies.id = boxoffice.movie_id 
WHERE international_sales >= domestic_sales;

-- Task 3: List all the movies by their ratings in descending order
SELECT * FROM movies 
INNER JOIN boxoffice 
    ON movies.id = boxoffice.movie_id 
ORDER BY rating DESC;


-- -------------------------------------------------------------------------
-- EXERCISE 7 & 8: Outer Joins & Handling Missing Fields (LEFT JOIN, NULLs)
-- Focus: Retaining unmatched rows to identify gaps, unassigned assets, or empty facilities.
-- -------------------------------------------------------------------------

-- Ex 7, Task 1: Find the list of all buildings that have employees
SELECT DISTINCT building 
FROM employees;

-- Ex 7, Task 2: Find the list of all buildings and their capacity
SELECT * FROM buildings;

-- Ex 7, Task 3: List all buildings and distinct employee roles (including empty buildings)
SELECT DISTINCT building_name, role 
FROM buildings 
LEFT JOIN employees 
    ON building_name = building;

-- Ex 8, Task 1: Find name and role of employees who have not been assigned a building
SELECT * FROM employees 
WHERE building IS NULL;

-- Ex 8, Task 2: Find the names of the buildings that hold no employees
SELECT DISTINCT building_name 
FROM buildings 
LEFT JOIN employees 
    ON building_name = building 
WHERE role IS NULL;


-- -------------------------------------------------------------------------
-- EXERCISE 9: Math & Expressions in SQL
-- Focus: On-the-fly transformations, calculated metrics, and arithmetic filtering.
-- -------------------------------------------------------------------------

-- Task 1: List all movies and their combined sales in millions of dollars
SELECT id, title, director, year, 
       (domestic_sales + international_sales) / 1000000 AS combined_sales_in_millions 
FROM movies 
LEFT JOIN boxoffice 
    ON id = movie_id;

-- Task 2: List all movies and their ratings in percent scale
SELECT id, title, director, year, 
       (rating * 10) AS percentage_of_ratings 
FROM movies 
LEFT JOIN boxoffice 
    ON id = movie_id;

-- Task 3: List all movies that were released on even number years (Modulo validation)
SELECT title, year 
FROM movies 
WHERE year % 2 = 0;


-- -------------------------------------------------------------------------
-- EXERCISE 10 & 11: Aggregations & Data Grouping (GROUP BY, MAX, AVG, SUM)
-- Focus: Segmenting organizational datasets to evaluate workforce metrics.
-- -------------------------------------------------------------------------

-- Ex 10, Task 1: Find the longest time that an employee has been at the studio
SELECT MAX(years_employed) AS max_tenure 
FROM employees;

-- Ex 10, Task 2: For each role, find the average number of years employed
SELECT role, AVG(years_employed) AS avg_years_employed 
FROM employees 
GROUP BY role;

-- Ex 10, Task 3: Find the total number of employee years worked in each building
SELECT building, SUM(years_employed) AS total_employee_years 
FROM employees 
GROUP BY building;

-- Ex 11, Task 1: Find the number of Artists in the studio (without a HAVING clause)
SELECT COUNT(*) AS total_artists 
FROM employees 
WHERE role = 'Artist';

-- Ex 11, Task 2: Find the number of Employees of each role in the studio
SELECT role, COUNT(*) AS employee_count 
FROM employees 
GROUP BY role;

-- Ex 11, Task 3: Find the total number of years employed by all Engineers
SELECT role, SUM(years_employed) AS total_engineer_years 
FROM employees 
WHERE role = 'Engineer';


-- -------------------------------------------------------------------------
-- EXERCISE 12: Business & Performance Grouping
-- Focus: Grouping content by creator to evaluate aggregate distribution and volume.
-- -------------------------------------------------------------------------

-- Task 1: Find the number of movies each director has directed
SELECT director, COUNT(title) AS total_movies_directed 
FROM movies 
GROUP BY director;

-- Task 2: Find the total domestic and international sales attributed to each director
SELECT director, 
       SUM(domestic_sales + international_sales) AS gross_sales_attributed 
FROM movies 
LEFT JOIN boxoffice 
    ON id = movie_id  
GROUP BY director;


-- -------------------------------------------------------------------------
-- EXERCISE 13, 14 & 15: Schema Mutations (INSERT, UPDATE, DELETE)
-- Focus: Managing table states, modifying historic records, and cleaning up entries.
-- -------------------------------------------------------------------------

-- Ex 13, Task 1 & 2: Insert new movie production and its corresponding financial stats
INSERT INTO movies (id, title, director, year, length_minutes)
VALUES (4, 'Toy Story 4', 'John Lasseter', 2010, 95);

INSERT INTO boxoffice (movie_id, rating, domestic_sales, international_sales)
VALUES (4, 8.7, 340000000, 270000000);

-- Ex 14, Tasks 1-3: Updating incorrect attributes or titles dynamically
UPDATE movies 
SET director = 'John Lasseter' 
WHERE title = "A Bug's Life";

UPDATE movies 
SET year = 1999 
WHERE title = 'Toy Story 2';

UPDATE movies 
SET title = 'Toy Story 3', 
    director = 'Lee Unkrich' 
WHERE title = 'Toy Story 8';

-- Ex 15, Tasks 1-2: Stripping obsolete rows from active relational views
DELETE FROM movies 
WHERE year < 2005;

DELETE FROM movies 
WHERE director = 'Andrew Stanton';


-- -------------------------------------------------------------------------
-- EXERCISE 16, 17 & 18: Table Schemas & Alterations (DDL)
-- Focus: Creating structured layouts, altering properties, and removing objects.
-- -------------------------------------------------------------------------

-- Ex 16: Create a new table named Database with unconstrained types
CREATE TABLE database (
    name TEXT, 
    version FLOAT, 
    download_count INTEGER
);

-- Ex 17: Alter existing schema to track aspect ratios and default language settings
ALTER TABLE movies 
ADD aspect_ratio FLOAT;

ALTER TABLE movies 
ADD language TEXT DEFAULT 'English';

-- Ex 18: Complete cleanup of structural elements
DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS boxoffice;


-- -------------------------------------------------------------------------
-- ANALYTICS SUBQUERIES (Exercise 19 Concept)
-- Case Study: Flagging cost-inefficient operational units against system means.
-- -------------------------------------------------------------------------

-- Step 1: Baseline aggregation tracking mean team performance
-- SELECT AVG(revenue_generated) FROM sales_associates;

-- Step 2: Dynamic nested isolation to target variables exceeding average baselines
SELECT * FROM sales_associates 
WHERE salary > (
    SELECT AVG(revenue_generated) 
    FROM sales_associates
);
