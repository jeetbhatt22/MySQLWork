/*
Jeet Bhatt
Student ID Number: U01287989
jb97410n@pace.edu
March 28 2017
IS664 Midterm Exam- Tuesday
*/


drop database if exists pacebooks;
create database pacebooks;
	SELECT CONCAT('DATABASE pacebooks CREATED  ', NOW()) AS Msg;

	use pacebooks;


	create table book(
		ISBN varchar(20) NOT NULL Primary Key,
		Title varchar(20) NOT NULL,
		AuthorID varchar(20) NOT NULL,
		Subject varchar(20) NOT NULL,
		PublisherID varchar(20) NOT NULL
		);

	create table author(
		IDNumber varchar(20) NOT NULL Primary Key,
		FName varchar(20) NOT NULL,
		LName varchar(20) NOT NULL,
		FirstPublished date
		);

	create table publisher(
		PNumber varchar(20) NOT NULL Primary Key,
		Name varchar(20) NOT NULL,
		HQ varchar(20) NOT NULL
		);

	create table pricing(
		ISBN varchar(20) NOT NULL Primary Key,
		WCost decimal(5,3) Not Null,
		RCost decimal(5,3) Not Null,
		PrintCostGCAverage decimal(5,3) AS (((WCost + RCost)/2)*0.612) STORED,
		CONSTRAINT fk_pri FOREIGN KEY (ISBN) REFERENCES book(ISBN)
		);

	create table location(
		ISBN varchar(20) NOT NULL Primary Key,
		Floor int(10) NOT NULL,
		Shelf varchar(20) NOT NULL,
		CONSTRAINT fk_loc FOREIGN KEY (ISBN) REFERENCES book(ISBN)
		);


	insert into book(ISBN, Title, AuthorID, Subject, PublisherID) values ('1-00-1000','American Frogs','James Lilly','Amphibians','Macmillan House'),('1-01-1001','Frogs In America', 'Robert Padd', 'Frogs and Toads','Prestige Publishing'),('1-01-1002','Kermit- A Frogs Life','Kermit Frog','Tree Frogs', 'Waterbright House');
	insert into author(IDNumber, FName, LName, FirstPublished) values ('A-001','James','Lilly','1978-01-01'),('A-002','Robert','Padd','2000-03-21'),('A-003','Kermit','Frog','2010-08-24');
	insert into publisher(PNumber, Name, HQ) values ('P-001','Macmillan House','New York,NY'),('P-002','Prestige Publishing','ST Louis,MO'),('P-003','Waterbright House','Atlanta,GA');
	insert into pricing(ISBN, WCost, RCost)	values	('1-00-1000','52.95','72.00'),('1-01-1001','59.00','80.00'),('1-01-1002','67.80','87.00');
	insert into location(ISBN, Floor, Shelf) values ('1-00-1000','1','F-09-01'),('1-01-1001','2','F-10-06'),('1-01-1002','3','F-11-11');


## Task 1

select 'Task 1' as Msg;

DELIMITER //
CREATE FUNCTION ContainsFROG (A varchar(20))
RETURNS varchar(20)

Begin
	
	DECLARE Result varchar(10);
	DECLARE IS1 varchar(20);
	DECLARE IS2 varchar(20);
	DECLARE IS3 varchar(20);

	SET Result = '';
	SET IS1 = '1-00-1000';
	SET IS2 = '1-01-1001';
	SET IS3 = '1-01-1002';

	IF A= IS1 THEN SET Result= 'No'; END IF;
	IF A= IS2 THEN SET Result= 'Yes'; END IF;
	IF A= IS3 THEN SET Result= 'Yes'; END IF;

	Return Result;

END //
DELIMITER ;

select ContainsFROG('1-00-1000') As Msg;
select ContainsFROG('1-01-1001') As Msg;
select ContainsFROG('1-01-1002') As Msg;

## Task 2

select 'Task 2' as Msg;

DELIMITER //
CREATE FUNCTION PublishState (B varchar(20))
RETURNS varchar(20)

Begin
	
	DECLARE State varchar(20);
	DECLARE ISS1 varchar(20);
	DECLARE ISS2 varchar(20);
	DECLARE ISS3 varchar(20);

	SET State = '';
	SET ISS1 = '1-00-1000';
	SET ISS2 = '1-01-1001';
	SET ISS3 = '1-01-1002';

	IF B= ISS1 THEN SET State= 'New York'; END IF;
	IF B= ISS2 THEN SET State= 'Missouri'; END IF;
	IF B= ISS3 THEN SET State= 'Georgia '; END IF;

	Return State;

END //
DELIMITER ;

select PublishState('1-00-1000') As Msg;
select PublishState('1-01-1001') As Msg;
select PublishState('1-01-1002') As Msg;

## Task 3

select 'Task 3' as Msg;

CREATE VIEW booksubject AS Select book.ISBN, book.Title, publisher.HQ, pricing.PrintCostGCAverage, book.AuthorID as 'Full Name', ContainsFROG(book.ISBN) as 'Frog', PublishState(book.ISBN) as 'State' from book 
INNER JOIN publisher ON book.PublisherID = publisher.Name INNER JOIN pricing ON book.ISBN = pricing.ISBN;

select * from booksubject;
