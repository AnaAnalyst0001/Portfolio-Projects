SELECT * FROM deaths;
SELECT * FROM vaccinations;
-- total deaths vs total_cases, percentage of deaths of cases by location: it shows the likelihood of dying if someone gets infected, based on his/her location
SELECT location, date, total_cases, new_cases, total_deaths, population, ((total_deaths/total_cases)*100) AS death_percentage FROM deaths WHERE location="India";
-- total_cases vs population: shows the percentage of people infected of the total population of that particular location: (note: based of that, we can also do the ranking of countries)
SELECT location, date, total_cases, total_deaths, population, ((total_cases/population)*100) AS infected_percentage FROM deaths WHERE location="United States";
-- total_deaths vs population: shows the percentage of people died of the total population of that particular location: (note: based of that, we can also do the ranking of countries)
SELECT location, date, total_cases, total_deaths, population, ((total_deaths/population)*100) AS deathpop_percentage FROM deaths WHERE location="Brazil";
-- countries (amongst the enlisted) with highest infection rate vs. its population
SELECT location, date, population, total_cases, ((total_cases/population)*100) AS infected_percentage FROM deaths ORDER BY infected_percentage DESC;
-- or, follow this code below, for better clarity:
SELECT location, population, max(total_cases) as highest_infection_rate, max((total_cases/population))*100 as percentpopinfected from deaths group by location, population order by percentpopinfected desc; 

-- countries with highest death count per population: shows the countries with highest death count i.e., highest no. of people died of covid
SELECT location, population, max(total_deaths) as death_count, max((total_deaths/population))*100 as percentpopdeath from deaths group by location, population order by death_count desc; 

-- break down death count by continent
SELECT continent, max(total_deaths) as death_count, max((total_deaths/population))*100 as percentpopdeath from deaths  group by continent order by death_count desc; 

-- join death & vaccination tables, use CTE: 
with popvsvac (continent, location, date, population, new_vaccinations, rolling_vaccination_count)
as
(select dth.continent, dth.location, dth.date, dth.population, vacc.new_vaccinations, sum(vacc.new_vaccinations) 
OVER (partition by dth.location order by dth.location, dth.date) as rolling_vaccination_count
from deaths as dth join vaccinations as vacc on dth.location=vacc.location and dth.date=vacc.date)
select location, population, new_vaccinations, rolling_vaccination_count, (rolling_vaccination_count/population)*100 as rolling_vacc_percent 
from popvsvac;





