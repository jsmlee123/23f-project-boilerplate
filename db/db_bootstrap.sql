-- This file is to bootstrap a database for the CS3200 project. 

-- Create a new database.  You can change the name later.  You'll
-- need this name in the FLASK API file(s),  the AppSmith 
-- data source creation.
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
  Title VARCHAR(40) UNIQUE NOT NULL,
  Content VARCHAR(40),
  Format VARCHAR(40),
  PRIMARY KEY (Title)
);

CREATE TABLE Interview_Resource (
  Title VARCHAR(40) UNIQUE NOT NULL,
  Content VARCHAR(40),
  Format VARCHAR(40),
  PRIMARY KEY (Title)
);

CREATE TABLE Work (
  CompanyName VARCHAR(40) UNIQUE NOT NULL,
  Industry VARCHAR(40),
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
  Lab_Name VARCHAR(40) UNIQUE NOT NULL,
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
  Title VARCHAR(40) UNIQUE NOT NULL,
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
  ('Northeastern', '1', 'essay'),
  ('BU', '2', 'essay'),
  ('Harvard', '3', 'essay');

INSERT INTO Profile
  (FirstName, LastName, Phone, Email, Background)
VALUES
  ('John', 'Doe', 2343235434, 'hi@gmail.com', 'history'),
  ('Jane', 'Austin', 3492347492, 'hello@gmail.com', 'cs'),
  ('Joe', 'Watt', 3804234343, 'bye@gmail.com', 'chemistry');

INSERT INTO Student
  (BirthDate, Major, Age, FirstName, LastName, Grade, College_Name, p_id)
VALUES
  (now(), 'CS', 15, 'John', 'Doe', 1, 'Northeastern', 1),
  (now(), 'CS', 10, 'Jane', 'Austin', 2, 'BU', 2),
  (now(), 'CS', 20, 'Stella', 'Smith', 3, 'Harvard', 3);

INSERT INTO Network
    (s_id, connection)
VALUES
    (1, 2),
    (2, 1);

INSERT INTO Soft_Skill_Resource
    (Title, Content, Format)
VALUES
    ('Labs', 'chemistry', 'hands-on'),
    ('coding', 'cs', 'online');

INSERT INTO Interview_Resource
    (Title, Content, Format)
VALUES
    ('Technical', 'algo', 'online'),
    ('behavioral', 'any', 'zoom');

INSERT INTO Work
    (CompanyName, Industry)
VALUES
    ('Google', 'tech'),
    ('Meta', 'network');

INSERT INTO Mentor
  (BirthDate, Age, FirstName, LastName, Specialization, p_id)
VALUES
  (now(), 15, 'James', 'Donald', 'CS', 1),
  (now(), 10, 'Joe', 'Watt', 'Chemistry', 2);

INSERT INTO Lab
  (Lab_Name, LabType, College_Name)
VALUES
  ('Smith', 'chemistry', 'Northeastern'),
  ('Doe', 'cs', 'BU');

INSERT INTO Schedule
  (eventtype, background, m_id)
VALUES
  ('OH', 'regular', 1),
  ('advisor', 'short', 2);

INSERT INTO Mentoring_Resource
    (Title, Content, Format)
VALUES
    ('help', 'algo', 'online'),
    ('general', 'any', 'zoom');

INSERT INTO Professional_Page
    (Phone, Email, m_id)
VALUES
    (3403428593, 'hi@gmai.com', 1),
    ('3480247241', 'hello@gmail.com', 2);

INSERT INTO Interacts_With
    (s_id, m_id)
VALUES
    (1, 2),
    (2, 1);

INSERT INTO Access_SSR
    (s_id, Access_SSR.Title)
VALUES
    (1, 'Labs'),
    (2, 'coding');

INSERT INTO Access_IR
    (s_id, Access_IR.Title)
VALUES
    (1, 'Technical'),
    (2, 'behavioral');

INSERT INTO Is_Looking_For
    (s_id, CompanyName)
VALUES
    (1, 'Google'),
    (2, 'Meta');

INSERT INTO Work_Address
    (CompanyName, Street, City, US_State, Zip)
VALUES
    ('Google', 'street1', 'city1', 'maine', '33242'),
    ('Meta', 'street2', 'city2', 'vermont', '34231');

INSERT INTO College_Address
    (College_Name, Street, City, US_State, Zip)
VALUES
    ('Northeastern', 'street1', 'city1', 'maine', '33242'),
    ('BU', 'street2', 'city2', 'vermont', '34231');

INSERT INTO Works_At
    (m_id, CompanyName)
VALUES
    (1, 'Google'),
    (2, 'Meta');

INSERT INTO Associated_With
    (m_id, College_Name)
VALUES
    (1, 'Northeastern'),
    (2, 'BU');

INSERT INTO Access_MR
    (m_id, Title)
VALUES
    (1, 'help'),
    (2, 'general');

INSERT INTO Accreditations
    (p_id, Accred_Type)
VALUES
    (1, 'doctorate'),
    (2, 'phd');
