/*
Jeet Bhatt
Student ID Number: U01287989
Email ID: jb97410n@pace.edu
9th May 2017
IS667 Final Exam
*/

use paceimperial;

select "Jeet Bhatt and Bhatt.sql" as 'Msg';

DROP PROCEDURE IF EXISTS CommandCasualtyReport ;
DELIMITER //
CREATE PROCEDURE CommandCasualtyReport(DivInput varchar(5), Name varchar(5))

	BEGIN
	DECLARE UnitNumber_1, Wounded_6, Killed_7, Ineff_8, Row_Count FLOAT;
	DECLARE DivN_2, Reg_3, Bn_4, Co_5, U_Type_10, U_Rating_11, Cmdr_12 VARCHAR(25);
	DECLARE L_Rating_9 Decimal(5,2);

	DECLARE cur1 Cursor for 
	SELECT d.UnitID, r.UnitID, b.UnitID, c.UnitID, c.Troopers_WIA, c.Troopers_KIA, (c.Troopers_WIA + c.Troopers_KIA),u.Type, u.Status,ic.Name
--				2			3		4			5			6			7				8								10		11  	12
		FROM stormtrooper_co c
		JOIN stormtrooper_unit u
			ON u.IDNumber = c.UnitID
		JOIN stormtrooper_bn b
			ON c.UnitID = b.CompanyA
			OR c.UnitID = b.CompanyB
			OR c.UnitID = b.CompanyC
		JOIN stormtrooper_reg r
			ON b.UnitID = r.BattalionA
			OR b.UnitID = r.BattalionB	
		JOIN stormtrooper_div d
			ON r.UnitID = d.RegimentA
			OR r.UnitID = d.RegimentB
			OR r.UnitID = d.RegimentC
		JOIN imperial_commander ic
			ON ic.UnitID = d.UnitID
			OR ic.UnitID = r.UnitID
			OR ic.UnitID = b.UnitID
		WHERE (ic.Name LIKE Name)  AND d.UnitID = DivInput;

		DROP TABLE IF EXISTS Casualty_Rating;
		CREATE TABLE Casualty_Rating(

			UnitNumber FLOAT,
			DivN VARCHAR(6),
			Reg VARCHAR(6),
			Bn VARCHAR(6),
			Co VARCHAR(6),
			Wounded FLOAT,
			Killed FLOAT,
			Ineffective FLOAT,
			L_Rating Decimal(5,2),
			U_Type VARCHAR(25),
			U_Rating VARCHAR(25),
			Cmdr VARCHAR(25)
		);

		OPEN cur1;
		SET UnitNumber_1=0;

		SELECT FOUND_ROWS() INTO Row_Count;

		Casualty_loop: LOOP
			FETCH cur1 INTO DivN_2, Reg_3, Bn_4, Co_5, Wounded_6, Killed_7, Ineff_8, U_Type_10, U_Rating_11, Cmdr_12;
--						 d.UnitID, r.UnitID, b.UnitID, c.UnitID, c.Troopers_WIA, c.Troopers_KIA,c.OH_Strength,u.Type, u.Status,ic.Name			
--							2			3		4		5			6					7			8			10			11		12

			SET L_Rating_9 = 0;
			
			IF U_Type_10 = 'Scout' AND U_Rating_11 = 'Guard' THEN
					SET L_Rating_9 = ((Wounded_6 + Killed_7) * 0.32);
			END IF;

			IF U_Type_10 = 'Scout' AND U_Rating_11 = 'Regular' THEN
					SET L_Rating_9 = ((Wounded_6 + Killed_7) * 0.42);
			END IF;

			IF U_Type_10 = 'Infantry' AND U_Rating_11 = 'Guard' THEN
					SET L_Rating_9 = ((Wounded_6 + Killed_7) * 0.52);
			END IF;

			IF U_Type_10 = 'Infantry' AND U_Rating_11 = 'Regular' THEN
					SET L_Rating_9 = ((Wounded_6 + Killed_7) * 0.62);
			END IF;
			IF U_Type_10 = 'Assault Infantry' THEN
					SET L_Rating_9 = ((Wounded_6 + Killed_7) * 0.72);
			END IF;

			SET UnitNumber_1 = UnitNumber_1+1;

			INSERT INTO Casualty_Rating(UnitNumber, DivN, Reg, Bn, Co, Wounded,Killed,Ineffective,L_Rating,U_Type, U_Rating,Cmdr)
				VALUES (UnitNumber_1, DivN_2, Reg_3, Bn_4, Co_5, Wounded_6, Killed_7, Ineff_8, L_Rating_9, U_Type_10, U_Rating_11, Cmdr_12); 					

			IF Row_Count = UnitNumber_1 THEN
				LEAVE Casualty_loop;
			END IF;

		END LOOP;

		CLOSE cur1 ;

		SELECT * FROM Casualty_Rating;
	END //
DELIMITER ;


Call CommandCasualtyReport('DIV01', 'L%');
Call CommandCasualtyReport('DIV02', 'T%');
Call CommandCasualtyReport('DIV03', 'P%');

