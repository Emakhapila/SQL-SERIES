-- 1. DATA VALIDATION QUERIES
-- It ensures that the data is clean consistent and ready for analysis. 
SELECT 'employee' AS table_name, COUNT(*) AS records FROM employee
UNION ALL
SELECT 'location', COUNT(*) FROM location
UNION ALL
SELECT 'visits', COUNT(*) FROM visits
UNION ALL
SELECT 'water_source', COUNT(*) FROM water_source
UNION ALL
SELECT 'water_quality', COUNT(*) FROM water_quality
UNION ALL
SELECT 'well_pollution', COUNT(*) FROM well_pollution
UNION ALL
SELECT 'global_water_access', COUNT(*) FROM global_water_access
UNION ALL
SELECT 'data_dictionary', COUNT(*) FROM data_dictionary;

-- 2. Check for Missing Values

-- Employee table
SELECT 
	SUM(employee_name IS NULL) AS missing_name,
    SUM(town_name IS NULL) AS missing_role,
    SUM(province_name IS NULL) AS missing_province
FROM employee;

-- Location table
SELECT 
	SUM(location_id IS NULL) AS missing_location,
    SUM(province_name IS NULL) AS missing_province,
    SUM(town_name IS NULL) AS missing_town
FROM location;

-- Water Source table
SELECT 
	SUM(source_id IS NULL) AS missing_source_id,
    SUM(number_of_people_served IS NULL) AS missing_people_served
FROM water_source;

-- Visits
SELECT
    SUM(assigned_employee_id IS NULL) AS missing_employee_id,
    SUM(location_id IS NULL) AS missing_location_id,
    SUM(visit_count IS NULL) AS missing_visit_time
FROM visits;

--  3. Checking for Duplicate Keys
-- Location Keys

SELECT province_name,  town_name, COUNT(*) AS count
FROM location
GROUP BY province_name, town_name
HAVING count > 1;

-- Water source
SELECT type_of_water_source, number_of_people_served, COUNT(*) AS count
FROM water_source
GROUP BY type_of_water_source, number_of_people_served
HAVING count > 1;



-- looking at the location table
SELECT *
FROM location
LIMIT 10;

-- Looking at the visits table
SELECT *
FROM visits
LIMIT 10;



-- Looking at the Employee table
SELECT *
FROM employee
LIMIT 10;

-- Looking at the water source table
SELECT * 
FROM water_source
LIMIT 10;


-- 4. Starting our Analysis
-- DELIVERABLEs FOR THIS SECTION
/* Which water source type is most common?

Which type serves the most people?

Which provinces and towns have the highest number of sources?

Which towns are under pressure due to high populations relying on limited sources? */

-- 4.1 How many water sources exist in total?
SELECT COUNT(*) AS total_water_sources
FROM water_source;

-- There is a total of 39650 water sources

-- 4.2 Distribution of water sources by type
SELECT type_of_water_source,
	COUNT(*) AS total_sources
FROM water_source
GROUP BY type_of_water_source
ORDER BY total_sources;

-- The most common water source type is well with 17,383 sources and the least common is river with 3,379 sources

-- 4.3 Which source types serve the highest number of people?
SELECT type_of_water_source, 
	SUM(number_of_people_served) AS total_people_served
FROM water_source
GROUP BY type_of_water_source
ORDER BY total_people_served;

-- Shared_tap serves the highest number of people followed by well, tap_in_home, tap_in_home broken and river.

-- 4.4 Water source distribution by province
SELECT 
    l.province_name,
    COUNT(ws.source_id) AS sources_in_province
FROM water_source ws
JOIN visits v 
    ON ws.source_id = v.source_id
JOIN location l
    ON v.location_id = l.location_id
GROUP BY l.province_name
ORDER BY sources_in_province DESC;

/* Kilimani province leads with the most sources(15271) followed by Akatsi(13791), Sokoto(11895), 
Amanzi(10345) & Hawassa(8844) Respectively.*/


-- 4.5 Water source distribution by town
SELECT 
    l.town_name,
    COUNT(ws.source_id) AS sources_in_town
FROM water_source ws
JOIN visits v 
    ON ws.source_id = v.source_id
JOIN location l
    ON v.location_id = l.location_id
GROUP BY l.town_name
ORDER BY sources_in_town DESC;

-- Rural accounts for the most sources in town while Yaounde accounts for the least sources in town. 

-- 4.6 — Which towns have the largest populations relying on water sources?

SELECT 
    l.town_name,
    SUM(number_of_people_served) AS total_people_served
FROM water_source ws
JOIN visits v 
    ON ws.source_id = v.source_id
JOIN location l
    ON v.location_id = l.location_id
GROUP BY l.town_name
ORDER BY total_people_served DESC;

-- Rural has the highest number of people relying on water sources(48,741,718) with Yaounde having the least 
-- number of people relying on water sources(163,464)
	
-- 4.7 — Combining type + town for deeper insight
-- This helps determine whether some towns rely too heavily on certain source types.
SELECT 
    town_name,
    type_of_water_source,
    COUNT(*) AS total_sources,
    SUM(number_of_people_served) AS people_served
FROM water_source ws
JOIN visits v 
    ON ws.source_id = v.source_id
JOIN location l
    ON v.location_id = l.location_id
GROUP BY town_name, type_of_water_source
ORDER BY people_served DESC;

-- Rural relies heavily on shared_tap serving 40,056,926 people

-- 4.8 Query to Retrieve Unique Water Source Types
SELECT DISTINCT type_of_water_source
FROM water_source
ORDER BY type_of_water_source;

-- There are 5 types of unique water sources namely, river,shared_tap, tap_in_home, tap_in_home_broken & well

-- STEP 5. UNPACKING THE VISITS TO WATER SOURCES
/* How many visits were made
✔ Which employees visited the most locations
✔ Which towns were visited most/least
✔ Whether all areas received equal survey coverage
✔ How many sources were left unvisited
✔ Visit patterns (time of day, frequency, distribution)
✔ Retrieve Water Points Where People Queued More Than 500 Minutes

This is a VERY important part of the Maji Ndogo project, because it allows MD Water Services 
to evaluate survey efficiency and identify underserved areas.*/

-- 5.1 How many visits were made
SELECT COUNT(*) AS total_visits
FROM visits;

-- There was a total of 60,146 visits made

-- 5.2 Which employees visited the most locations
SELECT 
	employee_name,
    COUNT(visit_count) AS total_visits
FROM visits
JOIN employee
ON visits.assigned_employee_id = employee.assigned_employee_id
GROUP BY employee_name
ORDER BY total_visits DESC;

-- Top 5 employees who visited the most locations are Bell Azibo(3708), Pili Zola(3676), Rudo Imani(3539),
-- Malachi(3420), Farai Nai(3407), 
-- 5 Employees who made the least visits are Isoke Amani(802), Nia Furaha(719), Wambui Jabali(218)
-- Lesedi Kofi(143), Kunto Asha(15)

-- 5.3 Number of Visits Per Town
SELECT 
	town_name,
    COUNT(visit_count) AS total_visits
FROM visits
JOIN location
ON visits.location_id = location.location_id
GROUP BY town_name
ORDER BY total_visits DESC;

-- Rural has the most number of visits(38,741) followed by Zuri(2178), Harare(1860), Asmara(1609) & Dhahabu(1434)
-- completing the top 5
-- 5 least visited towns include Cheche(454), Deka(399), Djenne(359), zanzibar(349) & Yaounde (291)

-- 5.4 Number of Visits Per Province
-- Identifies which provinces were prioritized.

SELECT
	province_name,
    COUNT(visit_count) AS total_visits
FROM visits
JOIN location
ON visits.location_id = location.location_id
GROUP BY province_name
ORDER BY total_visits DESC;

-- Kilimani leads with 15,271 visits followed by Akatsi(13,791), Sokoto(11,895), Amanzi(10,345), & Hawassa(8,844)

-- 5.5 Visit patterns (time of day, frequency, distribution)
SELECT
	CASE
		WHEN HOUR(time_of_record) BETWEEN 5 AND 11 THEN "Morning"
        WHEN HOUR(time_of_record) BETWEEN 12 AND 17 THEN "Afternoon"
        ELSE "Evening/Night"
	END AS time_of_record,
    COUNT(*) AS visit_count
FROM visits
GROUP BY time_of_record
ORDER BY visit_count;

-- 5.6 Water Sources That Were NEVER Visited
-- shows unassessed water sources.
SELECT 
	WS.source_id,
    WS.type_of_water_source,
    WS.number_of_people_served
FROM water_source AS ws
	LEFT JOIN visits AS v
ON ws.source_id = v.source_id
WHERE v.source_id IS NULL;

-- It looks like all water sources were visited


-- 5.7 Identifying Towns with Unvisited Sources

SELECT 
    l.town_name,
    COUNT(ws.source_id) AS unvisited_sources
FROM water_source ws
JOIN visits v 
    ON ws.source_id = v.source_id
RIGHT JOIN location l 
    ON l.location_id = v.location_id
GROUP BY l.town_name
HAVING unvisited_sources > 0
ORDER BY unvisited_sources DESC;

-- Rural leads with(38,741) most unvisited sources Yaounde closes the list with the least visited(291)

-- 5.9 Most Frequently Visited Water Sources
-- Shows which sources required repeated inspections
SELECT 
    ws.source_id,
    ws.type_of_water_source,
    COUNT(v.visit_count) AS visits_count
FROM visits v
JOIN water_source ws 
    ON v.source_id = ws.source_id
GROUP BY ws.source_id, ws.type_of_water_source
ORDER BY visits_count DESC;

-- Shared_tap was the most frequently visited water source.

-- 5.9A Which Employees Cover Which Provinces
-- Helps identify which field officers cover which regions
SELECT 
    e.employee_name,
    l.province_name,
    COUNT(v.visit_count) AS visits
FROM visits v
JOIN employee e 
    ON e.assigned_employee_id = v.assigned_employee_id
JOIN location l 
    ON l.location_id = v.location_id
GROUP BY e.employee_name, l.province_name
ORDER BY visits DESC;

-- 5.9B Retrieve Water Points Where People Queued More Than 500 Minutes
SELECT *
FROM visits
WHERE time_in_queue > 500;


-- 5.9C 
SELECT 
    v.record_id,
    v.source_id,
    v.visit_count,
    wq.subjective_quality_score,
    ws.type_of_water_source
FROM visits v
JOIN water_quality wq 
    ON v.record_id = wq.record_id
JOIN water_source ws
    ON v.source_id = ws.source_id
WHERE wq.subjective_quality_score = 10
  AND v.visit_count > 1;


-- STEP 6
-- Pollution Issues.
SHOW tables;

-- 6.1 Print the First Few Rows of the Pollution Table 
SELECT *
FROM well_pollution
LIMIT 10;

/* It looks like our scientists diligently recorded the water quality of all the wells. 
Some are contaminated with biological contaminants,
while others are polluted with an excess of heavy metals and other pollutants. 
Based on the results, each well was classified as Clean,
Contaminated: Biological or Contaminated: Chemical. 
It is important to know this because wells that are polluted with bio- or other contaminants are not safe to drink. 
It looks like they recorded the source_id of each test, so we can link it to a source, at some
place in Maji Ndogo.*/

-- 6.2 Query to Detect Misclassified Wells
SELECT
	source_id,
    description,
    pollutant_ppm,
    biological,
    results
FROM well_pollution
WHERE results = "Clean"
	AND biological > 0.01;

/* If we compare the results of this query to the entire table it seems like we have some 
inconsistencies in how the well statuses are recorded. 
Specifically, it seems that some data input personnel might have mistaken the description field 
for determining the clean-liness of the water.
It seems like, in some cases, if the description field begins with the word “Clean”, 
the results have been classified as “Clean” in the results column, even though the biological column is > 0.01.*/

/* 0 rows → GOOD NEWS

It means:

No biologically contaminated wells were mislabeled as “Clean”.

Classification integrity is strong.

Scientists were consistent and accurate.*/

-- 6.3A Find Incorrect Descriptions
/* We need to find descriptions that:

Contain “Clean” But have additional characters after the word “Clean” 
(meaning: “Clean-ish”, “Clean but…”, “Clean water with…” etc.)
AND biological > 0.01 (so they should NOT have “Clean” anywhere)

We use LIKE 'Clean%' but also add a wildcard after "Clean" to ensure there is extra text*/

SELECT
	source_id,
    description,
    pollutant_ppm,
    biological,
    results
FROM well_pollution
WHERE description LIKE "Clean_%"
	AND biological > 0.01;
    
-- 6.3B Check Misclassified Results
SELECT 
	source_id,
    pollutant_ppm,
    biological,
    results
FROM well_pollution
WHERE results = "Clean"
	AND biological > 0.01;
    
-- This confirms the dangerous classification errors.

-- 6.3C Connect Both Problems
-- We can check how many misclassified rows have misleading descriptions
SELECT 
    source_id,
    description,
    biological,
    pollutant_ppm
FROM well_pollution
WHERE biological > 0.01
  AND results LIKE 'Clean_%';
  
  
  
 -- 7. Final SQL Fixes for the Pollution Data
 SELECT source_id, description
FROM well_pollution
WHERE description = 'Clean Bacteria: E. coli';

UPDATE well_pollution
SET description = 'Bacteria: E. coli'
WHERE source_id IN (
    SELECT source_id
    FROM (
        SELECT source_id
        FROM well_pollution
        WHERE description = 'Clean Bacteria: E. coli'
    ) AS t
);

-- 7.1 Making sure there are no errors
-- A safer way to do the UPDATE is by testing the changes on a copy of the table first.

CREATE TABLE
md_water_services.well_pollution_copy
AS (
SELECT
*
FROM
md_water_services.well_pollution
);


/*We will get a copy of well_pollution called well_pollution_copy. Now we can make the changes, 
and if we discover there is a mistake in our code, we can just delete this table, and run it again.*/


-- Put a test query here to make sure we fixed the errors

-- 7.2 Test for incorrect descriptions starting with “Clean” despite contamination
SELECT 
    source_id,
    description,
    biological,
    results
FROM well_pollution_copy
WHERE description LIKE 'Clean_%'
  AND biological > 0.01;
-- Use the query we used to show all of the erroneous rows

-- 7.3 Test for misclassified wells (still marked as Clean even though biological > 0.01)
SELECT 
    source_id,
    description,
    biological,
    results
FROM well_pollution_copy
WHERE biological > 0.01
  AND results = 'Clean';
  
  SELECT source_id
FROM well_pollution_copy
WHERE description LIKE 'Clean Bacteria:%';

-- 7.4 fixing descriptions
UPDATE well_pollution_copy
SET description = REPLACE(description, 'Clean Bacteria:', 'Bacteria:')
WHERE source_id IN (
    SELECT source_id
    FROM (
        SELECT source_id
        FROM well_pollution_copy
        WHERE description LIKE 'Clean Bacteria:%'
    ) AS t
);

-- 7.5 Fixing results
UPDATE well_pollution_copy
SET results = 'Contaminated: Biological'
WHERE source_id IN (
    SELECT source_id
    FROM (
        SELECT source_id
        FROM well_pollution_copy
        WHERE biological > 0.01
          AND results = 'Clean'
    ) AS t
);


