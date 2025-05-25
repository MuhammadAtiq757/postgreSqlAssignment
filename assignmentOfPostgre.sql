-- Active: 1747582579596@@127.0.0.1@5432@ph
-- Create Tabble
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(100)
);

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100) NOT NULL,
    scientific_name VARCHAR(100) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(50),
    CHECK (
        conservation_status IN (
            'Endangered',
            'Vulnerable',
            'Near Threatened',
            'Least Concern',
            'Historic'
        )
    )
);

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT REFERENCES species (species_id),
    species_id INT REFERENCES rangers (ranger_id),
    sighting_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    location VARCHAR(150) NOT NULL,
    notes TEXT
);

-- Insert Data
INSERT INTO
    rangers (name, region)
VALUES (
        'Alice Green',
        'Northern Hills'
    ),
    ('Bob White', 'River Delta'),
    (
        'Carol King',
        'Mountain Range'
    );

-- Insert data into species
INSERT INTO
    species (
        common_name,
        scientific_name,
        discovery_date,
        conservation_status
    )
VALUES (
        'Snow Leopard',
        'Panthera uncia',
        '1775-01-01',
        'Endangered'
    ),
    (
        'Bengal Tiger',
        'Panthera tigris tigris',
        '1758-01-01',
        'Endangered'
    ),
    (
        'Red Panda',
        'Ailurus fulgens',
        '1825-01-01',
        'Vulnerable'
    ),
    (
        'Asiatic Elephant',
        'Elephas maximus indicus',
        '1758-01-01',
        'Endangered'
    );

-- Insert sample data into sightings
INSERT INTO
    sightings (
        species_id,
        ranger_id,
        location,
        sighting_time,
        notes
    )
VALUES (
        1,
        1,
        'Peak Ridge',
        '2024-05-10 07:45:00',
        'Camera trap image captured'
    ),
    (
        2,
        2,
        'Bankwood Area',
        '2024-05-12 16:20:00',
        'Juvenile seen'
    ),
    (
        3,
        3,
        'Bamboo Grove East',
        '2024-05-15 09:10:00',
        'Feeding observed'
    ),
    (
        1,
        2,
        'Snowfall Pass',
        '2024-05-18 18:30:00',
        NULL
    );

---------------------- problem 1------------------
INSERT INTO
    rangers (name, region)
VALUES ('Derek Fox', 'Coastal Plains');

-------------------- problem 2---------------------
SELECT count(DISTINCT species_id) AS unique_species_count
FROM sightings

-- ------------------------problem 3--------------
SELECT * FROM sightings WHERE LOCATION ILIKE '%Pass%';

-- --------------------problem 4--------------------

SELECT r.name, COUNT(s.sighting_id) AS total_sightings
FROM rangers r
    LEFT JOIN sightings s ON r.ranger_id = s.ranger_id
GROUP BY
    r.name
ORDER BY r.name;

--------------------------- problem 5----------------
SELECT s.common_name
FROM species s
    left JOIN sightings si ON s.species_id = si.species_id
WHERE
    si.species_id IS NULL;

-- ------------------------problem 6------------------
SELECT sp.common_name, si.sighting_time, r.name
FROM
    sightings si
    JOIN species sp ON si.species_id = sp.species_id
    JOIN rangers r ON si.ranger_id = r.ranger_id
ORDER BY si.sighting_time DESC
LIMIT 2;

-- -------------------------problem 7-------------------
UPDATE species
SET
    conservation_status = 'Least Concern'
WHERE
    discovery_date < '1800-01-01'

-- -------------------problem 8-----------------
SELECT
    sighting_id,
    CASE
        WHEN EXTRACT(
            HOUR
            FROM sighting_time
        ) < 12 THEN 'Morning'
        WHEN EXTRACT(
            HOUR
            FROM sighting_time
        ) BETWEEN 12 AND 17  THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sightings;

-------------- problem 9------------------
DELETE FROM rangers
WHERE
    ranger_id NOT IN (
        SELECT DISTINCT
            ranger_id
        FROM sightings
    );