
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

-- Data Exploration

select count(*) from spotify;

select count( distinct artist) from spotify;

select distinct album_type from spotify;

select max(duration_min) as max_durat from spotify;


select * from spotify where duration_min = 0


select * from spotify 



-- Easy Level

-- Q1.Retrieve the names of all tracks that have more than 1 billion streams.

select track 
from spotify 
where stream > 1000000000

-- Q2.List all albums along with their respective artists.

select artists , albums
from spotify 

-- Q3.Get the total number of comments for tracks where licensed = TRUE.

select count(comments) as total_comments
from spotify
where licensed = "true"

-- Q4.Find all tracks that belong to the album type single.

select distinct tracks
from spotify 
where album_type = "single"

-- Q5.Count the total number of tracks by each artist.

select artist,count(track) as total_tracks
from spotify
group by artist

-- Medium Level

-- Q6.Calculate the average danceability of tracks in each album.

select 
album , avg(danceability) as avg_danceability
from spotify
group by album
order by avg_danceability desc;

-- Q7.Find the top 5 tracks with the highest energy values.

select 
track , max(energy)
from spotify
group by track
order by max(energy) desc
limit 5;
-- Q8.List all tracks along with their views and likes where official_video = TRUE.

select 
track , sum(views) as total_views , sum(likes) as total_likes
from spotify
group by track
order by total_likes desc;

-- Q9.For each album, calculate the total views of all associated tracks.

select 
album ,track, sum(views) as total_views
from spotify 
group by album , track 

-- 10.Retrieve the track names that have been streamed on Spotify more than YouTube.

select * from (
select 
track ,
coalesce(sum(case when most_played_on = 'Spotify' then stream end),0) as spotify_streamed,
coalesce(sum(case when most_played_on = 'Youtube' then stream end),0) as youtube_streamed
from spotify
group by track) x
where x.spotify_streamed > x.youtube_streamed and x.youtube_streamed <> 0 ;

-- Advanced Level

-- Q11.Find the top 3 most-viewed tracks for each artist using window functions.

select *
from (
select 
artist , track,sum(views) as total_views,
dense_rank() over(partition by artist order by sum(views) desc) as most_viewed 
from spotify 
group by 1,2 )as x
where most_viewed <= 3

-- Q12.Write a query to find tracks where the liveness score is above the average.

SELECT DISTINCT
    track,
    liveness
FROM spotify
WHERE liveness > (
    SELECT AVG(liveness)
    FROM spotify
);

-- Q13.Use a WITH clause to calculate the difference between the
-- highest and lowest energy values for tracks in each album.
with data as(
select 
album, 
min(energy) as min_energy,
max(energy) as max_energy
from spotify 
group by album )

select 
album , 
(max_energy - min_energy) as energy_diff
from data
order by energy_diff desc

-- Q14.Find tracks where the energy-to-liveness ratio is greater than 1.2.

select 
track,
energy,liveness,
energy/liveness as ratio
from spotify
where energy/liveness > 1.2

-- Q15.Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

select
track,
SUM(likes) 
OVER (partition by track ORDER BY views ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
from spotify