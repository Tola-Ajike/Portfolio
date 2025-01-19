
## **Overview**

This project aims to analyse a used-cars dataset using SQL and Power BI to uncover insights. By exploring patterns and trends within the dataset, the objective is to address various business-related questions.

**DATASET:**  https://www.kaggle.com/datasets/avikasliwal/used-cars-price-prediction

**SCHEMA:
**
CREATE TABLE USED_CARS_TEST_DATA(
carID int primary key,
carName varchar(100),
location varchar(100),
manufactuerYear int,
kilometers int,
fuelType varchar(100),
transmission varchar(100),
ownerType varchar(100),
Mileage double,
carEngine varchar(100),
power varchar(100),
seats int,
new_price varchar(100)
);

I then used the Table Import Wizard to import the CSV file into the table on MySQL Workbench.

**Business Questions and Answers:**

1: Identify the most listed car model.
select carName, count(carName) from USED_CARS_TEST_DATA group by carName order by count(carName) desc limit 1;

![image](https://github.com/user-attachments/assets/3c912d9d-0cfe-45be-8b01-ca6dd8bc9370)

2: Understand which transmission type is more common
select transmission, count(transmission) from USED_CARS_TEST_DATA group by transmission order by count(transmission) desc;

![image](https://github.com/user-attachments/assets/606273c6-e78e-4c82-a147-2cb1f535b6cf)


3: Identify locations where older cars are more frequently listed.
select location, AVG(2025 - manufactuerYear) as 'average age' from USED_CARS_TEST_DATA group by location order by 2 desc;

![image](https://github.com/user-attachments/assets/0883920c-2f6d-4145-a78e-4eeea135604c)


4: Analyze the impact of fuel type on fuel efficiency.
select fuelType, AVG(mileage) from USED_CARS_TEST_DATA group by fuelType;

![image](https://github.com/user-attachments/assets/e468c1c8-910e-4d70-9bbc-41802ce21072)











