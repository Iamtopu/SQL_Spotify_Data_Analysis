
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

SELECT * FROM spotify

SELECT MIN(duration_min) FROM spotify

SELECT * FROM spotify
WHERE duration_min = 0

DELETE FROM spotify
WHERE duration_min = 0

SELECT DISTINCT channel FROM spotify



--Retrieve the names of all tracks that have more than 1 billion streams.

SELECT
	track
FROM
	spotify
WHERE
	stream > 1000000000

-- List all albums along with their respective artists.

SELECT
		album, artist
FROM
	spotify


-- Get the total number of comments for tracks where licensed = TRUE.

SELECT
	SUM(comments)
FROM
	spotify
WHERE
	licensed = 'true'


-- Find all tracks that belong to the album type single.



SELECT
	track
FROM
	spotify
WHERE
	album_type = 'single'


-- Count the total number of tracks by each artist.


SELECT 
	artist,
	COUNT(*) AS total_no_songs
FROM
	spotify
GROUP BY artist


--Calculate the average danceability of tracks in each album.

SELECT 
	album,
	AVG(danceability) AS avg_danceability
FROM
	spotify
GROUP BY 1
ORDER BY 2 DESC


--Find the top 5 tracks with the highest energy values.

SELECT
	track,
	energy
FROM
	spotify
ORDER BY 2 DESC
LIMIT 5


--List all tracks along with their views and likes where official_video = TRUE.

SELECT
	track,
	SUM(views) AS total_views,
	SUM(likes) AS total_likes
FROM
	spotify
WHERE
	official_video =  'true'
GROUP BY 1
ORDER BY 2 DESC

--For each album, calculate the total views of all associated tracks.


SELECT 
	album,
	track,
	SUM(views) AS total_views
FROM
	spotify
GROUP BY 1, 2
ORDER BY 3 DESC

--Retrieve the track names that have been streamed on Spotify more than YouTube.

SELECT * FROM
(SELECT
	track,
	COALESCE(SUM(CASE WHEN most_played_on = 'Youtube'THEN stream END),0) AS streamed_on_youtube,
	COALESCE(SUM(CASE WHEN most_played_on = 'Spotify'THEN stream END),0) AS streamed_on_spotify
FROM spotify
GROUP BY 1
) AS t1
WHERE
	streamed_on_spotify > streamed_on_youtube
	AND
	streamed_on_youtube <> 0


--Find the top 3 most-viewed tracks for each artist using window functions.

WITH ranking_artist AS
(SELECT
	artist,
	track,
	SUM(views) AS total_views,
	DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) AS rank
FROM spotify
GROUP BY 1, 2
ORDER BY 1, 3 DESC
)
SELECT * FROM ranking_artist
WHERE rank <= 3


--Write a query to find tracks where the liveness score is above the average.

SELECT
	track,
	liveness
FROM
	spotify
WHERE
	liveness >
(SELECT AVG(liveness) FROM spotify)

--Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

WITH cte
AS
(SELECT	
	album,
	max(energy) as highest_energy,
	min(energy) as lowest_energy
FROM spotify
group by 1)
SELECT
	album,
	highest_energy - lowest_energy AS energy_difference
FROM cte
ORDER BY 2 DESC

-- END
