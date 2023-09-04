-- How many public high schools are in each zip code?

SELECT zip_code AS 'Zip Code', COUNT(school_id) AS '# of schools'
FROM public_hs_data
GROUP BY zip_code
ORDER BY 2 DESC;

--How many public high schools in each state?

SELECT state_code AS 'State', COUNT(school_id) AS '# of schools'
FROM public_hs_data
GROUP BY state_code
ORDER BY 2 DESC;

--The locale_code column in the high school data corresponds to various levels of urbanization as listed below. Use the CASE statement to display the corresponding locale_text and locale_size in your query result.
SELECT 
	zip_code AS 'Zip Code',
	locale_code AS 'Locale Code',
	CASE 
		WHEN locale_code <= 13 THEN 'City'
		WHEN locale_code <= 23 THEN 'Suburb'
		WHEN locale_Code <= 33 THEN 'Town'
		WHEN locale_code <= 43 THEN 'Rural'
		ELSE null
	END AS 'Urbanisation',
	CASE
		WHEN locale_code <= 23 THEN
			CASE substr(locale_code, 2, 1)
			WHEN '1' THEN 'Large'
			WHEN '2' THEN 'Midsize'
			WHEN '3' THEN 'Small'
			ELSE null
			END
		WHEN locale_code >= 31 THEN
			CASE substr(locale_code, 2, 1)
			WHEN '1' THEN 'Fringe'
			WHEN '2' THEN 'Distant'
			WHEN '3' THEN 'Remote'
			ELSE NULL
			END
		END AS 'Size'
FROM public_hs_data
ORDER BY locale_code ASC;

--What is the minimum, maximum, and average median_household_income of the nation? for each state?
SELECT 
	MIN(median_household_income) As 'Min. Median Income', 
	MAX(median_household_income) AS 'Max Median Income', 
	ROUND(AVG(median_household_income),2) AS 'Avg Median Income'
FROM census_data
WHERE median_household_income != 'NULL';

--What is the minimum, maximum, and average median_household_income for each sate?
SELECT
	state_code AS 'State',
	MIN(median_household_income) As 'Min. Median Income', 
	MAX(median_household_income) AS 'Max Median Income', 
	ROUND(AVG(median_household_income),2) AS 'Avg Median Income'
FROM census_data
WHERE median_household_income != 'NULL'
GROUP BY state_code
ORDER BY state_code ASC;

-- Do characteristics of the zip-code area, such as median household income, influence students’ performance in high school?
SELECT
	CASE
		WHEN census_data.median_household_income < 50000 THEN '<$50k'
		WHEN census_data.median_household_income BETWEEN 50000 AND 100000 THEN '$50k - $100k'
		WHEN census_data.median_household_income > 100000 THEN '$100k+'
	END AS 'Income Bracket',
	ROUND(AVG(public_hs_data.pct_proficient_math),2) AS 'Avg. Math Proficiency',
	ROUND(AVG(public_hs_data.pct_proficient_reading),2) AS 'Avg. Reading proficiency'
FROM public_hs_data
JOIN census_data
ON public_hs_data.zip_code = census_data.zip_code
GROUP BY 1;

--On average, do students perform better on the math or reading exam? Find the number of states where students do better on the math exam, and vice versa.

WITH state_subject AS (
SELECT
	state_code,
	CASE
		WHEN AVG(pct_proficient_math) = AVG(pct_proficient_reading) THEN 'Equal'
		WHEN AVG(pct_proficient_math) > AVG(pct_proficient_reading) THEN 'Math'
		WHEN AVG(pct_proficient_math) < AVG(pct_proficient_reading) THEN 'Reading'
		ELSE 'No data'
	END AS 'best_subject'
FROM public_hs_data
GROUP BY 1)

SELECT best_subject, COUNT(state_code)
FROM state_subject
GROUP BY best_subject;

--try to do without WITH 
