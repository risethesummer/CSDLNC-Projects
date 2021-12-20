--CREATE DATABASE ORDER_ENTRY
USE ORDER_ENTRY
CREATE TABLE CUSTOMER
(
	CustomerIdentifier CHAR(6) NOT NULL PRIMARY KEY,
	CustomerTelephoneNumber CHAR(10) NOT NULL UNIQUE,
	CustomerName NVARCHAR(20) NOT NULL,
	CustomerStreetAddress NVARCHAR(15) NOT NULL DEFAULT '',
	CustomerCity NVARCHAR(15) NOT NULL DEFAULT '',
	CustomerState NVARCHAR(15) NOT NULL DEFAULT '',
	CustomerZipCode CHAR(6) NOT NULL DEFAULT '',
	CustomerCreditRating FLOAT NOT NULL DEFAULT 0,
	CustomerTotalOrder INT
)

CREATE TABLE Credit_Card
(
	CustomerCreditCardNumber CHAR(16) NOT NULL PRIMARY KEY,
	CustomerIdentifier CHAR(6) NOT NULL,
	CountOrder INT NOT NULL CHECK (CountOrder >=0),
	CustomerCreditCardName NVARCHAR(15),
	PreferredOption BIT
)