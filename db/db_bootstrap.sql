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
CREATE TABLE Student (
  s_id int NOT NULL AUTO_INCREMENT,
  BirthDate date NOT NULL,
  Major VARCHAR(40),
  Age int,
  FirstName VARCHAR(40),
  LastName VARCHAR(40),
  Grade int,
  College_Name VARCHAR(40) NOT NULL,
  PRIMARY KEY (s_id),
  FOREIGN KEY (College_Name)
    REFERENCES College (College_Name)
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
  PRIMARY KEY (m_id)
);

CREATE TABLE Profile (
  FirstName VARCHAR(40),
  LastName VARCHAR(40),
  Phone VARCHAR(22),
  Email VARCHAR(40),
  Background VARCHAR(40),
  m_id int NOT NULL,
  s_id int NOT NULL,
  FOREIGN KEY (m_id)
    REFERENCES Mentor (m_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (s_id)
    REFERENCES Student (s_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE College (
  College_Name VARCHAR(40) UNIQUE NOT NULL,
  Ranking int,
  AppReqs VARCHAR(40),
  PRIMARY KEY (College_Name)
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
  College_Name int NOT NULL,
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
INSERT INTO Soft_Skill_Resource
  (Title, Content, Format)
VALUES
  ('dev', 'blue', 'hi'),
  ('pro', 'yellow', 'hello'),
  ('junior', 'red', 'bye');
