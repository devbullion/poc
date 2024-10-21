-- This is just junk data to test out some things
DELETE FROM re_listings;
INSERT INTO re_listings (
	listing_id,
	add_pref_name, add_city_name, add_street_name,
	lat, lon,
	price, sq_m,
	created_by
)
VALUES
('1', '奈良県', '奈良市', '三条宮前町', 34.6794715, 135.81958, 300000, 30.8, CURRENT_USER),
('2', '奈良県', '奈良市', '三条宮本町', 34.6803007, 135.8154565, 500000, 62.9, CURRENT_USER),
('3', '奈良県', '奈良市', '大宮町', 34.683260, 135.813083, 520000, 60.0, CURRENT_USER);
