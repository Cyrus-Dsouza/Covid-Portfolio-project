--SELECT *
--from PortfolioProject..Covid_deaths$
--order by 3,4

--selecting data
SELECT location, date, total_cases,new_cases,total_deaths,population
FROM PortfolioProject..Covid_deaths$
WHERE continent is not null
ORDER BY 1,2

---Total cases VS Total Deaths
--- death after contracting covid
SELECT location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as death_percentage
FROM PortfolioProject..Covid_deaths$
WHERE location = 'India' 
ORDER BY 1,2


--total cases vs population
SELECT location, date, total_cases,population, (total_cases/population)*100 as cases_percentage
FROM PortfolioProject..Covid_deaths$
WHERE location = 'India' 
ORDER BY 1,2

---countries with highest infection rate w.r.t population
SELECT location, MAX(total_cases) as highest_infection,
	population, MAX(total_cases/population)*100 as infection_percentage
FROM PortfolioProject..Covid_deaths$
WHERE continent is not null
GROUP BY location, population
ORDER BY 4 desc

--- countries with highest death count

SELECT location, MAX(cast(total_deaths as int)) as highest_deaths
FROM PortfolioProject..Covid_deaths$
WHERE continent is not null
GROUP BY location
ORDER BY 2 desc

---BY CONTINENT
SELECT location, MAX(cast(total_deaths as int)) as highest_deaths
FROM PortfolioProject..Covid_deaths$
WHERE continent is null
GROUP BY location
ORDER BY 2 desc

--Global 
SELECT SUM(new_cases) as cases,SUM(cast(new_deaths as int)) as deaths,
	(SUM(cast(new_deaths as int)))/SUM(new_cases)*100 as death_percentage
FROM PortfolioProject..Covid_deaths$
WHERE continent is  not null
--group by date
ORDER BY 1,2

--- vaccination vs population
-- use CTE
With PopulationVSvacc (continent,location,date,population,new_vaccinations,people_vaccinated)
as(SELECT dea.continent, dea.location, dea.date, dea.population,
	vacc.new_vaccinations, SUM(cast(vacc.new_vaccinations as int)) 
		OVER (partition by dea.location Order by dea.location,dea.date) as people_vaccinated
FROM PortfolioProject..Covid_deaths$ dea
JOIN PortfolioProject..Covid_vacc$ vacc
	ON dea.location = vacc.location
	and dea.date = vacc.date
where dea.continent is not null)
 SELECT *, (people_vaccinated/population)*100
 FROM PopulationVSvacc

  ---creating view for later visualizations
  Create View percent_people_vaccinated as
  (SELECT dea.continent, dea.location, dea.date, dea.population,
	vacc.new_vaccinations, SUM(cast(vacc.new_vaccinations as int)) 
		OVER (partition by dea.location Order by dea.location,dea.date) as people_vaccinated
FROM PortfolioProject..Covid_deaths$ dea
JOIN PortfolioProject..Covid_vacc$ vacc
	ON dea.location = vacc.location
	and dea.date = vacc.date
where dea.continent is not null)







