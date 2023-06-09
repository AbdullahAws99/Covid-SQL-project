Select *
From PortfilioProject..CovidDeathes$
where continent is not null
Order by 3,4

--Select *
--From PortfilioProject..CovidVaccinations$
--Order by 3,4

-- Select the data we use in the project

Select Location , date , total_cases , new_cases , total_deaths,population_density
From PortfilioProject..CovidDeathes$
order by 1,2


-- Looking at total cases vs total deaths
-- show likelihod of dying if you contract covid in your country

Select Location , date , total_cases , total_deaths , (total_deaths/total_cases)*100 as deathpers
From PortfilioProject..CovidDeathes$
Where location like '%yem%'
order by 1,2

--Loking at total cases vs population

-- shows what percentage of population got covid

Select Location , date , total_cases , population, (total_cases/population)*100 as deathpers
From PortfilioProject..CovidDeathes$
--Where location like '%states%'
order by 1,2

-- loking at countries ith hightest infection rate compared population


Select Location , population , MAX(total_cases) as HighestInfectionCount,Max((total_cases/population))*100 as PercentPopulationInfacted
From PortfilioProject..CovidDeathes$
--Where location like '%states%'
Group by location , population
order by PercentPopulationInfacted DESC

-- Showing countries with Highest derat count or population



Select Location , MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfilioProject..CovidDeathes$
--Where location like '%states%'
where continent is not null
Group by location
order by TotalDeathCount DESC


-- Let's Break down by continent


Select continent , MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfilioProject..CovidDeathes$
--Where location like '%states%'
where continent is NOT null
Group by continent
order by TotalDeathCount DESC


-- showing the contintents with higest death count per population

-- Creating View

Create View MaximumContinentDeaths as

Select continent , MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfilioProject..CovidDeathes$
--Where location like '%states%'
where continent is NOT null
Group by continent
--order by TotalDeathCount DESC

select *
From MaximumContinentDeaths
-- global numbers 

Select date, SUM(new_cases) as sumtion_new, SUM(cast(new_deaths as int)) as sumtion_death
, Sum(cast(New_deaths as int))/ sum(new_cases)
From PortfilioProject..CovidDeathes$
--Where location like '%yem%'
where continent is not null
Group by date
order by 1,2


Select new_deaths
from PortfilioProject..CovidDeathes$


Select *
From dbo.CovidDeathes$

EXEC sp_help 'dbo.CovidDeathes$';

ALTER TABLE dbo.CovidDeathes$
ALTER COLUMN new_deaths Float


--Loking at Total Population vs Vaccinations

select dea.continent , dea.location ,  dea.date , dea.population , vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations )) over (partition by dea.location)
From PortfilioProject..CovidDeathes$ dea
Join PortfilioProject..CovidVaccinations$ vac
	 on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- use cte

with popvsVac (Continent, Location , Date , population, New_Vaccinations , RollingpeopleVaccinated)
as
(
select dea.continent , dea.location ,  dea.date , dea.population , vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations )) over (partition by dea.location order by dea.location , dea.Date) As RollingpeopleVaccinated
From PortfilioProject..CovidDeathes$ dea
Join PortfilioProject..CovidVaccinations$ vac
	 on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *
from popvsVac