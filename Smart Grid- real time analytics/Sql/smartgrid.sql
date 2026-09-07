CREATE DATABASE smart_energy_db;

USE smart_energy_db;

SELECT * FROM energy_data
LIMIT 10;

SELECT COUNT(*) AS total_rows 
FROM energy_data;

SHOW COLUMNS FROM energy_data;

SELECT COUNT(*) AS Total_records
FROM energy_data;   

SELECT ROUND(AVG(power_consumption),2) AS avg_power_consumption
FROM energy_data;

SELECT ROUND(MAX(power_consumption),2) AS Max_power_consumption
FROM energy_data;
SELECT ROUND(MIN(power_consumption),2) AS Min_power_consumption
FROM energy_data;

SELECT COUNT(*) AS observations, 
ROUND(AVG(power_consumption),2) AS avg_consumption,
ROUND(MAX(power_consumption),2) AS max_consumption,
 ROUND(MIN(power_consumption),2) AS Min_consumption,
ROUND(AVG(power_factor),3) AS avg_power_factor, 
ROUND(AVG(reactive_power),2) AS avg_reactive_power
FROM energy_data; 

SELECT transformer_fault, COUNT(*) AS observations FROM energy_data
GROUP BY transformer_fault
ORDER BY observations DESC;

SELECT ROUND(AVG(power_consumption),2) AS avg_consumption, transformer_fault 
FROM energy_data
GROUP BY transformer_fault
ORDER BY avg_consumption DESC;

SELECT transformer_fault,ROUND(MAX(power_consumption),2) AS peak_consumption
FROM energy_data 
GROUP BY transformer_fault
ORDER BY peak_consumption DESC;

SELECT
    transformer_fault,
COUNT(*) AS observations,
ROUND(AVG(power_consumption), 2) AS avg_consumption,
ROUND(MAX(power_consumption), 2) AS peak_consumption,
ROUND(AVG(current), 2) AS avg_current,
ROUND(AVG(voltage), 2) AS avg_voltage,
ROUND(AVG(power_factor), 3) AS avg_power_factor,
ROUND(AVG(reactive_power), 2) AS avg_reactive_power,
ROUND(AVG(voltage_fluctuations), 3) AS avg_voltage_fluctuation
FROM energy_data
GROUP BY transformer_fault
ORDER BY avg_consumption DESC;

SELECT overload_condition ,COUNT(*) AS number_of_records 
FROM energy_data
GROUP BY overload_condition;

SELECT overload_condition, COUNT(*) AS records,
ROUND(COUNT(*)*100/(SELECT COUNT(*) FROM energy_data),2) AS percentage 
FROM energy_data
GROUP BY overload_condition; 

SELECT
    transformer_fault,
    COUNT(*) AS total_records,
    SUM(LOWER(overload_condition) = '0') AS overload_events,
    ROUND(SUM(LOWER(overload_condition) = '1')* 100.0 / COUNT(*),2) AS overload_rate
FROM energy_data
GROUP BY transformer_fault
ORDER BY overload_rate DESC;

SELECT overload_condition, COUNT(*) AS observations,
ROUND(AVG(power_consumption),2) AS avg_consumption,
ROUND(MAX(power_consumption),2) AS peak_consumption,
ROUND(AVG(power_factor),3) AS avg_power_factor
FROM energy_data
GROUP BY overload_condition;

SELECT transformer_fault, ROUND(AVG(power_factor),3) AS avg_power_factor 
FROM energy_data 
GROUP BY transformer_fault
ORDER BY avg_power_factor ASC;

SELECT transformer_fault, power_consumption,reactive_power,power_factor
FROM energy_data
WHERE power_factor >0.80
ORDER BY power_factor ASC;

SELECT transformer_fault, ROUND(AVG(reactive_power),2) AS avg_reactive_power,
ROUND(MAX(reactive_power),2) AS peak_reactive_power
FROM energy_data
GROUP BY transformer_fault
ORDER BY avg_reactive_power ASC;

SELECT ROUND(AVG(solar_power),2) AS avg_solar_power, 
ROUND(AVG(wind_power),2) AS avg_wind_power,
ROUND(AVG(solar_power+wind_power),2) AS avg_renewable_power
FROM energy_data;

SELECT ROUND(SUM(solar_power+ wind_power)*100/ SUM(solar_power+wind_power+grid_supply),2) AS renewable_contribution_pct
FROM energy_data; 

SELECT ROUND(SUM(grid_supply)*100/SUM(solar_power+ wind_power+grid_supply),2) AS grid_dependency_pct
FROM energy_data;

SELECT
    transformer_fault,ROUND(SUM(solar_power + wind_power) * 100.0 /SUM(solar_power +wind_power +grid_supply),2) AS renewable_contribution_pct
FROM energy_data
GROUP BY transformer_fault
ORDER BY renewable_contribution_pct DESC; 

SELECT transformer_fault, ROUND(SUM(grid_supply)*100/SUM(solar_power+wind_power+grid_supply),2) AS grid_dependency_pct
FROM energy_data
GROUP BY transformer_fault
ORDER BY grid_dependency_pct DESC; 

SELECT transformer_fault, power_consumption,current,voltage,power_factor,reactive_power,overload_condition 
FROM energy_data
ORDER BY power_consumption DESC
LIMIT 10; 

SELECT transformer_fault,power_consumption,power_factor,reactive_power,overload_condition
FROM energy_data
WHERE power_factor>0.80
ORDER BY power_consumption DESC; 

SELECT
    transformer_fault,
    power_consumption,
    current,
    voltage,
    power_factor,
    voltage_fluctuations
FROM energy_data
WHERE LOWER(overload_condition) = '1'
ORDER BY power_consumption DESC
LIMIT 20; 

SELECT
    transformer_fault,ROUND(AVG(voltage_fluctuations),3) AS avg_voltage_fluctuation,
ROUND(MAX(voltage_fluctuations),3) AS max_voltage_fluctuation
FROM energy_data
GROUP BY transformer_fault
ORDER BY avg_voltage_fluctuation DESC;

SELECT
    CASE
        WHEN temperature < 20 THEN 'Low'
        WHEN temperature < 30 THEN 'Moderate'
        WHEN temperature < 40 THEN 'High'
        ELSE 'Very High'
    END AS temperature_category,
    COUNT(*) AS observations,ROUND(AVG(power_consumption),2) AS avg_consumption
FROM energy_data
GROUP BY temperature_category
ORDER BY avg_consumption DESC;

SELECT
    CASE
        WHEN electricity_price < 3 THEN 'Low'
        WHEN electricity_price < 6 THEN 'Medium'
        ELSE 'High'
    END AS price_category,COUNT(*) AS observations,
ROUND(AVG(power_consumption),2) AS avg_consumption
FROM energy_data
GROUP BY price_category; 

SELECT transformer_fault,COUNT(*) AS observations,ROUND(AVG(power_consumption), 2)AS avg_consumption,
ROUND(MAX(power_consumption), 2) AS peak_consumption,
ROUND(AVG(power_factor), 3) AS avg_power_factor,
ROUND(AVG(reactive_power), 2) AS avg_reactive_power,
ROUND(AVG(voltage_fluctuations), 3) AS avg_voltage_fluctuation,
ROUND(SUM(LOWER(overload_condition) = '1') * 100.0 / COUNT(*),2) AS overload_rate,
ROUND(SUM(solar_power + wind_power) * 100.0 /SUM(solar_power +wind_power +grid_supply),2) AS renewable_contribution,
ROUND(SUM(grid_supply) * 100.0 /SUM(solar_power +wind_power +grid_supply),2) AS grid_dependency
FROM energy_data
GROUP BY transformer_fault
ORDER BY avg_consumption DESC; 

CREATE VIEW transformer_kpi AS
SELECT transformer_fault,COUNT(*) AS observations, ROUND(AVG(power_consumption), 2) AS avg_consumption,
ROUND(MAX(power_consumption), 2) AS peak_consumption,
ROUND(AVG(power_factor), 3) AS avg_power_factor,
ROUND(AVG(reactive_power), 2) AS avg_reactive_power,
ROUND(AVG(voltage_fluctuations), 3) AS avg_voltage_fluctuation,
ROUND(SUM(LOWER(overload_condition) = '1') * 100.0 / COUNT(*),2) AS overload_rate
FROM energy_data
GROUP BY transformer_fault;

SELECT * FROM transformer_kpi;

CREATE TABLE transformer_info (
    transformer VARCHAR(50) PRIMARY KEY,
    location VARCHAR(100),
    capacity_mva DECIMAL(10,2)
);

INSERT INTO transformer_info
(transformer, location, capacity_mva)
VALUES
('T1', 'Substation A', 10),
('T2', 'Substation B', 16),
('T3', 'Substation C', 25);

SELECT transformer_fault, t.location,t.capacity_mva,
AVG(power_consumption) AS avg_consumption
FROM energy_data  
JOIN transformer_info AS t 
ON transformer_fault = t.transformer
GROUP BY transformer_fault,
t.location,t.capacity_mva; 

SELECT transformer_fault, ROUND(AVG(SQRT(3)*voltage*current)/(t.capacity_mva*1000000)*100,2) AS avg_loading_pct
FROM energy_data
JOIN transformer_info AS t
ON transformer_fault = t.transformer
GROUP BY transformer_fault;  


