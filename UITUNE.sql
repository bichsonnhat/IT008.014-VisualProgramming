CREATE DATABASE UITUNE

USE UITUNE

CREATE TABLE UserRole
(
	Id int identity(1,1) PRIMARY KEY,
	displayname nvarchar(max),
)

CREATE TABLE Users
(
	Id int identity(1,1) PRIMARY KEY,
	displayname nvarchar(max),
	username nvarchar(100),
	password nvarchar(max),
	IdRole int NOT NULL
	FOREIGN KEY (IdRole) REFERENCES UserRole(Id)
)

CREATE TABLE Artist
(
	Id int identity(1,1) PRIMARY KEY,
    artistName nvarchar(255) NOT NULL,
);

CREATE TABLE Album
(
	Id int identity(1,1) PRIMARY KEY,
    title nvarchar(255),
    artistID int,
    tracks int,
    duration time,
    release_year int
	FOREIGN KEY (artistID) REFERENCES Artist(Id),
);

CREATE TABLE Song
(	
	Id int identity(1,1) PRIMARY KEY,
	title nvarchar(255) NOT NULL,
    albumID int NOT NULL,
    duration time NOT NULL,
    filepath varchar(max) NOT NULL,
	FOREIGN KEY (albumID) REFERENCES Album(id),
);

CREATE TABLE SongArtists (
    songID INT,
    artistID INT,
    PRIMARY KEY (songID, artistID),
    FOREIGN KEY (songID) REFERENCES Song(Id),
    FOREIGN KEY (artistID) REFERENCES Artist(Id)
);
 
CREATE TABLE Playlist
(
	Id int identity(1,1) PRIMARY KEY,
    playlistName nvarchar(255),
	userID int,
    tracks int,
    duration time,
	FOREIGN KEY (userID) REFERENCES Users(Id)
);

CREATE TABLE PlaylistSong
(
    Id int identity(1,1) PRIMARY KEY,
    playlistID int,
    songID int,
	FOREIGN KEY (playlistID) REFERENCES Playlist(Id),
    FOREIGN KEY (SongID) REFERENCES Song(Id)
);

CREATE TRIGGER UpdateAlbumAfterSongChange
ON Song
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE Album
    SET duration = 
        (SELECT CAST(DATEADD(SECOND, SUM(DATEDIFF(SECOND, '00:00:00', Song.duration)), '00:00:00') AS time)
         FROM Song
         WHERE Song.albumID = Album.Id),
        tracks = 
        (SELECT COUNT(*)
         FROM Song
         WHERE Song.albumID = Album.Id)
    WHERE Id IN (SELECT albumID FROM inserted);
END;


CREATE TRIGGER UpdatePlaylistAfterPlaylistSongChange
ON PlaylistSong
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE Playlist
    SET duration = 
        (SELECT CAST(DATEADD(SECOND, SUM(DATEDIFF(SECOND, '00:00:00', Song.duration)), '00:00:00') AS time)
         FROM PlaylistSong
         JOIN Song ON PlaylistSong.songID = Song.Id
         WHERE PlaylistSong.playlistID = Playlist.Id),
        tracks = 
        (SELECT COUNT(*)
         FROM PlaylistSong
         WHERE PlaylistSong.playlistID = Playlist.Id)
    WHERE Id IN (SELECT playlistID FROM inserted);
END;
