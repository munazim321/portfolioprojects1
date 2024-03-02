select location,date,population,total_cases,  (total_cases/population)*100 as centageinfected
from sqltrainingcorona..CovidDeaths
where location like '%states%' and continent is not null 
order by 1,2


select continent,max(cast(total_deaths as int)) as totaldeathcount
from sqltrainingcorona..CovidDeaths
--where location like '%states%'
where continent is not null
group by continent
order by totaldeathcount desc



select location,max(cast(total_deaths as int)) as totaldeathcount
from sqltrainingcorona..CovidDeaths
--where location like '%states%'
where continent is not null
group by location
order by totaldeathcount desc

--global numbers
select date,sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as deaths --,total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from sqltrainingcorona..CovidDeaths
--where location like '%states%' 
where continent is not null 
group by date
order by 1,2

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as deaths --,total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from sqltrainingcorona..CovidDeaths
--where location like '%states%' 
where continent is not null 
--group by date
order by 1,2


--looking at total population vs vaccinations
with popvsVac (continent,location,date,population,new_vaccinations,RollingpeopleVaccinated)
as 
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location,
dea.date) as RollingpeopleVaccinated
--,(RollingpeopleVaccinated/population)*100 as 
from sqltrainingcorona..CovidDeaths dea
join sqltrainingcorona..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select *,(RollingpeopleVaccinated/population)*100 as vaccinepercenatage
from popvsVac

drop table if exists #percentpopulationVaccinated
create table #percentpopulationVaccinated
(
continent nvarchar(255)
, location nvarchar(255)
,date datetime
,population numeric
,new_vaccinations numeric
,Rollingpeoplevaccinated numeric)
insert into #percentpopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location,
dea.date) as RollingpeopleVaccinated
--,(RollingpeopleVaccinated/population)*100 as 
from sqltrainingcorona..CovidDeaths dea
join sqltrainingcorona..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
--where dea.continent is not null
--order by 2,3

select *,(RollingpeopleVaccinated/population)*100 as vaccinepercenatage
from #percentpopulationVaccinated


--create data for visualizations
create view percentpopulationVaccinated as 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location,
dea.date) as RollingpeopleVaccinated
--,(RollingpeopleVaccinated/population)*100 as 
from sqltrainingcorona..CovidDeaths dea
join sqltrainingcorona..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
select *
from percentpopulationVaccinated









