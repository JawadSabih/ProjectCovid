SELECT * FROM -- The full CovidDeaths dataset
PortfolioProjectCovid..CovidDeaths

SELECT * FROM -- The full CovidVaccinations dataset
PortfolioProjectCovid..CovidVaccinations



-- Full analysis
SELECT -- The columns in which will be shown

	
    t.location,
	t.population,
	t.Total_Cases,
    t.percentage_total_cases,
	t.Total_Deaths,
	t.Percentage_total_deaths,
	t.Case_Fatality,
	v.total_vaccinated_percentage
	
FROM
    (
		
        SELECT

			
			population,
            location,
			
            MAX(total_cases) AS Total_Cases,
			MAX(total_deaths) AS Total_Deaths,
			CAST(ROUND(MAX(CAST(total_cases AS decimal) / population * 100), 4) AS DECIMAL(10,4)) AS percentage_total_cases, --The column for the percentage of total cases
			CAST(ROUND(MAX(CAST(total_deaths AS decimal) / population * 100), 4) AS DECIMAL(10,4)) AS Percentage_total_deaths,  --The column for the percentage of total deaths
			CAST(ROUND(MAX(CAST(total_deaths AS decimal)) / MAX(CAST(total_cases AS decimal)), 4) AS DECIMAL(10,4)) AS Case_Fatality -- The column for the chance of dying if infected 
        FROM
            PortfolioProjectCovid..CovidDeaths
        WHERE
            continent IS not NULL --Filters out some of the rows that have a continent value instead of a country value
			--AND location IN ('Afghanistan', 'Lebanon', 'Somalia') --This formula allows you to choose which countries you want to see
			
        GROUP BY
            location, population --Needed for aggregation
    ) AS t


JOIN -- Getting data from another table
    (
		
		
        SELECT
            location,
			population,
			
			
			
            CAST(ROUND(MAX(CAST(people_vaccinated AS decimal) / population * 100), 4) AS DECIMAL(10,4)) AS total_vaccinated_percentage
        FROM
            PortfolioProjectCovid..CovidVaccinations
        GROUP BY
            location, population

    ) AS v ON t.location = v.location

ORDER BY
	total_vaccinated_percentage
	DESC


