create database Employee_Management_System;
use Employee_Management_System;

create TABLE Employees ( EmployeeID  int Primary Key, Name VARCHAR(50),
DepartmentID NVARCHAR(50)  Foreign Key references Departments(DepartmentID) ,HireDate int);
select * from Employees;

CREATE TABLE Departments (DepartmentID NVARCHAR(50)Primary Key,DepartmentName VARCHAR(50));SELECT * from Departments; CREATE TABLE Salaries(EmployeeID int Foreign Key references Employees(EmployeeID ), BaseSalary int ,Bonus int,Deductions int); SELECT * from Salaries;  insert into Employees (EmployeeID,Name,DepartmentID,HireDate )values(101,'Arjun Mohan','A11',2022),(102,'Jaya Krishnan','A11',2024),(103,'Aswathi Sivan','B11',2018),(104,'Manoj S Kumar','C11',2020),(105,'Arathi Krishna','B11',2023);insert into Departments (DepartmentID,DepartmentName)values('A11','IT'),('B11','HR'),('C11','MARKETING');insert into Salaries(EmployeeID,BaseSalary,Bonus,Deductions)values(101,35000,5000,1000),(102,35000,5000,1500),(103,30000,2000,800),(104,25000,1500,900),(105,30000,2000,500);/*List all employees along with their department names */SELECT 
    e.EmployeeID, 
    e.Name, 
    d.DepartmentName
FROM 
    Employees e
JOIN 
    Departments d ON e.DepartmentID = d.DepartmentID;/* Calculate the net salary*/	SELECT 
    e.EmployeeID, 
    e.Name, 
    s.BaseSalary, 
    s.Bonus, 
    s.Deductions, 
    (s.BaseSalary + s.Bonus - s.Deductions) AS NetSalary
FROM 
    Employees e
JOIN 
    Salaries s ON e.EmployeeID = s.EmployeeID;/* The department with the highest average salary.*/	SELECT TOP 1 
    d.DepartmentName, 
    AVG(s.BaseSalary) AS AvgSalary
FROM 
    Departments d
JOIN 
    Employees e ON d.DepartmentID = e.DepartmentID
JOIN 
    Salaries s ON e.EmployeeID = s.EmployeeID
GROUP BY 
    d.DepartmentName
ORDER BY 
    AvgSalary DESC;	/*Add Employee Stored Procedure*/ 	
CREATE PROCEDURE AddEmployee
    @Name VARCHAR(50),
    @DepartmentID INT,
    @HireDate INT,
    @BaseSalary DECIMAL(10, 2),
    @Bonus DECIMAL(10, 2),
    @Deductions DECIMAL(10, 2)
AS
BEGIN
    DECLARE @NewEmployeeID INT;


    INSERT INTO Employees (Name, DepartmentID, HireDate)
    VALUES (@Name, @DepartmentID, @HireDate);

    SET @NewEmployeeID = SCOPE_IDENTITY();

    
    INSERT INTO Salaries (EmployeeID, BaseSalary, Bonus, Deductions)
    VALUES (@NewEmployeeID, @BaseSalary, @Bonus, @Deductions);
END;

/*Update Salary*/

CREATE PROCEDURE UpdateSalary
    @EmployeeID INT,
    @NewBaseSalary DECIMAL(10, 2),
    @NewBonus DECIMAL(10, 2),
    @NewDeductions DECIMAL(10, 2)
AS
BEGIN
    UPDATE Salaries
    SET 
        BaseSalary = @NewBaseSalary,
        Bonus = @NewBonus,
        Deductions = @NewDeductions
    WHERE 
        EmployeeID = @EmployeeID;
END;

 /*Calculate Payroll*/
CREATE PROCEDURE CalculatePayroll
AS
BEGIN
    SELECT 
        SUM(BaseSalary + Bonus - Deductions) AS TotalPayroll
    FROM 
        Salaries;
END;


/*VIEW*/

CREATE VIEW EmployeeSalaryView AS
SELECT 
    Employees.EmployeeID,
    Employees.Name,
    Departments.DepartmentName,
    Salaries.BaseSalary,
    Salaries.Bonus,
    Salaries.Deductions,
    (Salaries.BaseSalary + Salaries.Bonus - Salaries.Deductions) AS NetSalary
FROM 
    Employees
INNER JOIN 
    Departments ON Employees.DepartmentID = Departments.DepartmentID
INNER JOIN 
    Salaries ON Employees.EmployeeID = Salaries.EmployeeID;



CREATE VIEW HighEarnerView AS
SELECT 
    Employees.EmployeeID,
    Employees.Name,
    (Salaries.BaseSalary + Salaries.Bonus - Salaries.Deductions) AS NetSalary
FROM 
    Employees
INNER JOIN 
    Salaries ON Employees.EmployeeID = Salaries.EmployeeID
WHERE 
    (Salaries.BaseSalary + Salaries.Bonus - Salaries.Deductions) > 1000; 


