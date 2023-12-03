-- This file is to bootstrap a database for the CS3200 project. 

-- Create a new database.  You can change the name later.  You'll
-- need this name in the FLASK API file(s),  the AppSmith 
-- data source creation.
drop database if exists professional_link;
create database professional_link;

-- Via the Docker Compose file, a special user called webapp will 
-- be created in MySQL. We are going to grant that user 
-- all privilages to the new database we just created. 
-- TODO: If you changed the name of the database above, you need 
-- to change it here too.
grant all privileges on professional_link.* to 'webapp'@'%';
flush privileges;

-- Move into the database we just created.
-- TODO: If you changed the name of the database above, you need to
-- change it here too. 
use professional_link;

-- Put your DDL 


CREATE TABLE College (
  College_Name VARCHAR(40) UNIQUE NOT NULL,
  Ranking int,
  AppReqs VARCHAR(40),
  PRIMARY KEY (College_Name)
);

CREATE TABLE Profile (
  p_id int NOT NULL AUTO_INCREMENT,
  FirstName VARCHAR(40),
  LastName VARCHAR(40),
  Phone VARCHAR(22),
  Email VARCHAR(40),
  Background VARCHAR(40),
  PRIMARY KEY (p_id)
);

CREATE TABLE Student (
  s_id int NOT NULL AUTO_INCREMENT,
  BirthDate date NOT NULL,
  Major VARCHAR(40),
  Age int,
  FirstName VARCHAR(40),
  LastName VARCHAR(40),
  Grade int,
  College_Name VARCHAR(40) NOT NULL,
  p_id int NOT NULL,
  PRIMARY KEY (s_id),
  FOREIGN KEY (College_Name)
    REFERENCES College (College_Name)
    ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (p_id)
    REFERENCES Profile (p_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Network (
  s_id int NOT NULL,
  connection int NOT NULL,
  PRIMARY KEY (s_id, connection),
  FOREIGN KEY (s_id)
    REFERENCES Student (s_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (connection)
    REFERENCES Student (s_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Soft_Skill_Resource (
  Title VARCHAR(40) NOT NULL,
  Content VARCHAR(40),
  Format VARCHAR(40),
  PRIMARY KEY (Title)
);

CREATE TABLE Interview_Resource (
  Title VARCHAR(40) NOT NULL,
  Content VARCHAR(40),
  Format VARCHAR(40),
  PRIMARY KEY (Title)
);

CREATE TABLE Work (
  CompanyName VARCHAR(100) NOT NULL,
  Industry VARCHAR(100),
  PRIMARY KEY (CompanyName)
);

CREATE TABLE Mentor (
  m_id int NOT NULL AUTO_INCREMENT,
  BirthDate date NOT NULL,
  Age int NOT NULL,
  FirstName VARCHAR(40),
  LastName VARCHAR(40),
  Specialization VARCHAR(40),
  p_id int NOT NULL,
  PRIMARY KEY (m_id),
  FOREIGN KEY (p_id)
    REFERENCES Profile (p_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Lab (
  Lab_Name VARCHAR(40) NOT NULL,
  LabType VARCHAR(40),
  College_Name VARCHAR(40) NOT NULL,
  FOREIGN KEY (College_Name)
    REFERENCES College (College_Name)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Schedule (
  schedule_id int NOT NULL AUTO_INCREMENT,
  EventType VARCHAR(40),
  StartTime datetime NOT NULL DEFAULT now(),
  EndTime datetime NOT NULL DEFAULT now(),
  Background VARCHAR(40),
  m_id int NOT NULL,
  PRIMARY KEY (schedule_id),
  FOREIGN KEY (m_id)
    REFERENCES Mentor (m_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Mentoring_Resource (
  Title VARCHAR(40) NOT NULL,
  Content VARCHAR(40),
  Format VARCHAR(40),
  PRIMARY KEY (Title)
);

CREATE TABLE Professional_Page (
  p_id int NOT NULL AUTO_INCREMENT,
  Phone VARCHAR(22),
  Email VARCHAR(40),
  m_id int NOT NULL,
  PRIMARY KEY (p_id),
  FOREIGN KEY (m_id)
    REFERENCES Mentor (m_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Interacts_With (
  s_id int NOT NULL,
  m_id int NOT NULL,
  PRIMARY KEY (s_id, m_id),
  FOREIGN KEY (s_id)
    REFERENCES Student (s_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (m_id)
    REFERENCES Mentor (m_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Access_SSR (
  s_id int NOT NULL,
  Title VARCHAR(40) NOT NULL,
  PRIMARY KEY (s_id, Title),
  FOREIGN KEY (s_id)
    REFERENCES Student (s_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (Title)
    REFERENCES Soft_Skill_Resource (Title)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Access_IR (
  s_id int NOT NULL,
  Title VARCHAR(40) NOT NULL,
  PRIMARY KEY (s_id, Title),
  FOREIGN KEY (s_id)
    REFERENCES Student (s_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (Title)
    REFERENCES Interview_Resource (Title)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Is_Looking_For (
  s_id int NOT NULL,
  CompanyName VARCHAR(40) NOT NULL,
  PRIMARY KEY (s_id, CompanyName),
  FOREIGN KEY (s_id)
    REFERENCES Student (s_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (CompanyName)
    REFERENCES Work (CompanyName)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Work_Address (
  CompanyName VARCHAR(40) NOT NULL,
  Street VARCHAR(40),
  City VARCHAR(40),
  US_State VARCHAR(40),
  Zip CHAR(5),
  PRIMARY KEY (CompanyName),
  FOREIGN KEY (CompanyName)
    REFERENCES Work (CompanyName)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE College_Address (
  College_Name VARCHAR(40) NOT NULL,
  Street VARCHAR(40),
  City VARCHAR(40),
  US_State VARCHAR(40),
  Zip CHAR(5),
  PRIMARY KEY (College_Name),
  FOREIGN KEY (College_Name)
    REFERENCES College (College_Name)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Works_At (
  m_id int NOT NULL,
  CompanyName VARCHAR(40) NOT NULL,
  PRIMARY KEY (m_id, CompanyName),
  FOREIGN KEY (m_id)
    REFERENCES Mentor (m_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (CompanyName)
    REFERENCES Work (CompanyName)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Associated_With (
  m_id int NOT NULL,
  College_Name VARCHAR(40) NOT NULL,
  PRIMARY KEY (m_id, College_Name),
  FOREIGN KEY (m_id)
    REFERENCES Mentor (m_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (College_Name)
    REFERENCES College (College_Name)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Access_MR (
  m_id int NOT NULL,
  Title VARCHAR(40) NOT NULL,
  PRIMARY KEY (m_id, Title),
  FOREIGN KEY (m_id)
    REFERENCES Mentor (m_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (Title)
    REFERENCES Mentoring_Resource (Title)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Accreditations (
  p_id int NOT NULL,
  Accred_Type VARCHAR(40),
  PRIMARY KEY (p_id),
  FOREIGN KEY (p_id)
    REFERENCES Professional_Page (p_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

-- Add sample data.

INSERT INTO College
  (College_Name, Ranking, AppReqs)
VALUES
('Princeton', 1, 'Extra Essay'),
('Yale', 2, 'Extra Essay'),
('Stanford', 3, 'Extra Essay'),
('MIT', 4, 'Personal Statement'),
('UC Berkeley', 5, 'LOR'),
('Columbia', 6, 'LOR'),
('UCLA', 7, 'Extra Essay'),
('UPenn', 8, 'Extra Essay'),
('Harvard', 9, 'Extra Essay'),
('Williams', 10, 'Extra Essay'),
('Amherst', 11, 'Personal Statement'),
('Cornell', 12, 'Extra Essay'),
('John Hopkins', 13, 'LOR'),
('USC', 14, 'LOR'),
('Brown', 15, 'LOR'),
('Dartmouth', 16, 'Extra Essay'),
('Duke', 17, 'LOR'),
('Northwestern', 18, 'LOR'),
('Vanderbilt', 19, 'LOR'),
('Georgetown', 20, 'Extra Essay'),
('UCSD', 21, 'LOR'),
('Rice', 22, 'Extra Essay'),
('UM', 23, 'Extra Essay'),
('UCSB', 24, 'Personal Statement'),
('Northeastern', 25, 'Personal Statement'),
('UW', 26, 'Personal Statement'),
('Florida', 27, 'Personal Statement'),
('UChicago', 28, 'Extra Essay'),
('UV', 29, 'LOR'),
('UI', 30, 'Personal Statement');

INSERT INTO Profile
  (p_id, FirstName, LastName, Phone, Email, Background)
VALUES
(1, 'Anne-marie', 'Wooffitt', '450-531-2423', 'anne-marie.wooffitt@gmail.com', 'Mentor'),
(2, 'Abagail', 'Zavattiero', '864-499-1931', 'abagail.zavattiero@gmail.com', 'Student'),
(3, 'Casandra', 'Silversmid', '806-674-3922', 'casandra.silversmid@gmail.com', 'Mentor'),
(4, 'Susann', 'Gillanders', '615-185-9470', 'susann.gillanders@gmail.com', 'Student'),
(5, 'Bil', 'Brayshay', '609-173-6652', 'bil.brayshay@gmail.com', 'Mentor'),
(6, 'Briny', 'OCarrol', '804-417-1627', 'briny.ocarrol@gmail.com', 'Student'),
(7, 'Egan', 'Connachan', '252-858-8962', 'egan.connachan@gmail.com', 'Student'),
(8, 'Eugenius', 'Burnand', '414-955-7164', 'eugenius.burnand@gmail.com', 'Student'),
(9, 'Reyna', 'Stollberg', '614-622-2088', 'reyna.stollberg@gmail.com', 'Mentor'),
(10, 'Fawn', 'Wyre', '554-917-0064', 'fawn.wyre@gmail.com', 'Student'),
(11, 'Barnebas', 'Ebbings', '250-486-7331', 'barnebas.ebbings@gmail.com', 'Mentor'),
(12, 'Erskine', 'Cansdell', '622-433-5019', 'erskine.cansdell@gmail.com', 'Mentor'),
(13, 'Winston', 'Penberthy', '668-992-5799', 'winston.penberthy@gmail.com', 'Mentor'),
(14, 'Kathi', 'Rampton', '258-702-2928', 'kathi.rampton@gmail.com', 'Mentor'),
(15, 'Scarface', 'Senett', '130-824-9377', 'scarface.senett@gmail.com', 'Mentor'),
(16, 'Ricoriki', 'Ramme', '917-714-8093', 'ricoriki.ramme@gmail.com', 'Student'),
(17, 'Garey', 'Bunning', '108-810-6088', 'garey.bunning@gmail.com', 'Student'),
(18, 'Kin', 'Muskett', '909-602-6273', 'kin.muskett@gmail.com', 'Student'),
(19, 'Rachael', 'Burrows', '824-318-4577', 'rachael.burrows@gmail.com', 'Student'),
(20, 'Boothe', 'Duligall', '313-333-9148', 'boothe.duligall@gmail.com', 'Mentor'),
(21, 'Sumner', 'Rapley', '234-862-2587', 'sumner.rapley@gmail.com', 'Student'),
(22, 'Darren', 'Bosche', '877-613-4885', 'darren.bosche@gmail.com', 'Student'),
(23, 'Allene', 'Heaker', '827-854-2356', 'allene.heaker@gmail.com', 'Mentor'),
(24, 'Martica', 'Rodenburg', '313-222-1457', 'martica.rodenburg@gmail.com', 'Student'),
(25, 'Lise', 'Lorain', '428-108-4829', 'lise.lorain@gmail.com', 'Student'),
(26, 'Davey', 'Filpi', '536-742-3060', 'davey.filpi@gmail.com', 'Mentor'),
(27, 'Nataniel', 'Kondratovich', '289-574-6027', 'nataniel.kondratovich@gmail.com', 'Mentor'),
(28, 'Tasha', 'Bengal', '817-917-1191', 'tasha.bengal@gmail.com', 'Student'),
(29, 'Keri', 'Cubbit', '377-160-5634', 'keri.cubbit@gmail.com', 'Mentor'),
(30, 'Ansell', 'Gorgl', '572-676-6353', 'ansell.gorgl@gmail.com', 'Student'),
(31, 'Esme', 'Leech', '791-927-7244', 'esme.leech@gmail.com', 'Mentor'),
(32, 'Britta', 'Dondon', '633-655-3121', 'britta.dondon@gmail.com', 'Student'),
(33, 'Forrester', 'Clee', '631-674-4570', 'forrester.clee@gmail.com', 'Student'),
(34, 'Roscoe', 'Gaine', '476-480-8109', 'roscoe.gaine@gmail.com', 'Student'),
(35, 'Shaw', 'Pretty', '319-387-5697', 'shaw.pretty@gmail.com', 'Student'),
(36, 'Gilbert', 'Lumbly', '659-479-8062', 'gilbert.lumbly@gmail.com', 'Student'),
(37, 'Boniface', 'Mousley', '685-811-4500', 'boniface.mousley@gmail.com', 'Student'),
(38, 'Ara', 'Sisneros', '909-947-2030', 'ara.sisneros@gmail.com', 'Student'),
(39, 'Bryan', 'Naptin', '142-193-8445', 'bryan.naptin@gmail.com', 'Student'),
(40, 'Giraldo', 'ONeill', '339-462-1054', 'giraldo.oneill@gmail.com', 'Mentor'),
(41, 'Murvyn', 'Rowthorne', '129-859-2241', 'murvyn.rowthorne@gmail.com', 'Student'),
(42, 'Bordy', 'Brunskill', '908-986-8561', 'bordy.brunskill@gmail.com', 'Student'),
(43, 'Herman', 'Westoff', '600-320-4088', 'herman.westoff@gmail.com', 'Mentor'),
(44, 'Kary', 'Woodyear', '606-221-7698', 'kary.woodyear@gmail.com', 'Student'),
(45, 'Niko', 'Lattka', '984-140-5084', 'niko.lattka@gmail.com', 'Mentor'),
(46, 'Jules', 'Sidden', '233-368-8011', 'jules.sidden@gmail.com', 'Mentor'),
(47, 'Antonino', 'Scarasbrick', '210-784-2856', 'antonino.scarasbrick@gmail.com', 'Student'),
(48, 'Bruis', 'Baiden', '638-825-2090', 'bruis.baiden@gmail.com', 'Student'),
(49, 'Cyndi', 'Beniesh', '270-995-7536', 'cyndi.beniesh@gmail.com', 'Student'),
(50, 'Wernher', 'Covington', '269-257-8489', 'wernher.covington@gmail.com', 'Student'),
(51, 'Molly', 'Gellett', '879-325-8549', 'molly.gellett@gmail.com', 'Mentor'),
(52, 'Abbye', 'Ughini', '572-573-0195', 'abbye.ughini@gmail.com', 'Mentor'),
(53, 'Krishna', 'Halford', '955-831-4897', 'krishna.halford@gmail.com', 'Student'),
(54, 'Ariella', 'Schottli', '383-548-2863', 'ariella.schottli@gmail.com', 'Mentor'),
(55, 'Cointon', 'Hillburn', '434-295-0633', 'cointon.hillburn@gmail.com', 'Student'),
(56, 'Hymie', 'Joerning', '960-662-5294', 'hymie.joerning@gmail.com', 'Mentor'),
(57, 'Chryste', 'Beelby', '684-550-1443', 'chryste.beelby@gmail.com', 'Student'),
(58, 'Fletch', 'Frie', '979-668-7470', 'fletch.frie@gmail.com', 'Student'),
(59, 'Sandra', 'Fincham', '722-611-3395', 'sandra.fincham@gmail.com', 'Mentor'),
(60, 'Desi', 'Kollatsch', '568-843-6477', 'desi.kollatsch@gmail.com', 'Student');

INSERT INTO Student
  (s_id, BirthDate, Major, Age, FirstName, LastName, Grade, College_Name, p_id)
VALUES
(1, '2002-01-10', 'Art', 24, 'Anne-marie', 'Wooffitt', 2.5, 'UI', 1),
(2, '2000-08-19', 'Art', 23, 'Abagail', 'Zavattiero', 3, 'Duke', 2),
(3, '2002-11-17', 'CS', 21, 'Casandra', 'Silversmid', 2.7, 'UW', 3),
(4, '2001-03-14', 'CS', 23, 'Susann', 'Gillanders', 3.1, 'UChicago', 4),
(5, '2000-05-09', 'Business', 21, 'Bil', 'Brayshay', 2.1, 'Vanderbilt', 5),
(6, '2001-08-18', 'Math', 23, 'Briny', 'OCarrol', 2, 'Georgetown', 6),
(7, '2001-12-04', 'CS', 20, 'Egan', 'Connachan', 3.1, 'Brown', 7),
(8, '2004-11-23', 'CS', 24, 'Eugenius', 'Burnand', 3.9, 'UV', 8),
(9, '2003-10-18', 'Art', 24, 'Reyna', 'Stollberg', 3.6, 'UCSB', 9),
(10, '2002-06-21', 'CS', 20, 'Fawn', 'Wyre', 3.1, 'Columbia', 10),
(11, '2003-08-25', 'Math', 25, 'Barnebas', 'Ebbings', 2.5, 'UPenn', 11),
(12, '2003-11-12', 'CS', 22, 'Erskine', 'Cansdell', 2, 'MIT', 12),
(13, '2005-09-09', 'Business', 25, 'Winston', 'Penberthy', 2.7, 'Duke', 13),
(14, '2005-03-16', 'Math', 22, 'Kathi', 'Rampton', 3.3, 'Princeton', 14),
(15, '2003-08-29', 'Math', 23, 'Scarface', 'Senett', 3.9, 'UCSB', 15),
(16, '2002-05-26', 'Art', 25, 'Ricoriki', 'Ramme', 2.8, 'UPenn', 16),
(17, '2005-02-17', 'CS', 21, 'Garey', 'Bunning', 2.1, 'Northwestern', 17),
(18, '2000-02-19', 'Business', 20, 'Kin', 'Muskett', 2.3, 'Georgetown', 18),
(19, '2002-06-09', 'Art', 23, 'Rachael', 'Burrows', 2.8, 'Williams', 19),
(20, '2002-06-16', 'Art', 22, 'Boothe', 'Duligall', 3.3, 'Columbia', 20),
(21, '2001-01-30', 'Math', 24, 'Sumner', 'Rapley', 2.9, 'Princeton', 21),
(22, '2001-03-28', 'CS', 20, 'Darren', 'Bosche', 2.5, 'Georgetown', 22),
(23, '2000-09-06', 'Business', 23, 'Allene', 'Heaker', 3.9, 'UW', 23),
(24, '2000-05-14', 'Art', 21, 'Martica', 'Rodenburg', 3.3, 'UC Berkeley', 24),
(25, '2003-11-21', 'CS', 22, 'Lise', 'Lorain', 2.1, 'Stanford', 25),
(26, '2005-05-23', 'Math', 21, 'Davey', 'Filpi', 3.2, 'John Hopkins', 26),
(27, '2001-11-01', 'Math', 25, 'Nataniel', 'Kondratovich', 2.4, 'UW', 27),
(28, '2002-07-27', 'CS', 24, 'Tasha', 'Bengal', 3.5, 'Georgetown', 28),
(29, '2001-06-24', 'Math', 22, 'Keri', 'Cubbit', 2, 'Williams', 29),
(30, '2002-11-25', 'Math', 22, 'Ansell', 'Gorgl', 2.3, 'UI', 30);

INSERT INTO Network
    (s_id, connection)
VALUES
(1, 7),
(2, 13),
(3, 16),
(4, 25),
(5, 5),
(6, 12),
(7, 20),
(8, 14),
(9, 15),
(10, 23),
(11, 11),
(12, 13),
(13, 20),
(14, 15),
(15, 20),
(16, 10),
(17, 4),
(18, 2),
(19, 5),
(20, 9),
(21, 7),
(22, 12),
(23, 23),
(24, 20),
(25, 8),
(26, 22),
(27, 14),
(28, 18),
(29, 15),
(30, 6),
(1, 26),
(2, 17),
(3, 25),
(4, 24),
(5, 10),
(6, 10),
(7, 8),
(8, 24),
(9, 29),
(10, 11),
(11, 28),
(12, 2),
(13, 28),
(14, 16),
(15, 21),
(16, 13),
(17, 3),
(18, 24),
(19, 9),
(20, 25),
(21, 20),
(22, 26),
(23, 11),
(24, 10),
(25, 5),
(26, 1),
(27, 26),
(28, 30),
(29, 12),
(30, 15),
(1, 20),
(2, 29),
(3, 6),
(4, 14),
(5, 17),
(6, 5),
(7, 9),
(8, 28),
(9, 1),
(10, 21),
(11, 15),
(12, 11),
(13, 24),
(14, 1),
(15, 4),
(16, 21),
(17, 22),
(18, 15),
(19, 20),
(20, 10),
(21, 15),
(22, 19),
(23, 8),
(24, 8),
(25, 14),
(26, 7),
(27, 15),
(28, 19),
(29, 28),
(30, 11),
(1, 4),
(2, 19),
(3, 12),
(4, 6),
(5, 7),
(6, 21),
(7, 1),
(8, 8),
(9, 4),
(10, 4),
(11, 7),
(12, 15),
(13, 23),
(14, 18),
(15, 22),
(16, 25),
(17, 12),
(18, 3),
(19, 21),
(20, 6),
(21, 3),
(22, 18),
(23, 15),
(24, 4),
(25, 25),
(26, 23),
(27, 8),
(28, 15),
(29, 24),
(30, 2),
(1, 27),
(2, 25),
(3, 21),
(4, 23),
(5, 8),
(6, 6),
(7, 29),
(8, 27),
(9, 22),
(10, 8),
(11, 26),
(12, 21),
(13, 9),
(14, 4),
(15, 8),
(16, 1),
(17, 11),
(18, 26),
(19, 7),
(20, 22),
(21, 23),
(22, 28),
(23, 25),
(24, 9),
(25, 7),
(26, 20),
(27, 16),
(28, 23),
(29, 10),
(30, 24),
(1, 14),
(2, 26),
(3, 24),
(4, 22),
(5, 25),
(6, 29),
(7, 27),
(8, 2),
(9, 17),
(10, 3),
(11, 24),
(12, 26),
(13, 18),
(14, 14),
(15, 12),
(16, 9),
(17, 23),
(18, 6),
(19, 6),
(20, 4),
(21, 2),
(22, 15),
(23, 24),
(24, 5),
(25, 3),
(26, 14),
(27, 9),
(28, 6),
(29, 2),
(30, 25),
(1, 23),
(2, 21),
(3, 22),
(4, 16),
(5, 27),
(6, 15),
(7, 22),
(8, 9),
(9, 16),
(10, 10),
(11, 14),
(12, 6),
(13, 29),
(14, 17),
(15, 15),
(16, 3),
(17, 25),
(18, 19),
(19, 8),
(20, 27);

INSERT INTO Interview_Resource
    (Title, Content, Format)
VALUES
('Dress Up', 'Technical', 'Bullets'),
('Show Up On Time', 'Technical', 'Bullets'),
('Ask Questions', 'Technical', 'Page'),
('Smile', 'Behavioral', 'List'),
('Leetcode', 'Behavioral', 'Bullets'),
('Actively Listen', 'Technical', 'Page');

INSERT INTO Soft_Skill_Resource
    (Title, Content, Format)
VALUES
('Communication', 'What to do', 'Page'),
('Teamwork', 'When to do', 'Page'),
('Creativity', 'Why to do', 'Bullets');

INSERT INTO Work
    (CompanyName, Industry)
VALUES
    ('Smith LLC', 'Major Banks'),
('Rempel-Harber', 'n/a'),
('Keebler, Klein and Kirlin', 'Major Banks'),
('Carroll-Bayer', 'Department/Specialty Retail Stores'),
('Bartell, Macejkovic and McDermott', 'Recreational Products/Toys'),
('Carter-Goodwin', 'Oil & Gas Production'),
('Lockman-Fahey', 'n/a'),
('Sawayn Group', 'Major Banks'),
('Schamberger, Zulauf and Runte', 'Oil & Gas Production'),
('Simonis, Greenfelder and Auer', 'Major Banks'),
('Keeling Group', 'Aluminum'),
('Krajcik, Stokes and Schinner', 'Electrical Products'),
('Weissnat-Kerluke', 'Property-Casualty Insurers'),
('Bernier-Purdy', 'Restaurants'),
('Ziemann LLC', 'Life Insurance'),
('Mante, Rohan and Grant', 'Computer Software: Prepackaged Software'),
('Herzog-Okuneva', 'Hotels/Resorts'),
('Hoppe Inc', 'Major Banks'),
('Stehr-Bartell', 'Major Banks'),
('DAmore, Aufderhar and Aufderhar', 'Medical/Dental Instruments'),
('Hansen Inc', 'Movies/Entertainment'),
('Simonis LLC', 'Electric Utilities: Central'),
('Heaney-Langosh', 'Farming/Seeds/Milling'),
('Keeling Inc', 'Auto Parts:O.E.M.'),
('Hilpert-Schultz', 'Radio And Television Broadcasting And Communications Equipment'),
('Nienow Group', 'Major Pharmaceuticals'),
('Tromp-Kirlin', 'Biotechnology: Biological Products (No Diagnostic Substances)'),
('Marks LLC', 'n/a'),
('Marks and Sons', 'Computer Software: Prepackaged Software'),
('Von, Glover and Paucek', 'Biotechnology: Commercial Physical & Biological Resarch');

INSERT INTO Mentor
  (m_id, BirthDate, Age, FirstName, LastName, Specialization, p_id)
VALUES
(1, '1987-01-01', 36, 'Esme', 'Leech', 'Law', 31),
(2, '1985-02-02', 44, 'Britta', 'Dondon', 'Recruiter', 32),
(3, '1990-03-03', 31, 'Forrester', 'Clee', 'Business', 33),
(4, '1987-04-04', 30, 'Roscoe', 'Gaine', 'Art', 34),
(5, '1985-05-05', 26, 'Shaw', 'Pretty', 'Recruiter', 35),
(6, '1992-06-06', 37, 'Gilbert', 'Lumbly', 'Recruiter', 36),
(7, '1983-07-07', 39, 'Boniface', 'Mousley', 'Art', 37),
(8, '1987-08-08', 30, 'Ara', 'Sisneros', 'Recruiter', 38),
(9, '1990-09-09', 26, 'Bryan', 'Naptin', 'Recruiter', 39),
(10, '1989-10-10', 35, 'Giraldo', 'ONeill', 'Medical', 40),
(11, '1987-11-11', 30, 'Murvyn', 'Rowthorne', 'Art', 41),
(12, '1983-12-12', 37, 'Bordy', 'Brunskill', 'Recruiter', 42),
(13, '1985-01-13', 42, 'Herman', 'Westoff', 'Business', 43),
(14, '1987-02-14', 28, 'Kary', 'Woodyear', 'Recruiter', 44),
(15, '1992-03-15', 42, 'Niko', 'Lattka', 'Business', 45),
(16, '1983-04-16', 42, 'Jules', 'Sidden', 'CS', 46),
(17, '1987-05-17', 37, 'Antonino', 'Scarasbrick', 'CS', 47),
(18, '1992-06-18', 43, 'Bruis', 'Baiden', 'Recruiter', 48),
(19, '1990-07-19', 43, 'Cyndi', 'Beniesh', 'CS', 49),
(20, '1987-08-20', 29, 'Wernher', 'Covington', 'Business', 50),
(21, '1983-09-21', 42, 'Molly', 'Gellett', 'Business', 51),
(22, '1987-10-22', 30, 'Abbye', 'Ughini', 'Law', 52),
(23, '1985-11-23', 34, 'Krishna', 'Halford', 'Medical', 53),
(24, '1987-12-24', 35, 'Ariella', 'Schottli', 'Art', 54),
(25, '1983-01-25', 41, 'Cointon', 'Hillburn', 'Medical', 55),
(26, '1990-02-26', 28, 'Hymie', 'Joerning', 'Law', 56),
(27, '1989-03-27', 34, 'Chryste', 'Beelby', 'CS', 57),
(28, '1987-04-28', 40, 'Fletch', 'Frie', 'Business', 58),
(29, '1992-05-29', 44, 'Sandra', 'Fincham', 'CS', 59),
(30, '1985-06-30', 45, 'Desi', 'Kollatsch', 'CS', 60);

INSERT INTO Lab
  (Lab_Name, LabType, College_Name)
VALUES
('Palia lab', 'Physics', 'Columbia'),
('Coulman lab', 'Microbiology', 'Duke'),
('Veeler lab', 'Biology', 'Dartmouth'),
('Binny lab', 'Physics', 'Vanderbilt'),
('Kingman lab', 'Microbiology', 'UC Berkeley'),
('Crosham lab', 'Microbiology', 'Columbia'),
('Bosch lab', 'Biology', 'Stanford'),
('Assinder lab', 'Genetics', 'Vanderbilt'),
('Bellin lab', 'Biology', 'UV'),
('Heinemann lab', 'Physics', 'Cornell'),
('Gooder lab', 'Chemistry', 'UCLA'),
('McCrostie lab', 'Biology', 'UM'),
('Dinse lab', 'Genetics', 'UM'),
('Kosel lab', 'Genetics', 'UChicago'),
('Mallion lab', 'Genetics', 'Columbia'),
('Brumwell lab', 'Biology', 'UV'),
('Picopp lab', 'Physics', 'UM'),
('Fannon lab', 'Physics', 'Yale'),
('Everit lab', 'Microbiology', 'Brown'),
('Windless lab', 'Genetics', 'UCSB'),
('Ibbison lab', 'Microbiology', 'UI'),
('Stenbridge lab', 'Biology', 'Columbia'),
('Atwell lab', 'Microbiology', 'Georgetown'),
('Cuskery lab', 'Chemistry', 'UC Berkeley'),
('Middlemass lab', 'Microbiology', 'UI'),
('Silkstone lab', 'Genetics', 'Harvard'),
('Mathouse lab', 'Biology', 'Williams'),
('Ottee lab', 'Microbiology', 'Amherst'),
('Sakins lab', 'Chemistry', 'Princeton'),
('Potts lab', 'Biology', 'Amherst'),
('Pain lab', 'Biology', 'Florida'),
('Webley lab', 'Biology', 'Princeton'),
('Revel lab', 'Chemistry', 'UW'),
('Faustian lab', 'Chemistry', 'Harvard'),
('Burnel lab', 'Biology', 'Dartmouth'),
('Dod lab', 'Chemistry', 'UI'),
('Carriage lab', 'Chemistry', 'UCSD'),
('Kleis lab', 'Biology', 'Duke'),
('Bougourd lab', 'Microbiology', 'Brown'),
('Tolcharde lab', 'Genetics', 'UCSB'),
('Duester lab', 'Biology', 'Brown'),
('Jeschner lab', 'Microbiology', 'UC Berkeley'),
('China lab', 'Chemistry', 'UCSB'),
('Saker lab', 'Biology', 'USC'),
('McCandie lab', 'Chemistry', 'Princeton'),
('Vost lab', 'Genetics', 'Rice'),
('Cathro lab', 'Physics', 'Florida'),
('Hazeley lab', 'Microbiology', 'Brown'),
('Aindrais lab', 'Chemistry', 'USC'),
('Gianolini lab', 'Microbiology', 'UM'),
('Buncher lab', 'Microbiology', 'UC Berkeley'),
('Sappy lab', 'Physics', 'Cornell'),
('Caro lab', 'Physics', 'Princeton'),
('Nelmes lab', 'Genetics', 'MIT'),
('MacLure lab', 'Biology', 'UM'),
('Seywood lab', 'Microbiology', 'Dartmouth'),
('Purdon lab', 'Microbiology', 'UCLA'),
('Keilty lab', 'Physics', 'UW'),
('Searchwell lab', 'Biology', 'Harvard'),
('Rushmare lab', 'Physics', 'Duke'),
('Weson lab', 'Genetics', 'Rice'),
('Manjin lab', 'Physics', 'Florida'),
('Dossantos lab', 'Chemistry', 'MIT'),
('Oughtright lab', 'Physics', 'Florida'),
('Drinkhill lab', 'Physics', 'Williams'),
('Dupree lab', 'Biology', 'UV'),
('Bartholomieu lab', 'Physics', 'UChicago'),
('Holbury lab', 'Microbiology', 'Rice'),
('Beebis lab', 'Biology', 'Northwestern'),
('Fontenot lab', 'Physics', 'UCLA'),
('Hantusch lab', 'Chemistry', 'UC Berkeley'),
('Laxtonne lab', 'Chemistry', 'UM'),
('de Marco lab', 'Biology', 'Georgetown'),
('Maplestone lab', 'Biology', 'Vanderbilt'),
('Easseby lab', 'Biology', 'Duke'),
('Cadle lab', 'Microbiology', 'Stanford'),
('Tarpey lab', 'Biology', 'USC'),
('Gatcliff lab', 'Physics', 'UCSB'),
('Going lab', 'Biology', 'Cornell'),
('Boundley lab', 'Microbiology', 'Princeton');

INSERT INTO Schedule
  (schedule_id, EventType, StartTime, EndTime, Background, m_id)
VALUES
(1, 'Call', now(), DATE_ADD(now(), INTERVAL 2 HOUR), 'Group', 1),
(2, 'Work', now(), DATE_ADD(now(), INTERVAL 2 HOUR), 'Informative', 2),
(3, 'Private', now(), DATE_ADD(now(), INTERVAL 2 HOUR), 'One on One', 3),
(4, 'Break', now(), DATE_ADD(now(), INTERVAL 2 HOUR), 'One on One', 4),
(5, 'Meeting', now(), DATE_ADD(now(), INTERVAL 2 HOUR), 'One on One', 5),
(6, 'Break', now(), DATE_ADD(now(), INTERVAL 2 HOUR), 'Group', 6),
(7, 'Call', now(), DATE_ADD(now(), INTERVAL 2 HOUR), 'Group', 7),
(8, 'Call', now(), DATE_ADD(now(), INTERVAL 2 HOUR), 'One on One', 8),
(9, 'Meeting', now(), DATE_ADD(now(), INTERVAL 2 HOUR), 'Group', 9),
(10, 'Break', now(), DATE_ADD(now(), INTERVAL 2 HOUR), 'Informative', 10),
(11, 'Private', now(), DATE_ADD(now(), INTERVAL 2 HOUR), 'Informative', 1),
(12, 'Meeting', now(), DATE_ADD(now(), INTERVAL 2 HOUR), 'Informative', 2),
(13, 'Meeting', now(), DATE_ADD(now(), INTERVAL 2 HOUR), 'One on One', 3),
(14, 'Work', now(), DATE_ADD(now(), INTERVAL 2 HOUR), 'One on One', 4),
(15, 'Call', now(), DATE_ADD(now(), INTERVAL 2 HOUR), 'Group', 5),
(16, 'Meeting', now(), DATE_ADD(now(), INTERVAL 2 HOUR), 'One on One', 6),
(17, 'Work', now(), DATE_ADD(now(), INTERVAL 2 HOUR), 'One on One', 7),
(18, 'Work', now(), DATE_ADD(now(), INTERVAL 2 HOUR), 'Informative', 8),
(19, 'Meeting', now(), DATE_ADD(now(), INTERVAL 2 HOUR), 'One on One', 9),
(20, 'Private', now(), DATE_ADD(now(), INTERVAL 2 HOUR), 'One on One', 10),
(21, 'Private', now(), DATE_ADD(now(), INTERVAL 2 HOUR), 'One on One', 1),
(22, 'Meeting', now(), DATE_ADD(now(), INTERVAL 2 HOUR), 'Informative', 2),
(23, 'Private', now(), DATE_ADD(now(), INTERVAL 2 HOUR), 'One on One', 3),
(24, 'Private', now(), DATE_ADD(now(), INTERVAL 2 HOUR), 'One on One', 4),
(25, 'Work', now(), DATE_ADD(now(), INTERVAL 2 HOUR), 'Group', 5),
(26, 'Private', now(), DATE_ADD(now(), INTERVAL 2 HOUR), 'One on One', 6),
(27, 'Call', now(), DATE_ADD(now(), INTERVAL 2 HOUR), 'One on One', 7),
(28, 'Work', now(), DATE_ADD(now(), INTERVAL 2 HOUR), 'One on One', 8),
(29, 'Private', now(), DATE_ADD(now(), INTERVAL 2 HOUR), 'One on One', 9),
(30, 'Break', now(), DATE_ADD(now(), INTERVAL 2 HOUR), 'Informative', 10);

INSERT INTO Mentoring_Resource
    (Title, Content, Format)
VALUES
    ('Prior Experiences', 'I would...', 'Bullets'),
('Communication', 'I would...', 'List'),
('Advice', 'I would...', 'List'),
('Relatability', 'I use to...', 'Page');

INSERT INTO Professional_Page
    (p_id, Phone, Email, m_id)
VALUES
(1, '389-520-6158', 'gmckitterick0@cdc.gov',1),
(2, '103-974-6844', 'agronav1@lulu.com',2),
(3, '952-136-7733', 'wockleshaw2@cloudflare.com',3),
(4, '762-431-4708', 'hbarks3@tmall.com',4),
(5, '602-255-1483', 'dbleacher4@wikispaces.com',5),
(6, '781-659-5977', 'avanyakin5@so-net.ne.jp',6),
(7, '549-229-6662', 'spickerin6@nyu.edu',7),
(8, '406-122-5634', 'ffoxcroft7@geocities.jp',8),
(9, '304-795-6971', 'hmacpadene8@theglobeandmail.com',9),
(10, '304-585-4546', 'jtrownson9@weather.com',10),
(11, '389-773-4294', 'glowdera@addtoany.com',1),
(12, '563-373-8086', 'btilbyb@wired.com',2),
(13, '805-211-4137', 'ldetoilec@smugmug.com',3),
(14, '579-134-7811', 'fditchburnd@creativecommons.org',4),
(15, '785-207-7973', 'jwitule@delicious.com',5),
(16, '836-329-6890', 'pmarvalf@shutterfly.com',6),
(17, '270-546-6360', 'bcoetzeeg@over-blog.com',7),
(18, '782-893-4363', 'pcrosgroveh@mail.ru',8),
(19, '979-980-5727', 'gcroisieri@cafepress.com',9),
(20, '572-733-2946', 'ddopsonj@yelp.com',10),
(21, '142-757-6736', 'jwottonk@spotify.com',1),
(22, '771-670-6088', 'cconwsl@wisc.edu',2),
(23, '492-427-6538', 'rmelbournem@about.me',3),
(24, '140-235-6450', 'oshreevesn@sogou.com',4),
(25, '577-148-5282', 'wmoubrayo@noaa.gov',5),
(26, '660-484-9808', 'ssalsburyp@princeton.edu',6),
(27, '298-131-0131', 'lpeabodyq@zimbio.com',7),
(28, '373-634-1659', 'groddyr@behance.net',8),
(29, '904-402-9775', 'scasales@apple.com',9),
(30, '697-589-7237', 'garnoppt@pbs.org',10);

INSERT INTO Interacts_With
    (s_id, m_id)
VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(1, 7),
(1, 8),
(1, 9),
(1, 10),
(2, 1),
(2, 2),
(2, 3),
(2, 4),
(2, 5),
(2, 6),
(2, 7),
(2, 8),
(2, 9),
(2, 10),
(3, 1),
(3, 2),
(3, 3),
(3, 4),
(3, 5),
(3, 6),
(3, 7),
(3, 8),
(3, 9),
(3, 10),
(4, 1),
(4, 2),
(4, 3),
(4, 4),
(4, 5),
(4, 6),
(4, 7),
(4, 8),
(4, 9),
(4, 10),
(5, 1),
(5, 2),
(5, 3),
(5, 4),
(5, 5),
(5, 6),
(5, 7),
(5, 8),
(5, 9),
(5, 10),
(6, 1),
(6, 2),
(6, 3),
(6, 4),
(6, 5),
(6, 6),
(6, 7),
(6, 8),
(6, 9),
(6, 10),
(7, 1),
(7, 2),
(7, 3),
(7, 4),
(7, 5),
(7, 6),
(7, 7),
(7, 8),
(7, 9),
(7, 10),
(8, 1),
(8, 2),
(8, 3),
(8, 4),
(8, 5),
(8, 6),
(8, 7),
(8, 8),
(8, 9),
(8, 10),
(9, 1),
(9, 2),
(9, 3),
(9, 4),
(9, 5),
(9, 6),
(9, 7),
(9, 8),
(9, 9),
(9, 10),
(10, 1),
(10, 2),
(10, 3),
(10, 4),
(10, 5),
(10, 6),
(10, 7),
(10, 8),
(10, 9),
(10, 10),
(11, 1),
(11, 2),
(11, 3),
(11, 4),
(11, 5),
(11, 6),
(11, 7),
(11, 8),
(11, 9),
(11, 10),
(12, 1),
(12, 2),
(12, 3),
(12, 4),
(12, 5),
(12, 6),
(12, 7),
(12, 8),
(12, 9),
(12, 10),
(13, 1),
(13, 2),
(13, 3),
(13, 4),
(13, 5),
(13, 6),
(13, 7),
(13, 8),
(13, 9),
(13, 10),
(14, 1),
(14, 2),
(14, 3),
(14, 4),
(14, 5),
(14, 6),
(14, 7),
(14, 8),
(14, 9),
(14, 10),
(15, 1),
(15, 2),
(15, 3),
(15, 4),
(15, 5),
(15, 6),
(15, 7),
(15, 8),
(15, 9),
(15, 10),
(16, 1),
(16, 2),
(16, 3),
(16, 4),
(16, 5),
(16, 6),
(16, 7),
(16, 8),
(16, 9),
(16, 10),
(17, 1),
(17, 2),
(17, 3),
(17, 4),
(17, 5),
(17, 6),
(17, 7),
(17, 8),
(17, 9),
(17, 10),
(18, 1),
(18, 2),
(18, 3),
(18, 4),
(18, 5),
(18, 6),
(18, 7),
(18, 8),
(18, 9),
(18, 10),
(19, 1),
(19, 2),
(19, 3),
(19, 4),
(19, 5),
(19, 6),
(19, 7),
(19, 8),
(19, 9),
(19, 10),
(20, 1),
(20, 2),
(20, 3),
(20, 4),
(20, 5),
(20, 6),
(20, 7),
(20, 8),
(20, 9),
(20, 10);

-- INSERT INTO Access_SSR
--     (s_id, Access_SSR.Title)
-- VALUES
-- (1, 'Communication'),
-- (1, 'Teamwork'),
-- (1, 'Creativity'),
-- (2, 'Communication'),
-- (2, 'Teamwork'),
-- (2, 'Creativity'),
-- (3, 'Communication'),
-- (3, 'Teamwork'),
-- (3, 'Creativity'),
-- (4, 'Communication'),
-- (4, 'Teamwork'),
-- (4, 'Creativity'),
-- (5, 'Communication'),
-- (5, 'Teamwork'),
-- (5, 'Creativity'),
-- (6, 'Communication'),
-- (6, 'Teamwork'),
-- (6, 'Creativity'),
-- (7, 'Communication'),
-- (7, 'Teamwork'),
-- (7, 'Creativity'),
-- (8, 'Communication'),
-- (8, 'Teamwork'),
-- (8, 'Creativity'),
-- (9, 'Communication'),
-- (9, 'Teamwork'),
-- (9, 'Creativity'),
-- (10, 'Communication'),
-- (10, 'Teamwork'),
-- (10, 'Creativity'),
-- (11, 'Communication'),
-- (11, 'Teamwork'),
-- (11, 'Creativity'),
-- (12, 'Communication'),
-- (12, 'Teamwork'),
-- (12, 'Creativity'),
-- (13, 'Communication'),
-- (13, 'Teamwork'),
-- (13, 'Creativity'),
-- (14, 'Communication'),
-- (14, 'Teamwork'),
-- (14, 'Creativity'),
-- (15, 'Communication'),
-- (15, 'Teamwork'),
-- (15, 'Creativity'),
-- (16, 'Communication'),
-- (16, 'Teamwork'),
-- (16, 'Creativity'),
-- (17, 'Communication'),
-- (17, 'Teamwork'),
-- (17, 'Creativity'),
-- (18, 'Communication'),
-- (18, 'Teamwork'),
-- (18, 'Creativity'),
-- (19, 'Communication'),
-- (19, 'Teamwork'),
-- (19, 'Creativity'),
-- (20, 'Communication'),
-- (20, 'Teamwork'),
-- (20, 'Creativity'),
-- (21, 'Communication'),
-- (21, 'Teamwork'),
-- (21, 'Creativity'),
-- (22, 'Communication'),
-- (22, 'Teamwork'),
-- (22, 'Creativity'),
-- (23, 'Communication'),
-- (23, 'Teamwork'),
-- (23, 'Creativity'),
-- (24, 'Communication'),
-- (24, 'Teamwork'),
-- (24, 'Creativity'),
-- (25, 'Communication'),
-- (25, 'Teamwork'),
-- (25, 'Creativity'),
-- (26, 'Communication'),
-- (26, 'Teamwork'),
-- (26, 'Creativity'),
-- (27, 'Communication'),
-- (27, 'Teamwork'),
-- (27, 'Creativity'),
-- (28, 'Communication'),
-- (28, 'Teamwork'),
-- (28, 'Creativity'),
-- (29, 'Communication'),
-- (29, 'Teamwork'),
-- (29, 'Creativity'),
-- (30, 'Communication'),
-- (30, 'Teamwork'),
-- (30, 'Creativity');

INSERT INTO Access_IR
    (s_id, Access_IR.Title)
VALUES
    (1, 'Technical'),
    (2, 'behavioral');

-- INSERT INTO Is_Looking_For
--     (s_id, CompanyName)
-- VALUES
--     (1, 'Google'),
--     (2, 'Meta');

INSERT INTO Work_Address
    (CompanyName, Street, City, US_State, Zip)
VALUES
    ('Google', 'street1', 'city1', 'maine', '33242'),
    ('Meta', 'street2', 'city2', 'vermont', '34231');

-- INSERT INTO College_Address
--     (College_Name, Street, City, US_State, Zip)
-- VALUES
--     ('Northeastern', 'street1', 'city1', 'maine', '33242'),
--     ('BU', 'street2', 'city2', 'vermont', '34231');

-- INSERT INTO Works_At
--     (m_id, CompanyName)
-- VALUES
--     (1, 'Google'),
--     (2, 'Meta');

-- INSERT INTO Associated_With
--     (m_id, College_Name)
-- VALUES
--     (1, 'Northeastern'),
--     (2, 'BU');

-- INSERT INTO Access_MR
--     (m_id, Title)
-- VALUES
--     (1, 'help'),
--     (2, 'general');

-- INSERT INTO Accreditations
--     (p_id, Accred_Type)
-- VALUES
--     (1, 'doctorate'),
--     (2, 'phd');
