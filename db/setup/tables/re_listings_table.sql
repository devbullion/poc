DROP MATERIALIZED VIEW IF EXISTS listings_pop_radius_view;
DROP TABLE IF EXISTS re_listings;

CREATE TABLE re_listings(
	source varchar(10) NOT NULL,
	page_url TEXT NOT NULL UNIQUE,
	description TEXT NOT NULL,
	station TEXT NULL,
	dist_to_sta_str TEXT NULL,
	dist_to_sta_walk_time INT NOT NULL,
	dist_to_sta_other_mode TEXT NULL,
	dist_to_sta_other_mode_time INT NULL,

	flr_loc varchar(10) NULL,
	age varchar(10) NULL,

	rent_price INT NOT NULL,
	rent_ccy varchar(5) NULL,
	management_fee INT NULL,
	management_fee_ccy varchar(5) NULL,

	deposit_guaranteed TEXT NULL,
	key_money_deprecation TEXT NULL,

	floor_plan varchar(10) NULL,
	size varchar(15) NOT NULL,
	size_number FLOAT NOT NULL,
	size_unit varchar(5) NOT NULL,

	floor_number_of_floors VARCHAR(30) NULL,
	floor INT NULL,
	number_of_floors VARCHAR(5) NULL,
	underground_floors VARCHAR(20) NULL,

	built_age int NULL,
	building_type varchar(10) NULL,
	direction varchar(5) NULL,
	
	address TEXT NOT NULL,
	address_kanji TEXT NULL,

	latitude FLOAT NOT NULL,
	longitude FLOAT NOT NULL,

	transportation TEXT NULL,
	floor_plan_image_URL TEXT NULL,

	second_florr_or_higher BOOLEAN NULL,
	separate_bath_and_toilet BOOLEAN NULL,
	separate_washbasin BOOLEAN NULL,
	air_conditioning BOOLEAN NULL,
	indoor_washing_machine_space BOOLEAN NULL,
	auto_lock BOOLEAN NULL,
	pets_are_negotiable BOOLEAN NULL,
	parking BOOLEAN NULL,
	delivery_box BOOLEAN NULL,
	warm_water_washing_toilet_seat BOOLEAN NULL,
	security_cameras BOOLEAN NULL,
	bathroom_dryer BOOLEAN NULL,
	room_features TEXT NULL,
	room_facilities_and_services TEXT NULL,
	kitchen_bathroom_and_toilet TEXT NULL,
	features_and_facilities_of_shared_spaces TEXT NULL,
	
	built_month_year  TEXT NULL,
	built_year INT NULL,
	built_month INT NULL,

	building_structure TEXT NULL,	
	insurance TEXT NULL,	
	transaction_type TEXT NULL,
	rent_guarantee_companies_etc  TEXT NULL,
	move_in_date  TEXT NULL,	

	property_inquiry_number TEXT NULL,	
	remarks TEXT NULL,	
	contract TEXT NULL,	
	registration_date TEXT NULL,	
	posting_expiration_date  TEXT NULL,	
	managed_by  TEXT NULL,
	
	agency_address TEXT NULL,	
	agency_opening_times TEXT NULL,	
	agency_phone_number	TEXT NULL, 
	agency_license_number TEXT NULL,

	created_by VARCHAR(30),
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_re_listings_gps ON re_listings USING GIST(ST_MakePoint(longitude, latitude));
CREATE INDEX idx_re_listings_source ON re_listings(source);
CREATE INDEX idx_re_listings_price ON re_listings(rent_price);
CREATE INDEX idx_re_listings_size ON re_listings(size_number);
CREATE INDEX idx_re_listings_address_kanji ON re_listings(address_kanji);

GRANT SELECT ON TABLE re_listings TO python;
GRANT SELECT ON TABLE re_listings TO gen;

GRANT INSERT ON TABLE re_listings TO python;
GRANT INSERT ON TABLE re_listings TO gen;