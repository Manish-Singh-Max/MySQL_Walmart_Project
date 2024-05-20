create schema cars;

select * from car_dekho;
-- Read Data
select * from car_dekho;

-- Total Cars - To get a count of total records
select count(*) from car_dekho;

-- The manager asked the employee, how many cars are available of 2023 model.
select count(*) from car_dekho
where year=2023;

-- The manager asked the employee, how many cars are available of 2020, 2021 and 2022 model.
select count(*) from car_dekho
where year in (2020,2021,2022);

select year, count(*) from car_dekho
where year in (2020,2021,2022) group by year;


-- Clint asked me to print the total of all cars by year.
select year, count(*) from car_dekho
group by year;

-- Client asked the car dealer, how many diesel cars are available for 2020 model.
select count(*) from car_dekho
where fuel="diesel" and year=2020;

-- Client asked the car dealer, how many petrol cars are available for 2020 model. 
select count(*) from car_dekho
where fuel='petrol' and year=2020;

-- The manager asked the employee to print all the fuel cars (Petrol, Diesel, CNG) by year.
select year, count(*) from car_dekho
where fuel in ('petrol', 'diesel', 'cng') group by year;


-- Manager asked which year has the 100 cars?
select year, count(*) from car_dekho group by year having count(*)>100;


-- The manager asked the employee to get the count of all cars between 2015 to 2023.
select year, count(*) from car_dekho between 2015 and 2023 group by year;

select count(*) from car_dekho
where year between 2015 and 2023;


select * from car_dekho
where year between 2015 and 2023;