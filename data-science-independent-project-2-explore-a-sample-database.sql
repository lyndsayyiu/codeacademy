--Sample database: https://www.sqlitetutorial.net/sqlite-sample-database/

--Q1: --Which tracks appeared in the most playlists? how many playlist did they appear in?

--Using With to first create combined Table
WITH combined_table as (
SELECT *
FROM playlist_track
JOIN tracks
ON playlist_track.TrackId = tracks.TrackId
)
--Now query to find answer
SELECT Name, TrackId, COUNT(playlistID) as '# of playlists'
FROM combined_table
GROUP BY TrackId
ORDER BY Count(playlistid) DESC;

--Combined to less code
SELECT tracks.name, playlist_track.TrackId, count(playlist_track.TrackId) as '# of playlists'
FROM tracks
JOIN playlist_track 
	ON tracks.TrackId = playlist_track.TrackId    
GROUP BY playlist_track.trackid
ORDER BY COUNT(playlist_track.trackID) DESC;

--Q2 a) Which track generated the most revenue? 
--Using WITH
WITH invoice_tracks AS (
SELECT * 
FROM invoice_items
JOIN tracks
ON invoice_items.trackid = tracks.trackid
)
--QUERY for answer.
SELECT Name, COUNT(TrackID) AS 'Number of Sales', unitprice, SUM(quantity * unitprice) AS 'Sales'
FROM invoice_tracks
GROUP BY TrackId
ORDER BY SUM(quantity * unitprice) DESC
;

--Without WITH
SELECT tracks.name, COUNT(invoice_items.Trackid) as 'Number of Sales', invoice_items.unitprice, ROUND(SUM(invoice_items.quantity * invoice_items.unitprice), 2) AS 'Sales'
FROM invoice_items
JOIN tracks
ON invoice_items.TrackId = tracks.TrackId
GROUP BY invoice_items.trackid
ORDER BY 4 DESC;

--b) which album? 

SELECT albums.Title, COUNT(invoice_items.Trackid) as 'Number of Sales from Album', ROUND(SUM(invoice_items.quantity * invoice_items.unitprice), 2) AS 'Sales'
FROM invoice_items
JOIN tracks
	ON invoice_items.TrackId = tracks.TrackId
JOIN albums
	ON albums.albumid = tracks.albumid
GROUP BY albums.albumID
ORDER BY 3 DESC;
	
--c)which genre?
