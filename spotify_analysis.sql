
-- 1. SCHEMA STRUCTURE
DROP TABLE IF EXISTS spotify;
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

-- 2. DATA IMPORT (Executed via PSQL Tool)
-- \copy spotify FROM '/tmp/cleaned_dataset.csv' DELIMITER ',' CSV HEADER;

-- 3. EXPLORATORY DATA ANALYSIS (EDA) & CLEANING
SELECT COUNT(*) FROM spotify;
SELECT COUNT(DISTINCT artist) FROM spotify;
SELECT COUNT(DISTINCT album) FROM spotify;

-- Purging corrupted tracks with 0-minute durations
DELETE FROM spotify WHERE duration_min = 0;


-- 4. BUSINESS ANALYTICS (15 PROBLEMS)

-- Q1: Tracks with over 1 billion streams
SELECT track, stream FROM spotify WHERE stream > 1000000000;

-- Q2: List unique albums and their respective artists
SELECT DISTINCT album, artist FROM spotify ORDER BY artist;

-- Q3: Total comments for licensed tracks
SELECT SUM(comments) AS total_comments FROM spotify WHERE licensed = TRUE;

-- Q4: Find all single album types
SELECT track, album_type FROM spotify WHERE album_type = 'single';

-- Q5: Count tracks per artist
SELECT artist, COUNT(track) AS total_tracks FROM spotify GROUP BY artist ORDER BY total_tracks DESC;

-- Q6: Average danceability per album
SELECT album, AVG(danceability) AS avg_danceability FROM spotify GROUP BY album ORDER BY avg_danceability DESC;

-- Q7: Top 5 tracks with highest energy
SELECT track, MAX(energy) AS highest_energy FROM spotify GROUP BY track ORDER BY highest_energy DESC LIMIT 5;

-- Q8: Views and likes for official videos
SELECT track, SUM(views) AS total_views, SUM(likes) AS total_likes FROM spotify WHERE official_video = TRUE GROUP BY track ORDER BY total_views DESC;

-- Q9: Total views per album
SELECT album, track, SUM(views) AS total_views FROM spotify GROUP BY album, track ORDER BY total_views DESC;

-- Q10: Streams higher on Spotify than YouTube views
SELECT track, stream AS spotify_streams, views AS youtube_views FROM spotify WHERE stream > views;

-- Q11: Top 3 most-viewed tracks per artist (Window Function)
WITH ranked_tracks AS (
    SELECT artist, track, views, DENSE_RANK() OVER (PARTITION BY artist ORDER BY views DESC) AS rank
    FROM spotify
)
SELECT artist, track, views FROM ranked_tracks WHERE rank <= 3;

-- Q12: Tracks with liveness above global average (Subquery)
SELECT track, artist, liveness FROM spotify WHERE liveness > (SELECT AVG(liveness) FROM spotify);

-- Q13: Max and Min energy variance per album (CTE)
WITH album_energy AS (
    SELECT album, MAX(energy) AS max_energy, MIN(energy) AS min_energy FROM spotify GROUP BY album
)
SELECT album, (max_energy - min_energy) AS energy_difference FROM album_energy ORDER BY energy_difference DESC;

-- Q14: Tracks with valence above average
SELECT track, artist, valence FROM spotify WHERE valence > (SELECT AVG(valence) FROM spotify) ORDER BY valence DESC;

-- Q15: Cumulative sum of streams per artist (Window Function Frame)
SELECT artist, track, stream, SUM(stream) OVER (PARTITION BY artist ORDER BY stream DESC) AS cumulative_streams FROM spotify;


-- 5. QUERY OPTIMIZATION & PERFORMANCE TUNING
-- Baseline Scan: Seq Scan | Execution Time: ~6.01ms
EXPLAIN ANALYZE SELECT * FROM spotify WHERE artist = 'Gorillaz';

-- Creating B-Tree Index Optimization
CREATE INDEX idx_spotify_artist ON spotify(artist);

-- Optimized Scan: Bitmap Heap Scan | Execution Time: ~0.54ms (11x Speedup)
EXPLAIN ANALYZE SELECT * FROM spotify WHERE artist = 'Gorillaz';