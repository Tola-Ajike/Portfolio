Create database projectF;
use projectF;

Create Table Item(
ItemID varchar(50) primary key,
ItemName varchar(50),
Quantity int,
Price double
);

Create table Cloth(
ItemID varchar(50) primary key,
Size char(2),
foreign key (ItemID) references Item(ItemID) on delete no action on update no action
);

Create table Kitchen(
ItemID varchar(50) primary key,
Brand varchar(50),
foreign key (ItemID) references Item(ItemID)  on delete no action on update no action
);

Create table Food(
ItemID varchar(50) primary key,
FrozenFlag boolean,
foreign key (ItemID) references Item(ItemID) on delete no action on update no action
);

Create table Refrigerator(
ItemID varchar(50) primary key,
capacity double,
foreign key (ItemID) references Item(ItemID)  on delete no action on update no action
);

Create table Oven(
ItemID varchar(50) primary key,
OvenType enum('Microwave', 'Gas', 'Electric'),
foreign key (ItemID) references Item(ItemID)  on delete no action on update no action
);

CREATE TABLE Store(
	StoreID VARCHAR(50) PRIMARY KEY,
    StoreName VARCHAR(50),
    StorePhone1  VARCHAR(13),
    StorePhone2  VARCHAR(13),
    StorePhone3  VARCHAR(13)
);

CREATE TABLE Branch(
	BranchName VARCHAR(50),
    Address VARCHAR(100),
    BranchID VARCHAR(50),
    StoreID VARCHAR(50),
    foreign key (StoreID) REFERENCES Store (StoreID) on delete cascade,
    PRIMARY KEY (BranchID, StoreID)
);

CREATE TABLE Customer(
	CustomerID VARCHAR(50),
    CustomerName VARCHAR(50),
    CustomerPhone VARCHAR(13) UNIQUE,
	PRIMARY KEY (CustomerID)
);

CREATE TABLE Buys(
	BuyDate date,
    Quantity REAL,
    CustomerID VARCHAR(50),
    ItemID VARCHAR(50),
    StoreID VARCHAR(50),
	foreign key (CustomerID)  REFERENCES Customer (CustomerID) on delete no action,
	foreign key (ItemID) REFERENCES Item (ItemID) on delete no action,
	foreign key (StoreID) REFERENCES Store (StoreID) on delete no action,
    PRIMARY KEY (CustomerID, ItemID, StoreID)
);

create table Sell(
ItemID varchar(50),
BranchID varchar(50),
StoreID varchar(50),
primary key(ItemID, BranchID, StoreID),
foreign key (ItemID) references Item(ItemID),
foreign key (BranchID,StoreID) references Branch(BranchID,StoreID) on delete no action on update no action
);

INSERT INTO Store (StoreID, StoreName, StorePhone1, StorePhone2, StorePhone3) VALUES
('11001', 'Target', '0097155578645', '0097156743287', '0097165540987'),
('11002', 'Wallmart', '0097144553218', '0097176789753', '0097177709375'),
('11003', 'Matajer', '0097100975326', '0097189976322', '0097173894732'),
('11004', 'Carrefour', '0097188789999', '0097165542098', '0097209831253'),
('11005', 'Spinneys', '0097109809787', '0097169420960', '0097180081355');

INSERT INTO Branch (BranchName, Address, BranchID, StoreID) VALUES
('B1', '112 Main Street', 'B001', '11001'),
('B2', '34 Oak Street', 'B002', '11002'),
('B3', '211B Baker Street', 'B003', '11003'),
('B4', '55 Pine Street', 'B004', '11004'),
('B5', '333 Cedar Street', 'B005', '11005');

INSERT INTO Customer (CustomerID, CustomerName, CustomerPhone) VALUES
('C001', 'Jane Austin', '1234567890'),
('C002', 'Chris Brown', '8849999302'),
('C003', 'John Doe', '5563883244'),
('C004', 'Mike Jhonson', '8871111092'),
('C005', 'David Miller', '7731230974');

INSERT INTO Item
VALUES
('I001', 'Shirt', 30, 29.97),
('I002', 'Pants', 50, 49.95),
('I003', 'Scarf', 80, 79.92),
('I004', 'Pizza', 30, 24.99),
('I005', 'Pasta', 40, 33.32),
('I006', 'Chicken', 20, 16.66),
('I007', 'refrigerator1', 30, 56.99),
('I008', 'refrigerator2', 10, 57.78),
('I009', 'Oven1', 20, 115.56),
('I010', 'Oven2', 10, 53.92),
('I011', 'Cloth4', 52, 40.95),
('I012', 'Cloth5', 40, 20.34),
('I013', 'Potato', 20, 8.34),
('I014', 'Noodles', 19, 15.99),
('I015', 'refrigerator3', 20, 57.78),
('I016', 'refrigerator4', 15, 57.00),
('I017', 'refrigerator5', 25, 100.00),
('I018', 'Oven3', 20, 115.56),
('I019', 'Oven4', 20, 112.56),
('I020', 'Oven5', 20, 113.26);

INSERT INTO Buys (BuyDate, Quantity, CustomerID, ItemID, StoreID) VALUES
('2023-06-01', 5, 'C001', 'I001', '11001'),
('2023-06-03', 4, 'C002', 'I002', '11002'),
('2023-06-09', 9, 'C003', 'I003', '11001'),
('2023-06-12', 1, 'C004', 'I004', '11003'),
('2023-06-28', 6, 'C005', 'I005', '11002');

INSERT INTO Sell (ItemID, BranchID, StoreID) VALUES
('I001', 'B001', '11001'),
('I002', 'B002', '11002'),
('I003', 'B003', '11003'),
('I004', 'B004', '11004'),
('I005', 'B005', '11005');

INSERT INTO Cloth
VALUES ('I001', 'M'), 
('I002', 'L'), 
('I003', 'S'),
('I010', 'M'),
('I011', 'L');

INSERT INTO Food
VALUES ('I004', TRUE), 
('I005', FALSE), 
('I006', TRUE),
('I013', TRUE),
('I014', False);

INSERT INTO Kitchen 
VALUES ('I007', 'Samsung'), 
('I008', 'Whirlpool'), 
('I009', 'LG'), 
('I010', 'Whirlpool'),
('I015', 'LG'),
('I016', 'Samsung'),
('I017', 'Whirlpool'),
('I018', 'LG'),
('I019', 'LG'),
('I020', 'LG');


INSERT INTO Refrigerator
VALUES ('I007', 200), 
('I008', 300),
('I015', 350),
('I016', 500),
('I017', 600);

INSERT INTO Oven
VALUES ('I009', 'Microwave'), 
('I010', 'Gas'),
('I018', 'Gas'),
('I019', 'Microwave'),
('I020', 'Gas');
