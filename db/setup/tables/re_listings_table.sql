DROP TABLE IF EXISTS re_listings;

CREATE TABLE re_listings(
	listing_id varchar(50) NOT NULL UNIQUE,
	add_pref_name varchar(10) NOT NULL,
	add_city_name varchar(20) NOT NULL,
	add_street_name varchar(30) NULL,
	
	lat FLOAT NOT NULL,
	lon FLOAT NOT NULL,
	
	price INT NULL,
	sq_m FLOAT NULL,
	
	-- These are necessary for every table
	created_by VARCHAR(30),
 	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_re_listings_gps ON re_listings USING GIST(ST_MakePoint(lon, lat));

GRANT SELECT ON TABLE re_listings TO python;
GRANT SELECT ON TABLE re_listings TO gen;

GRANT INSERT ON TABLE re_listings TO python;
GRANT INSERT ON TABLE re_listings TO gen;