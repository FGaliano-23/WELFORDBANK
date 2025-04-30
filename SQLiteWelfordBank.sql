CREATE TABLE Clients (
    Client_ID INT PRIMARY KEY,
    Type_Client VARCHAR(50) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Surname VARCHAR(100) NOT NULL,
    Date_Birth DATE,
    Gender VARCHAR(10),
    Address TEXT,
    City VARCHAR(100),
    Country VARCHAR(100),
    Phone VARCHAR(20),
    Email VARCHAR(255) UNIQUE,
    Registration_Date DATE NOT NULL,
    Customer_Segment VARCHAR(100),
    Customer_Lifetime_Value DECIMAL(15,2),
    Status ENUM('Active', 'Inactive') NOT NULL
);
CREATE TABLE Accounts (
    Account_ID INT PRIMARY KEY,
    Account_Type VARCHAR(50) NOT NULL,
    Client_ID INT NOT NULL,
    Type_Client VARCHAR(50) NOT NULL,
    Office_Code INT NOT NULL, --IBAN
    Entity_Code VARCHAR(10), --IBAN
    Check_Digit VARCHAR(5), --IBAN
    Account_Number VARCHAR(20) UNIQUE NOT NULL, --IBAN
    Balance DECIMAL(15,2) DEFAULT 0,
    Currency VARCHAR(10),
    Interest_Rate DECIMAL(5,2),
    Status ENUM('Active', 'Inactive') NOT NULL,
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Income DECIMAL(15,2),
    FOREIGN KEY (Client_ID, Type_Client) REFERENCES Clients(Client_ID, Type_Client),
    FOREIGN KEY (Office_Code) REFERENCES Sucursal(Office_Code)
);
CREATE TABLE Credit_History (
    History_ID INT PRIMARY KEY,
    Client_ID INT NOT NULL,
    Type_Client VARCHAR(50) NOT NULL,
    Transaction_ID INT NOT NULL,
    Credit_Amount DECIMAL(15,2),
    Payment_Amount DECIMAL(15,2),
    Outstanding_Balance DECIMAL(15,2),
    Interest_Rate DECIMAL(5,2),
    Payment_Status VARCHAR(50),
    Late_Payment_Fees DECIMAL(10,2),
    Transaction_Date DATE,
    Payment_Due_Date DATE,
    Last_Payment_Date DATE,
    Credit_Score INT,
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    FOREIGN KEY (Client_ID, Type_Client) REFERENCES Clients(Client_ID, Type_Client)
);
CREATE TABLE Loans (
    Loan_ID INT PRIMARY KEY,
    Client_ID INT NOT NULL,
    Type_Client VARCHAR(50) NOT NULL,
    Loan_Type VARCHAR(100) NOT NULL,
    Principal_Amount DECIMAL(15,2) NOT NULL,
    Interest_Rate DECIMAL(5,2) NOT NULL,
    Loan_Term_Months INT NOT NULL,
    Start_Date DATE NOT NULL,
    End_Date DATE NOT NULL,
    Outstanding_Balance DECIMAL(15,2) DEFAULT 0,
    Loan_Status ENUM('Payed', 'Not Payed') DEFAULT 'Not Payed',
    Default_Status ENUM('In Good Standing', 'In Default') DEFAULT 'In Good Standing', 
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Client_ID, Type_Client) REFERENCES Clients(Client_ID, Type_Client)
);

CREATE TABLE Investments (
    Investment_ID INT PRIMARY KEY,
    Client_ID INT NOT NULL,
    Type_Client VARCHAR(50) NOT NULL,
    Account_ID INT NOT NULL,
    Investment_Type VARCHAR(100) NOT NULL,
    Investment_Amount DECIMAL(15,2) NOT NULL,
    Current_Value DECIMAL(15,2) DEFAULT 0,
    Interest_Rate DECIMAL(5,2),
    Start_Date DATE NOT NULL,
    Maturity_Date DATE NOT NULL,
    Risk_Level VARCHAR(50),
    Status ENUM('Active', 'Closed') NOT NULL,
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (Client_ID, Type_Client) REFERENCES Clients(Client_ID, Type_Client),
    FOREIGN KEY (Account_ID) REFERENCES Accounts(Account_ID)
);

CREATE TABLE Digital_Interactions (
    Interaction_ID INT PRIMARY KEY,
    Client_ID INT NOT NULL,
    Type_Client VARCHAR(50) NOT NULL, ###MIRAR SI PONERLO O NO
    Channel ENUM('Web', 'App', 'Call Center') NOT NULL,
    Action_Type ENUM('Login', 'Transfer', 'Consult') NOT NULL,
    Resolution_Time INT, -- Tiempo en segundos o minutos según convenga
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Client_ID, Type_Client) REFERENCES Clients(Client_ID, Type_Client)
);
CREATE TABLE Customer_Feedback (
    Feedback_ID INT PRIMARY KEY,
    Client_ID INT NOT NULL,
    Survey_Date DATE NOT NULL,
    NPS_Score INT CHECK (NPS_Score BETWEEN 0 AND 10),
    Comments TEXT,
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --MIRAR SI PONERLO O NO
    FOREIGN KEY (Client_ID) REFERENCES Clients(Client_ID)
);
CREATE TABLE Customer_Growth (
    Customer_Growth_ID INT PRIMARY KEY AUTO_INCREMENT,
    Date DATE NOT NULL,
    New_Customers INT DEFAULT 0,
    Previous_Customers INT DEFAULT 0,
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP --MIRAR SI PONERLO O NO
);

CREATE TABLE Sucursal (
    Office_Code INT PRIMARY KEY,
    Office_Name VARCHAR(100) NOT NULL,
    Location VARCHAR(255) NOT NULL,
    Manager VARCHAR(100),
    Total_Revenue DECIMAL(15,2) DEFAULT 0
);

CREATE TABLE Cards (
    Card_ID INT PRIMARY KEY,
    Card_Type VARCHAR(50) NOT NULL,
    Client_ID INT NOT NULL,
    Type_Client VARCHAR(50) NOT NULL,
    Account_ID INT NOT NULL,
    Card_Number VARCHAR(20) UNIQUE NOT NULL,
    CVV VARCHAR(4) NOT NULL,
    Expiration_Date DATE NOT NULL,
    Issuing_Bank VARCHAR(100),
    Credit_Limit DECIMAL(15,2) NOT NULL,
    Available_Balance DECIMAL(15,2) DEFAULT 0,
    Status ENUM('Active', 'Inactive') NOT NULL,
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Credit_Card_Usage DECIMAL(15,2) DEFAULT 0,
    FOREIGN KEY (Client_ID, Type_Client) REFERENCES Clients(Client_ID, Type_Client),
    FOREIGN KEY (Account_ID) REFERENCES Accounts(Account_ID)
);
CREATE TABLE Fraud_Detections (
    Fraud_ID INT PRIMARY KEY,
    Client_ID INT NOT NULL,
    Transaction_ID INT NOT NULL,
    Fraud_Type VARCHAR(100) NOT NULL,
    Detection_Date DATE NOT NULL,
    Status ENUM('Under Investigation', 'Resolved') DEFAULT 'Under Investigation',
    Resolved_Incidents INT DEFAULT 0,
    FOREIGN KEY (Client_ID) REFERENCES Clients(Client_ID),
    FOREIGN KEY (Transaction_ID) REFERENCES Transactions(Transaction_ID)
);
CREATE TABLE Transactions (
    Transaction_ID INT PRIMARY KEY,
    Client_ID INT NOT NULL,
    Type_Client VARCHAR(50) NOT NULL,
    Account_ID INT NOT NULL,
    Transaction_Type VARCHAR(100) NOT NULL,
    Transaction_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Transaction_Duration INT,
    Location VARCHAR(255),
    Device VARCHAR(100),
    Ip_Address VARCHAR(50),
    Amount DECIMAL(15,2) NOT NULL,
    Currency VARCHAR(10) NOT NULL,
    Description TEXT,
    Is_Fraud BOOLEAN DEFAULT FALSE,
    Status ENUM('Completed', 'Pending', 'Failed') NOT NULL,
    Counterparty_Account VARCHAR(20),
    External_Bank_Name VARCHAR(100),
    External_Bank_Code VARCHAR(50),
    FOREIGN KEY (Client_ID, Type_Client) REFERENCES Clients(Client_ID, Type_Client),
    FOREIGN KEY (Account_ID) REFERENCES Accounts(Account_ID)
);
CREATE TABLE Loan_Payments (
    Payment_ID INT PRIMARY KEY,
    Client_ID INT NOT NULL,
    Type_Client VARCHAR(50) NOT NULL,
    Loan_ID INT NOT NULL,
    Payment_Date DATE NOT NULL,
    Payment_Amount DECIMAL(15,2) NOT NULL,
    Payment_Method VARCHAR(50) NOT NULL,
    Payment_Status ENUM('Puntual', 'Retrasado', 'Incumplido') NOT NULL,
    FOREIGN KEY (Client_ID, Type_Client) REFERENCES Clients(Client_ID, Type_Client),
    FOREIGN KEY (Loan_ID) REFERENCES Loans(Loan_ID)
);
CREATE TABLE Financial_Products (
    FinancialProduct_ID INT PRIMARY KEY,
    Client_ID INT NOT NULL,
    Type_Client VARCHAR(50) NOT NULL,
    Investment_ID INT NOT NULL,
    Product_Name VARCHAR(100) NOT NULL,
    Product_Type VARCHAR(100) NOT NULL,
    Description TEXT,
    Interest_Rate DECIMAL(5,2) NOT NULL,
    Minimum_Investment DECIMAL(15,2),
    Maximum_Investment DECIMAL(15,2),
    Risk_Level VARCHAR(50),
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Client_ID, Type_Client) REFERENCES Clients(Client_ID, Type_Client),
    FOREIGN KEY (Investment_ID) REFERENCES Investments(Investment_ID)
);
CREATE TABLE Digital_Engagement (
    Digital_Engagement_ID INT PRIMARY KEY AUTO_INCREMENT,
    Date DATE NOT NULL,
    New_Digital_Users INT DEFAULT 0,
    Total_Visitors INT DEFAULT 0,
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP --MIRAR SI PONERLO O NO
);
CREATE TABLE Online_Service_Metrics (
    Online_Service_Metrics_ID INT PRIMARY KEY AUTO_INCREMENT,
    Date DATE NOT NULL,
    Total_Resolution_Time INT DEFAULT 0, -- Tiempo total de resolución (en segundos o minutos)
    Total_Requests INT DEFAULT 0,
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --MIRAR SI PONERLO O NO
    FOREIGN KEY (Date) REFERENCES Digital_Engagement(Date)
);
CREATE TABLE Customer_Satisfaction (
    Customer_Satisfaction_ID INT PRIMARY KEY AUTO_INCREMENT,
    Date DATE NOT NULL,
    Promoters INT DEFAULT 0,
    Detractors INT DEFAULT 0,
    Total_Surveys INT DEFAULT 0, -- Cantidad total de encuestas realizadas
    Total_Scores DECIMAL(10,2) DEFAULT 0, -- Puntuación total de satisfacción
);
CREATE TABLE Finance (
    Finance_ID INT PRIMARY KEY AUTO_INCREMENT,
    Date DATE NOT NULL,
    Total_Assets DECIMAL(18,2) NOT NULL,
    Total_Liabilities DECIMAL(18,2) NOT NULL,
    Total_Equity DECIMAL(18,2) NOT NULL,
    Revenue DECIMAL(18,2) NOT NULL,
    Expenses DECIMAL(18,2) NOT NULL,
    Net_Profit DECIMAL(18,2) NOT NULL,
    Report_Date DATE NOT NULL,
    Currency VARCHAR(10) NOT NULL,
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE Financial_Metrics (
    Financial_Metrics_ID INT PRIMARY KEY AUTO_INCREMENT,
    Date DATE NOT NULL,
    Interest_Income DECIMAL(18,2) NOT NULL,
    Interest_Expense DECIMAL(18,2) NOT NULL,
    Average_Earning_Assets DECIMAL(18,2) NOT NULL,
    Net_Income DECIMAL(18,2) NOT NULL,
    Average_Total_Assets DECIMAL(18,2) NOT NULL,
    Average_Equity DECIMAL(18,2) NOT NULL,
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- ###MIRAR SI PONERLO O NO
    FOREIGN KEY (Date) REFERENCES Finance(Date)
);
CREATE TABLE Loan_Metrics (
    Loan_Metrics_ID INT PRIMARY KEY AUTO_INCREMENT,
    Date DATE NOT NULL,
    Non_Performing_Loans INT NOT NULL,
    Total_Loans INT NOT NULL,
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- ###MIRAR SI PONERLO O NO
    FOREIGN KEY (Date) REFERENCES Finance(Date)
);
