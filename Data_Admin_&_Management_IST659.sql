-- Drop all procedures
IF OBJECT_ID('dbo.Change_Rating', 'P') IS NOT NULL
		DROP PROCEDURE dbo.Change_Rating;
go
-- Drop all functions dbo.Hours_Played, dbo.Game_Studio_Count
IF OBJECT_ID('dbo.Hours_Played', 'F') IS NOT NULL
		DROP FUNCTION dbo.Hours_played
go
IF OBJECT_ID('dbo.Game_Studio_Count', 'F') IS NOT NULL
		DROP FUNCTION dbo.Game_Studio_Count
go
-- Drop all views Top_Studios, Top_games, and RPG_locations
 IF OBJECT_ID('dbo.Top_Studios', 'V') IS NOT NULL
		DROP VIEW dbo.Top_Studios;
go
IF OBJECT_ID('dbo.Top_games', 'V') IS NOT NULL
		DROP VIEW dbo.Top_games;
go
IF OBJECT_ID('dbo.RPG_locations', 'V') IS NOT NULL
		DROP VIEW dbo.RPG_locations;
go

-- Drop tables in order of reverse dependency (Studio_video_game_bridge, Video_game, Game_info, Storage_location, Game_studio, Console)
IF OBJECT_ID('dbo.Studio_video_game_bridge', 'U') IS NOT NULL
		DROP TABLE dbo.Studio_video_game_bridge;
go
IF OBJECT_ID('dbo.Video_game', 'U') IS NOT NULL
		DROP TABLE dbo.Video_game;
go
IF OBJECT_ID('dbo.Game_info', 'U') IS NOT NULL
		DROP TABLE dbo.Game_info;
go
IF OBJECT_ID('dbo.Storage_location', 'U') IS NOT NULL
		DROP TABLE dbo.Storage_location;
go
IF OBJECT_ID('dbo.Game_studio', 'U') IS NOT NULL
		DROP TABLE dbo.Game_studio;
go
IF OBJECT_ID('dbo.Console', 'U') IS NOT NULL
		DROP TABLE dbo.Console;
go
-- CREATE TABLES IN ORDER OF DEPENDENCY 

-- Create Console table by declaring each column and assigning it a data type.
CREATE TABLE Console
(
	Console_id int NOT NULL IDENTITY,
	Console_name varchar(20) NOT NULL,
	Generation tinyint NOT NULL,
	Console_year_released datetime NOT NULL,
	Company varchar(30) NOT NULL,
	CONSTRAINT Console_PK PRIMARY KEY(Console_id),
	CONSTRAINT Console_U UNIQUE(Console_name)
)

-- Create Game_studio table
CREATE TABLE Game_studio
(
	Studio_id int NOT NULL IDENTITY,
	Studio_name varchar(50) NOT NULL,
	Country varchar(30) NOT NULL,
	Year_Founded datetime NOT NULL,
	CONSTRAINT Game_Studio_PK PRIMARY KEY(Studio_id),
	CONSTRAINT Game_Studio_U UNIQUE(Studio_name)
)

--Add Storage_Location Table
CREATE TABLE Storage_location
(
	Storage_location_id int NOT NULL IDENTITY,
	Location_name varchar(30) NOT NULL,
	Number_of_games smallint NOT NULL,
	CONSTRAINT Storage_location_PK PRIMARY KEY(Storage_location_id)
)


-- Create the Game_info table
CREATE TABLE Game_info
(
	Info_id int NOT NULL identity,
	actively_installed varchar(10) NOT NULL,
	hours_played smallint,
	online_offline varchar(10) NOT NULL,
	Achievement_count smallint,
	Storage_location_id int NOT NULL,
	CONSTRAINT Game_info_PK PRIMARY KEY(Info_id),
	CONSTRAINT Game_info_FK FOREIGN KEY(Storage_location_id) REFERENCES Storage_location(Storage_location_id)
)


-- Create the video_game table
CREATE TABLE Video_game
(
	Game_id int NOT NULL IDENTITY,
	Game_name varchar(50) NOT NULL,
	Game_year_released datetime NOT NULL,
	rating varchar(20) NOT NULL,
	Genre varchar(20) NOT NULL,
	digital_physical varchar(10) NOT NULL,
	Console_id int NOT NULL,
	info_id int NOT NULL,
	CONSTRAINT Video_game_PK PRIMARY KEY(Game_id),
	CONSTRAINT Video_game_U UNIQUE(Game_name),
	CONSTRAINT Video_game_FK1 FOREIGN KEY(Console_id) REFERENCES Console(Console_id),
	CONSTRAINT Video_game_FK2 FOREIGN KEY(Info_id) REFERENCES Game_info(Info_id)
)


--Create the Studio_video_game_bridge table, a bridge table is used to facilitate a many to many relationship between tables.
CREATE TABLE Studio_video_game_bridge
(
	Studio_video_game_id int NOT NULL IDENTITY,
	Studio_id int NOT NULL,
	Game_id int NOT NULL,
	CONSTRAINT svg_PK PRIMARY KEY(Studio_video_game_id),
	CONSTRAINT svg_FK1 FOREIGN KEY(Studio_id) REFERENCES Game_studio(Studio_id),
	CONSTRAINT svg_FK2 FOREIGN KEY(Game_id) REFERENCES Video_game(Game_id)
)


-- INSERT VALUES INTO THE CREATED TABLES.

-- Add values to the console table, there are 4 consoles in the database. By separating parentheses with commas we can enter all 4 consoles at once.
INSERT INTO Console
	(Console_name, Generation, Console_year_released, Company)
VALUES
	('DreamCast', 1, 1999, 'Sega'),
	('Xbox One', 4, 2013, 'Microsoft'),
	('Xbox 360', 3, 2005, 'Microsoft'),
	('Playstation 3', 3, 2006, 'Sony')

-- Look for the added values in the Console Table
SELECT * FROM Console

-- The first select statement showed that console_year_released had errors.
-- These updates should make the table work.
UPDATE Console SET Console_year_released = '1999'
	WHERE Console_name = 'DreamCast'
UPDATE Console SET Console_year_released = '2013'
	WHERE Console_name = 'Xbox One'
UPDATE Console SET Console_year_released = '2005'
	WHERE Console_name = 'Xbox 360'
UPDATE Console SET Console_year_released = '2006'
	WHERE Console_name = 'Playstation 3'

-- Check new console_year_released to make sure the update worked.
SELECT * FROM Console

-- Add values to Game_studio table.
INSERT INTO Game_studio
	(Studio_name, Country, Year_Founded)
VALUES
	('Dolby Digital', 'United States', '1994'),
	('Havok', 'Ireland', '1998'),
	('Bethesda', 'United States', '1986'),
	('Unreal Engine', 'United States', '1998'),
	('Microsoft Studio', 'United States', '2000'),
	('Undead Labs', 'United States', '2009'),
	('Rockstar Games', 'United States', '1998'),
	('Zenimax', 'United States', '1999'),
	('Criware', 'Japan', '1983'),
	('Bandai Namco', 'Japan', '2006'),
	('Ubisoft', 'France', '1986'),
	('2k', 'United States', '2005'),
	('Dice', 'Sweden', '1992'),
	('LucasFilms', 'United States', '1982'),
	('Electronic Arts', 'United States', '1982'),
	('id Tech', 'United States', '1999'),
	('Activision', 'United States', '1979'),
	('Mass Media', 'United States', '1980'),
	('Naughty Dog', 'United States', '1984'),
	('Sony', 'Japan', '1946'),
	('Disney Studios', 'United States', '1988'),
	('Square Enix', 'Japan', '2003'), 
	('Paradox Interactive', 'Sweden', '1998'),
	('Tantalus Media', 'Austalia', '1994'),
	('CD Projekt Red', 'Poland', '1994'),
	('Xbox Game Studios', 'United States', '2002'),
	('Lionhead Studios', 'United Kingdom', '1996'),
	('Epic Games', 'United States', '1991'),
	('Warner Brothers Studios', 'United States', '1993'),
	('Monolith Productions', 'United States', '1994'),
	('Sega', 'United States', '1960'),
	('Crystal Dynamics', 'United States', '1992'),
	('Eidos Montreal', 'Canada', '2007')

-- Look at values in new Game_studio Table there should be 33 values
SELECT * FROM Game_studio

--Add Values to the Storage_Location table
INSERT INTO Storage_Location
	(Location_name, Number_of_games)
VALUES
	('Box 1', 8),
	('Box 2', 5),
	('Box 3', 4),
	('Box 4', 7),
	('Box 5', 16)

-- Check for new values, there should be 5 values
SELECT * FROM Storage_location 

-- Theres actually only 15 games in box 5 so we need to update
UPDATE Storage_location SET Number_of_games = 15 WHERE Location_name = 'Box 5'
-- Check for update by re-executing line 383

-- Add values to the game_info table
INSERT INTO Game_info
	(actively_installed, hours_played, online_offline, Achievement_count, Storage_location_id)
VALUES
	('Yes', 100, 'Offline', 50, 1),
	('Yes', 90, 'Online', 61, 1),
	('Yes', 20, 'Online', 9, 1),
	('Yes', 10, 'Online', 5, 1),
	('Yes', 60, 'Offline', 35, 1),
	('Yes', 80, 'Online', 23, 1),
	('Yes', 10, 'Online', 19, 1),
	('Yes', 150, 'Offline', 47, 1),
	('No', 100, 'Online', 16, 2),
	('No', 5, 'Online', 2, 2),
	('No', 20, 'Offline', 21, 2),
	('No', 20, 'Online', 13, 2),
	('No', 15, 'Online', 20, 2),
	('No', 5, 'Offline', NULL, 3),
	('No', 30, 'Offline', NULL, 3),
	('No', 25, 'Offline', NULL, 3),
	('No', 40, 'Offline', NULL, 3),
	('No', 15, 'Online', 3, 4),
	('No', 25, 'Offline', 19, 4),
	('No', 10, 'Online', 0, 4),
	('No', 30, 'Offline', 25, 4),
	('No', 40, 'Online', 31, 4),
	('No', 15, 'Offline', 13, 4),
	('No', 25, 'Online', 17, 4),
	('Yes', 40, 'Online', 36, 5),
	('Yes', 25, 'Online', 39, 5),
	('Yes', 30, 'Offline', 11, 5),
	('Yes', 30, 'Online', 16, 5),
	('Yes', 10, 'Online', 1, 5),
	('Yes', 35, 'Offline', 52, 5),
	('Yes', 25, 'Offline', 30, 5),
	('No', 10, 'Offline', 3, 5),
	('No', 20, 'Offline', 15, 5),
	('No', 15, 'Offline', 16, 5),
	('No', 5, 'Online', 0, 5),
	('No', 20, 'Online', 35, 5),
	('No', 10, 'Offline', 7, 5),
	('No', 5, 'Online', 3, 5),
	('No', 30, 'Offline', 20, 5)

-- Check values from new table
SELECT * FROM Game_info

--Add Values to the Video_game Table
INSERT INTO Video_game
	(Game_name, Game_year_released, rating, Genre, digital_physical, Console_id, info_id)
Values
	('Oblivion', '2005', 'Teen', 'RPG', 'Physical', 3, 1),
	('Assassin''s Creed Odyssey', '2018', 'Physical', 'Adventure', 'Physical', 2, 2),
	('Jump Force', '2019', 'Teen', 'Fighting', 'Physical', 2, 3),
	('Elder Scrolls Online', '2016', 'Mature', 'RPG', 'Physical', 2, 4),
	('Fallout 4', '2015', 'Mature', 'RPG', 'Physical', 2, 5),
	('Red Dead Redemption 2', '2018', 'Mature', 'Adventure', 'Physical', 2, 6),
	('State of Decay 2', '2018', 'Mature', 'Survival', 'Physical', 2, 7),
	('Skyrim', '2011', 'Mature', 'RPG', 'Physical', 3, 8),
	('Star Wars Battlefront II', '2017', 'Teen', 'Shooter', 'Physical', 2, 9),
	('Star Wars Battlefront', '2015', 'Teen', 'Shooter', 'Physical', 2, 10),
	('Wolfenstein II', '2017', 'Mature', 'Shooter', 'Physical', 2, 11),
	('Call of Duty: WWII', '2017', 'Mature', 'Shooter', 'Physical', 2, 12),
	('Halo 5: Guardians', '2015', 'Mature', 'Shooter', 'Physical', 2, 13),
	('Kingdom Hearts 2.5', '2014', 'Everyone 10+', 'Adventure', 'Physical', 4, 14),
	('Kingdom Hearts 1.5', '2013', 'Everyone 10+', 'Adventure', 'Physical', 4, 15),
	('The Sly Collection', '2010', 'Everyone 10+', 'Adventure', 'Physical', 4, 16),
	('Jak and Daxter Collection', '2012', 'Teen', 'Adventure', 'Physical', 4, 17),
	('FIFA 14', '2013', 'Everyone', 'Sports', 'Physical', 3, 18),
	('Fable II', '2008', 'Mature', 'RPG', 'Physical', 3, 19),
	('NHL 09', '2008', 'Everyone 10+', 'Sports', 'Physical', 3, 20),
	('Assasin''s Creed Brotherhood', '2010', 'Mature', 'Adventure', 'Physical', 3, 21),
	('Call of Duty 4: Modern Warfare', '2007', 'Mature', 'Shooter', 'Physical', 3, 22),
	('Doom 3', '2012', 'Mature', 'Shooter', 'Physical', 3, 23),
	('NBA 2k16', '2015', 'Everyone 10+', 'Sports', 'Physical', 2, 24),
	('Assassin''s Creed Orgins', '2017', 'Mature', 'Adventure', 'Digital', 2, 25),
	('Dragonball Z Xenoverse 2', '2016', 'Teen', 'Fighting', 'Digital', 2, 26),
	('Cities Skylines', '2015', 'Everyone', 'Simulation', 'Digital', 2, 27),
	('Grand Theft Auto V', '2013', 'Mature', 'Adventure', 'Digital', 2, 28),
	('Madden 19', '2018', 'Everyoe', 'Sports', 'Digital', 2, 29),
	('Shadow of The Tomb Raider', '2018', 'Mature', 'Adventure', 'Digital', 2, 30),
	('Witcher 3', '2015', 'Mature', 'RPG', 'Digital', 2, 31),
	('Dark Souls 3', '2016', 'Mature', 'RPG', 'Digital', 2, 32),
	('Doom', '2016', 'Mature', 'Shooter', 'Digital', 2, 33),
	('Fable 3', '2010', 'Mature', 'RPG', 'Digital', 3, 34),
	('Fortnite', '2018', 'Teen', 'Shooter', 'Digital', 2, 35),
	('Middle Earth: Shadow of Mordor', '2014', 'Mature', 'Adventure', 'Digital', 2, 36),
	('Sonic Adventure', '1998', 'Everyone', 'Adventure', 'Digital', 1, 37),
	('Dragon Ball Z Fighterz', '2018', 'Teen', 'Fighting', 'Digital', 2, 38),
	('Tomb Raider', '2013', 'Mature', 'Adventure', 'Digital', 2, 39)

-- Made a mistake and will create a procedure for updating game genre
CREATE PROCEDURE Change_Rating(@gameName varchar(50), @newRating varchar(20))ASBEGIN	UPDATE Video_game SET rating = @newRating	WHERE Game_name = @gameNameENDGO

-- Update the Assassins Creed Odyssey rating
EXEC Change_Rating 'Assassin''s Creed Odyssey', 'Mature'

-- Check for new values in video_game table and the update.
SELECT * FROM Video_game

-- Add values to the Studio_video_game_bridge, we need to pair the Studio ID's with the Game ID's that they've produced.
INSERT INTO Studio_video_game_bridge
	(Studio_id, Game_id)
VALUES
	(3, 1),
	(2, 1),
	(12, 1),
	(1, 2),
	(2, 2),
	(11, 2),
	(4, 3),
	(9, 3),
	(10, 3),
	(3, 4),
	(8, 4),
	(1, 5),
	(2, 5),
	(3, 5),
	(7, 6),
	(4, 7),
	(6, 7),
	(5, 7),
	(1, 8),
	(2, 8),
	(3, 8),
	(13, 9),
	(14, 9),
	(15, 9),
	(13, 10),
	(14, 10),
	(15, 10),
	(2, 11),
	(16, 11),
	(3, 11),
	(1, 12),
	(2, 12),
	(17, 12),
	(2, 13),
	(5, 13),
	(1, 14),
	(22, 14),
	(1, 15),
	(22, 15),
	(20, 16),
	(18, 17),
	(19, 17),
	(15, 18),
	(1, 19),
	(5, 19),
	(1, 20),
	(5, 20),
	(15, 20),
	(11, 21),
	(1, 21),
	(5, 21),
	(1, 22),
	(5, 22),
	(17, 22),
	(8, 23),
	(3, 23),
	(16, 23),
	(1, 23),
	(5, 23),
	(12, 24),
	(11, 25),
	(2, 25),
	(1, 25),
	(10, 26),
	(23, 27),
	(24, 27),
	(7, 28),
	(15, 29),
	(32, 30),
	(33, 30), 
	(25, 31),
	(10, 32),
	(3, 33),
	(16, 33),
	(26, 34),
	(27, 34),
	(28, 35),
	(29, 36),
	(30, 36),
	(31, 37),
	(10, 38),
	(32, 39),
	(33, 39)

-- Check for values in the Studio_video_game_bridge
SELECT * FROM Studio_video_game_bridge

--DATA QUESTION SECTION

-- DATA QUESTION #1 Which game studio has produced the most games in the collection?

-- In order to answer my first data question I will first create a function to count how many games each studio has produced
CREATE FUNCTION dbo.Game_Studio_Count(@studioID int)RETURNS int AS -- COUNT() is an integer value, so return it as an intBEGIN	DECLARE @gameCount int 	SELECT @gameCount = COUNT(Video_game.Game_id) 	FROM Studio_video_game_bridge	JOIN Game_studio on Studio_video_game_bridge.Studio_id = Game_studio.Studio_id	JOIN Video_game on Studio_video_game_bridge.Game_id = Video_game.Game_id	WHERE Studio_video_game_bridge.Studio_id = @studioID	-- Return @gameCount to the calling code	RETURN @gameCountENDGO-- Next we create a view to see the top 5 studios in terms of video games in the collectionCREATE VIEW Top_Studios AS	SELECT TOP 5	*	, dbo.Game_Studio_Count(Studio_id) AS Game_Count	FROM Game_Studio	ORDER BY Game_Count DESCGO-- Finally to see the results in the created view Top_StudiosSELECT * FROM Top_Studios-- The number one result on this list, and the answer to question one is dolby digital with twelve games.-- QUESTION 2 What game is played the most(in hours)?-- Create a function to show the number of hours played for a given Video_game.Game_nameCREATE FUNCTION dbo.Hours_played(@gameID int)RETURNS int ASBEGIN	 DECLARE @hours int	SELECT @hours = hours_played	FROM Game_info	JOIN Video_game ON Game_info.Info_id = Video_game.info_id	WHERE Video_game.Game_id = @gameID	RETURN @hoursENDGO-- Create a view that shows the games with the most hours played in descending orderCREATE VIEW Top_games AS	SELECT TOP 5 	*	, dbo.Hours_played(Video_game.Game_id) AS Game_hours	FROM Video_game	ORDER BY Game_hours DESCGO-- Draw the results from this view.SELECT * FROM Top_games-- The top result, and answer to question 2 is Skyrim-- QUESTION 3 Which game genre appears the most frequently in the collection?SELECT * FROM Video_game ORDER BY Genre-- Because of the way genres are coded into the tables we need torepeat our query for each Genre individuallySELECT COUNT(Game_id) AS Adventure FROM Video_game WHERE Genre='Adventure' SELECT COUNT(Game_id) AS RPG FROM Video_game WHERE Genre='RPG' SELECT COUNT(Game_id) AS Shooter FROM Video_game WHERE Genre='Shooter'SELECT COUNT(Game_id) AS Fighting FROM Video_game WHERE Genre='Fighting'SELECT COUNT(Game_id) AS Simulation FROM Video_game WHERE Genre='Simulation'SELECT COUNT(Game_id) AS Sports FROM Video_game WHERE Genre='Sports'SELECT COUNT(Game_id) AS Survival FROM Video_game WHERE Genre='Survival'-- Most popular genre in the collection is Adventure-- QUESTION 4 Which storage location has the most RPG’s?-- This can be answered in one query which I will save as a view.-- Must join Game_info and Storage_location in order to answer all parts of the data question.CREATE VIEW RPG_locations AS	SELECT Location_name, COUNT(Game_id) AS RPGcount	FROM Video_game	INNER JOIN Game_info ON Video_game.info_id = Game_info.Info_id	INNER JOIN Storage_location ON Game_info.Storage_location_id = Storage_location.Storage_location_id	WHERE Genre = 'RPG'	GROUP BY Storage_location.Location_nameGO-- Select the viewSELECT * FROM RPG_locations-- The answer is Box 1 with 4 RPG titles-- QUESTION 5 What year accounts for the most games in the collection?-- Can also be answered in one querySELECT Game_year_released, COUNT(Game_id) AS Game_count 
	FROM Video_game 
	GROUP BY Game_year_released 
	ORDER BY Game_count DESC

-- Our answer is 2018 with 7 games
