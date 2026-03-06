select* from portfolio_project..CovidDeaths order by 3,4;
select* from portfolio_project..CovidVaccinations order by 3,4;

-- Select Data that we are going to be using
Select Location, date, total_cases, new_cases, total_deaths, population
From portfolio_project..CovidDeaths order by 1,2;

-- Total Cases vs Total Deaths (what percentage of people infected actually died)
Select Location, date, total_cases,total_deaths, round((total_deaths/total_cases)*100,2)  as DeathPercentage
From portfolio_project..CovidDeaths
Where location like '%states%'
and continent is not null 
order by 1,2;

-- Total Cases vs Population (what percent of population got covid)
Select Location, date, Population, total_cases,  round((total_cases/population)*100,2) as PercentPopulationInfected
From portfolio_project..CovidDeaths
Where location like '%states%'
order by 1,2;

-- Countries with Highest Infection Rate compared to Population
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  round(Max((total_cases/population))*100,2) as PercentPopulationInfected
From portfolio_project..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc;

-- Countries with Highest Death Count per Population
Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From portfolio_project..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc;

-- Showing contintents with the highest death count per population
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From portfolio_project..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc;


-- GLOBAL NUMBERS
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, round(SUM(cast(new_deaths as int))/SUM(New_Cases)*100,2) as DeathPercentage
From portfolio_project..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2;

 --Total Population vs Vaccinations
 --Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From portfolio_project..CovidDeaths dea
Join portfolio_project..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3;


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From portfolio_project..CovidDeaths dea
Join portfolio_project..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, round((RollingPeopleVaccinated/Population)*100,2) as 'perc_ppl_vaccinated>1'
From PopvsVac;



-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
);

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From portfolio_project..CovidDeaths dea
Join portfolio_project..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date;
--where dea.continent is not null 
--order by 2,3

Select *, round((RollingPeopleVaccinated/Population)*100,2) as 'perc_ppl_vaccinated>1'
From #PercentPopulationVaccinated;



-- 1. View for Global KPI Cards
IF OBJECT_ID('Global_Stats', 'V') IS NOT NULL DROP VIEW Global_Stats;
GO
CREATE VIEW Global_Stats AS
Select 
    SUM(new_cases) as total_cases, 
    SUM(cast(new_deaths as int)) as total_deaths, 
    ROUND(SUM(cast(new_deaths as int))/SUM(NULLIF(New_Cases,0))*100,2) as DeathPercentage
From portfolio_project..CovidDeaths
Where continent is not null;
GO

-- 2. View for Continent Analysis
IF OBJECT_ID('Continent_Deaths', 'V') IS NOT NULL DROP VIEW Continent_Deaths;
GO
CREATE VIEW Continent_Deaths AS
Select 
    continent, 
    MAX(cast(Total_deaths as int)) as TotalDeathCount
From portfolio_project..CovidDeaths
Where continent is not null 
Group by continent;
GO

-- 3. View for Map Visuals (Country Level)
IF OBJECT_ID('Country_Infections', 'V') IS NOT NULL DROP VIEW Country_Infections;
GO
CREATE VIEW Country_Infections AS
Select 
    Location, 
    Population, 
    MAX(total_cases) as HighestInfectionCount,  
    ROUND(MAX((total_cases/population))*100,2) as PercentPopulationInfected
From portfolio_project..CovidDeaths
Where continent is not null
Group by Location, Population;
GO

-- 4. View for Vaccination Timeline
IF OBJECT_ID('Vaccination_Timeline', 'V') IS NOT NULL DROP VIEW Vaccination_Timeline;
GO
CREATE VIEW Vaccination_Timeline AS
Select 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations,
    SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From portfolio_project..CovidDeaths dea
Join portfolio_project..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null;
GO