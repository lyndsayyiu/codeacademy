--Sample database: https://www.sqlitetutorial.net/sqlite-sample-database/

--Q1: --Which tracks appeared in the most playlists? how many playlist did they appear in?

SELECT tracks.name, playlist_track.TrackId, count(playlist_track.TrackId) as 'Playlists'
FROM tracks
JOIN playlist_track 
	ON tracks.TrackId = playlist_track.TrackId    
GROUP BY playlist_track.trackid
ORDER BY COUNT(playlist_track.trackID) DESC;

--Which track generated the most revenue?
