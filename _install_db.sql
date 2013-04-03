
CREATE TABLE :Player
(
   player_id SMALLINT NOT NULL AUTO_INCREMENT,
   
   pdga varchar(10),
   pdga_rating INT NOT NULL DEFAULT 0,
   pdga_previous_rating INT NOT NULL DEFAULT 0,
   pdga_status ENUM('amateur','professional') DEFAULT 'amateur',
   
   sex ENUM('male', 'female'),
   lastname VARCHAR(100),
   firstname VARCHAR(100),
   birthdate DATE,
   email VARCHAR(150),
   club_id int(11),
   PRIMARY KEY(player_id),
   INDEX(pdga)
);
SHOW WARNINGS;

CREATE TABLE :User
(
   id INT NOT  NULL AUTO_INCREMENT,
   Username VARCHAR(40),
   UserEmail VARCHAR(100),
   Password VARCHAR(40),
   Role VARCHAR(10) NOT NULL,
   UserFirstName VARCHAR(40) NOT NULL,
   UserLastName VARCHAR(40) NOT NULL,
   Player SMALLINT NULL,   
   PRIMARY KEY(id),
   FOREIGN KEY (Player) REFERENCES :Player(player_id),
   UNIQUE(Username),
   INDEX (Username, Password)
);
SHOW WARNINGS;

CREATE TABLE :Venue
(
   id INT NOT NULL AUTO_INCREMENT,
   Name VARCHAR(40) NOT NULL,
   PRIMARY KEY(id)
);
SHOW WARNINGS;

CREATE TABLE :Level
(
   id INT NOT NULL AUTO_INCREMENT,
   Name VARCHAR(40) NOT NULL,
   ScoreCalculationMethod VARCHAR(40) NOT NULL,
   Available TINYINT NOT NULL,
   PRIMARY KEY(id),
   INDEX(Available)
);
SHOW WARNINGS;

CREATE TABLE :Tournament
(
   id INT NOT NULL AUTO_INCREMENT,
   Level INT NOT NULL,
   Name VARCHAR(40) NOT NULL,
   Year INT NOT NULL,
   Description TEXT NOT NULL,
   ScoreCalculationMethod VARCHAR(40) NOT NULL,
   Available TINYINT NOT NULL,
   PRIMARY KEY(id),
   FOREIGN KEY (Level) REFERENCES :Level(id),
   INDEX(Year),
   INDEX(Available)
);
SHOW WARNINGS;

CREATE TABLE :File
(
   id INT NOT NULL AUTO_INCREMENT,
   Filename VARCHAR(60) NOT NULL,
   Type VARCHAR(10) NOT NULL,
   DisplayName VARCHAR(60) NOT NULL,
   PRIMARY KEY(id)
);
SHOW WARNINGS;

CREATE TABLE IF NOT EXISTS `:AdBanner` (
  `id` int(11) NOT NULL auto_increment,
  `URL` varchar(200) NULL,
  `ImageURL` varchar(200)  NULL,
  `LongData` text,
  `ImageReference` int(11) default NULL,
  `Type` varchar(20) NOT NULL,
  `Event` int(11) default NULL,
  `ContentId` varchar(30)  NOT NULL,
  FOREIGN KEY (`ImageReference`) REFERENCES :File(id),
  PRIMARY KEY  (`id`)
);
SHOW WARNINGS;

CREATE TABLE :Event
(
   id INT NOT NULL AUTO_INCREMENT,
   Venue INT,
   Tournament INT,
   Level INT,   
   Name VARCHAR(80) NOT NULL,
   Date DATETIME NOT NULL,
   Duration TINYINT NOT NULL,
   ActivationDate DATETIME,
   SignupStart DATETIME,
   SignupEnd DATETIME,
   ResultsLocked DATETIME NULL,
   ContactInfo VARCHAR(250) NOT NULL,
   FeesRequired TINYINT NOT NULL,
   AdBanner INT NULL,
   PlayerLimit int(11),
   state enum('private','public') default 'private',
   PRIMARY KEY(id),
   FOREIGN KEY (Venue) REFERENCES :Venue(id),
   FOREIGN KEY (Tournament) REFERENCES :Tournament(id),
   FOREIGN KEY (Level) REFERENCES :Level(id)   
);
SHOW WARNINGS;

CREATE TABLE :EventManagement
(
   id INT NOT NULL AUTO_INCREMENT,
   User INT NOT NULL,
   Event INT NOT NULL,
   Role VARCHAR(10) NOT NULL,
   PRIMARY KEY(id),
   FOREIGN KEY (User) REFERENCES :User(id),
   FOREIGN KEY (Event) REFERENCES :Event(id),
   INDEX (User, Event, Role)
);
SHOW WARNINGS;

CREATE TABLE :TextContent
(
   id INT NOT NULL AUTO_INCREMENT,
   Event INT NULL,
   Title VARCHAR(40) NOT NULL,
   Content TEXT NOT NULL,
   Date DATETIME NOT NULL,
   Type VARCHAR(14) NOT NULL,
   `Order` SMALLINT,
   PRIMARY KEY(id),
   FOREIGN KEY (Event) REFERENCES :Event(id),
   INDEX (Event, Title),
   INDEX (Event, Type)
);
SHOW WARNINGS;

CREATE TABLE :Classification
(
   id INT NOT NULL AUTO_INCREMENT,   
   Name VARCHAR(40) NOT NULL,
   GenderRequirement CHAR(1),
   MinimumAge INT,
   MaximumAge INT,
   MinimumRating INT,
   MaximumRating INT,
   PdgaStatusRequirement CHAR(1),
   Available TINYINT NOT NULL,
   PRIMARY KEY(id),
   INDEX(Available)
);
SHOW WARNINGS;

CREATE TABLE :Course
(
   id INT NOT NULL AUTO_INCREMENT,
   Venue INT NULL,
   Name VARCHAR(40) NOT NULL,
   Description TEXT NOT NULL,
   Link VARCHAR(120) NOT NULL,
   Map VARCHAR(60) NOT NULL,
   Event INT NULL,
   PRIMARY KEY(id),
   FOREIGN KEY (Venue) REFERENCES :Venue(id),
   FOREIGN KEY (Event) REFERENCES :Event(id)
);
SHOW WARNINGS;

CREATE TABLE `:Round`
(
   id INT NOT NULL AUTO_INCREMENT,
   Event INT NOT NULL,
   Course INT NULL,
   StartType VARCHAR(12) NOT NULL,
   StartTime DATETIME NOT NULL,
   `Interval` TINYINT,
   ValidResults TINYINT(1) NOT NULL,
   GroupsFinished DATETIME NULL,
   PRIMARY KEY(id),
   FOREIGN KEY (Event) REFERENCES :Event(id),
   FOREIGN KEY (Course) REFERENCES :Course(id)
);
SHOW WARNINGS;

CREATE TABLE :Section (
   id INT NOT NULL AUTO_INCREMENT,
   Name VARCHAR(40) NOT NULL,
   Classification INT NULL,
   Round INT NOT NULL,
   Priority SMALLINT NULL,
   StartTime DATETIME NULL,
   Present TINYINT NOT NULL DEFAULT '1',
   PRIMARY KEY(id),
   FOREIGN KEY (Classification) REFERENCES :Classification(id),
   FOREIGN KEY (Round) REFERENCES `:Round`(id)
);

CREATE TABLE :Hole
(
   id INT NOT NULL AUTO_INCREMENT,
   Course INT NOT NULL,
   HoleNumber TINYINT NOT NULL,
   Par TINYINT NOT NULL,
   Length SMALLINT NOT NULL,
   PRIMARY KEY(id),
   FOREIGN KEY (Course) REFERENCES :Course(id),
   INDEX(Course, HoleNumber)
);
SHOW WARNINGS;

CREATE TABLE :Participation
(
   id INT NOT NULL AUTO_INCREMENT,
   Player SMALLINT NOT NULL,
   Event INT NOT NULL,
   Classification INT NOT NULL,
   Approved TINYINT NOT NULL,
   EventFeePaid DATETIME,
   OverallResult SMALLINT,
   Standing SMALLINT,
   DidNotFinish TINYINT NOT NULL,
   SignupTimestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   TournamentPoints INT NULL,
   SignUpNumber int(11),
   PRIMARY KEY(id),
   FOREIGN KEY (Player) REFERENCES :Player(player_id),
   FOREIGN KEY (Event) REFERENCES :Event(id),
   FOREIGN KEY (Classification) REFERENCES :Classification(id)
);
SHOW WARNINGS;

CREATE TABLE :RoundResult
(
   id INT NOT NULL AUTO_INCREMENT,
   `Round` INT NOT NULL,
   Player SMALLINT NOT NULL,
   Result SMALLINT NOT NULL,
   Penalty TINYINT NOT NULL,
   SuddenDeath TINYINT,
   Completed TINYINT DEFAULT '99',
   DidNotFinish TINYINT DEFAULT '0',
   PlusMinus MEDIUMINT NOT NULL,
   LastUpdated DATETIME NOT NULL,
   CumulativePlusminus INT DEFAULT '0',
   CumulativeTotal INT DEFAULT '0',
   PRIMARY KEY(id),
   FOREIGN KEY (`Round`) REFERENCES `:Round`(id),
   FOREIGN KEY (Player) REFERENCES :Player(player_id),
   INDEX(`Round`, LastUpdated)
);
SHOW WARNINGS;

CREATE TABLE :HoleResult
(
   id INT NOT NULL AUTO_INCREMENT,
   Hole INT NOT NULL,
   RoundResult INT NOT NULL,
   Player SMALLINT NOT NULL,
   Result TINYINT NOT NULL,
   DidNotShow TINYINT(1) NOT NULL,
   LastUpdated DATETIME NOT NULL,
   PRIMARY KEY(id),
   FOREIGN KEY (Hole) REFERENCES :Hole(id),
   FOREIGN KEY (RoundResult) REFERENCES :RoundResult(id),
   FOREIGN KEY (Player) REFERENCES :Player(player_id),
   INDEX(RoundResult, LastUpdated)
);
SHOW WARNINGS;

CREATE TABLE :StartingOrder
(
   id INT NOT NULL AUTO_INCREMENT,
   Player SMALLINT NOT NULL,
   `Section` INT NOT NULL,
   StartingTime DATETIME NOT NULL,
   StartingHole TINYINT,
   PoolNumber SMALLINT NOT NULL,
   PRIMARY KEY(id),
   FOREIGN KEY (Player) REFERENCES :Player(player_id),
   FOREIGN KEY (`Section`) REFERENCES `:Section`(id)
);
SHOW WARNINGS;

CREATE TABLE :SectionMembership
(
   id INT NOT NULL AUTO_INCREMENT,
   Participation INT NOT NULL,
   Section INT NOT NULL,
   PRIMARY KEY(id),
   FOREIGN KEY (Participation) REFERENCES :Participation(id),
   FOREIGN KEY (Section) REFERENCES :Section(id)
);
SHOW WARNINGS;

CREATE TABLE :TournamentStanding  
(
   id INT NOT NULL AUTO_INCREMENT,
   Player SMALLINT NOT NULL,
   Tournament INT NOT NULL,
   OverallScore SMALLINT NOT NULL,
   Standing SMALLINT,
   TieBreaker SMALLINT NOT NULL DEFAULT '0',
   PRIMARY KEY(id),
   FOREIGN KEY (Player) REFERENCES :Player(player_id),
   FOREIGN KEY (Tournament) REFERENCES :Tournament(id)
);
SHOW WARNINGS;

CREATE TABLE :ClassInEvent
(
   id INT NOT NULL AUTO_INCREMENT,
   Classification INT NOT NULL,
   Event INT NOT NULL,
   ClassPlayerLimit INT,
   PRIMARY KEY(id),
   FOREIGN KEY (Classification) REFERENCES :Classification(id),
   FOREIGN KEY (Event) REFERENCES :Event(id)
);
SHOW WARNINGS;

CREATE TABLE :LicensePayment
(
   id INT NOT NULL AUTO_INCREMENT,
   Player SMALLINT NOT NULL, 
   Year INT NOT NULL,
   PRIMARY KEY(id),
   FOREIGN KEY (Player) REFERENCES :Player(player_id)
);
SHOW WARNINGS;

CREATE TABLE :MembershipPayment
(
   id INT NOT NULL AUTO_INCREMENT,
   Player SMALLINT NOT NULL,
   Year INT NOT NULL, 
   PRIMARY KEY(id),
   FOREIGN KEY (Player) REFERENCES :Player(player_id)
);
SHOW WARNINGS;

CREATE TABLE :Club 
(
  id INT NOT NULL AUTO_INCREMENT,
  name varchar(100) NOT NULL,
  short_name varchar(15) NOT NULL,
  region varchar(50),
  contact varchar(100),
  PRIMARY KEY(id)
);

CREATE TABLE :Waitinglist (
  id int(11) NOT NULL AUTO_INCREMENT,
  Event int(11) NOT NULL,
  Player int(11) NOT NULL,
  Signup_number int(11) NOT NULL,
  Classification int(11) NOT NULL,
  Signup_Timestamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS :Event_views_visibility (
  event int(11) NOT NULL,
  view varchar(50) NOT NULL,
  visibility enum('private','public') NOT NULL DEFAULT 'public',
  PRIMARY KEY (event,view)
) 

