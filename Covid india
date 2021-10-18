--Exploring Data
SELECT *
FROM [Covid india]..covid_cases


--Total Cases vs Population
SELECT c.Region,c.Cases,p.[Population in 2011],p.[Estimated Population in 2021]
FROM (SELECT Region, MAX(CAST([Confirmed Cases] as INT)) as Cases
	FROM [Covid india]..covid_cases
	GROUP BY Region) as c
JOIN [Covid india]..population as p
	ON c.Region = p.[State Name]

--Total Cases vs Vaccinations vs Deaths
DROP VIEW total
CREATE View total as 
(SELECT c.[State/UT],p.[Estimated Population in 2021],c.Cases,c.[Active Cases],c.Deaths
FROM (SELECT Region as [State/UT], MAX(CAST([Confirmed Cases] as INT)) as Cases,
			MAX(CAST(Death as INT)) as Deaths,
			MAX(CAST([Active Cases] as INT)) as [Active Cases]
	FROM [Covid india]..covid_cases
	GROUP BY Region) as c
RIGHT JOIN [Covid india]..population as p
	ON c.[State/UT] = p.[State Name])

SELECT t.*,v.[Fully Vaccinated]
FROM (SELECT title as [State/UT], MAX(CAST(CAST( totally_vaccinated as FLOAT) as INT)) as [Fully Vaccinated]
FROM [Covid india]..StateWiseVaccinationCoverage$
GROUP BY title) as v
JOIN total as t
	ON t.[State/UT]= v.[State/UT]


--MONTHLY CASES TREND
SELECT CONCAT(MONTH,'-',YEAR) as DATE,
	*,
	Cases - LAG(Cases,1,0) OVER (ORDER BY YEAR, MONTH)AS [New Cases],
	Death - LAG(Death,1,0) OVER (ORDER BY YEAR, MONTH)AS [New Deaths]
	
FROM(SELECT MONTH, YEAR,
		MAX(CAST([Confirmed Cases] as INT)) as Cases,
		MAX(CAST([Active Cases] AS INT))as [Active Cases],
		MAX(CAST([Cured Discharged] as INT))as [Cured/Discharged],
		MAX(CAST(Death as INT)) as Death
	FROM (SELECT SUBSTRING(Date,4,2) as MONTH,
				SUBSTRING(Date,7,4) as YEAR,
				[Confirmed Cases],[Active Cases],[Cured Discharged],Death
		FROM [Covid india]..covid_cases
		Where Region!='World') as v1
	GROUP BY MONTH, YEAR) as v2




--MONTHLY CASES TREND STATEWISE
SELECT CONCAT(MONTH,'-',YEAR) as DATE,
	*,
	Cases - LAG(Cases,1,0) OVER (PARTITION BY [State/UT] ORDER BY YEAR, MONTH)AS [New Cases],
	Death - LAG(Death,1,0) OVER (PARTITION BY [State/UT] ORDER BY YEAR, MONTH)AS [New Deaths]
	
FROM(SELECT MONTH, YEAR,Region as [State/UT],
		MAX(CAST([Confirmed Cases] as INT)) as Cases,
		MAX(CAST([Active Cases] AS INT))as [Active Cases],
		MAX(CAST([Cured Discharged] as INT))as [Cured/Discharged],
		MAX(CAST(Death as INT)) as Death
	FROM (SELECT SUBSTRING(Date,4,2) as MONTH,
				SUBSTRING(Date,7,4) as YEAR,
				Region,
				[Confirmed Cases],[Active Cases],[Cured Discharged],Death
		FROM [Covid india]..covid_cases
		Where Region !='World' AND
			Region !='India') as v1
	GROUP BY Region,MONTH, YEAR) as v2

--Active cases trends
SELECT *,
	  ([Active Cases]-LAG([Active Cases],1,0) OVER(ORDER BY YEAR, MONTH)) as [Increase/Decrease]
FROM(SELECT CONCAT(MONTH,'-',YEAR) as Date,MONTH,YEAR,
			MAX([Active Cases]) as [Active Cases]
		FROM(SELECT SUBSTRING(Date,4,2) as MONTH,
					SUBSTRING(Date,7,4) as YEAR,
					CAST([Active Cases]as INT) as [Active Cases]
			FROM [Covid india]..covid_cases
			WHERE Region != 'World')V1
		GROUP BY MONTH, YEAR) V2
