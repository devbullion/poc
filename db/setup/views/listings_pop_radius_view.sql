DROP MATERIALIZED VIEW IF EXISTS listings_pop_radius_view;

CREATE MATERIALIZED VIEW listings_pop_radius_view AS

WITH tmp_distances AS (
    SELECT 
        (l.rent_price / l.size_number) AS price_per_sq_m,
        ST_Distance(ST_MakePoint(l.longitude, l.latitude)::geography, ST_MakePoint(p.x_code, p.y_code)::geography) AS distance,
		l.*,
		p.*
    FROM
        re_listings l
    JOIN
        pop_and_shapes_view p
    ON
        ST_DWithin(
            ST_MakePoint(l.longitude, l.latitude)::geography,
            ST_MakePoint(p.x_code, p.y_code)::geography,
            10000 --10km (largest radius we consider now)
        )
)


SELECT 
	source,
    property_inquiry_number,
    address,
	address_kanji,
	longitude, latitude,
    rent_price as price,
    size_number as sq_m,
    
    price_per_sq_m,
	page_url,

	built_age,
	built_year,
	built_month,

	dist_to_sta_walk_time,
	dist_to_sta_other_mode,
	dist_to_sta_other_mode_time,
	transportation,

    
    -- 2km M
	SUM(CASE WHEN distance <= 2000 THEN pop_m_total ELSE 0 END) AS pop_m_total_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_m_total_0_4 ELSE 0 END) AS pop_m_total_0_4_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_m_total_5_9 ELSE 0 END) AS pop_m_total_5_9_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_m_total_10_14 ELSE 0 END) AS pop_m_total_10_14_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_m_total_15_19 ELSE 0 END) AS pop_m_total_15_19_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_m_total_20_24 ELSE 0 END) AS pop_m_total_20_24_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_m_total_25_29 ELSE 0 END) AS pop_m_total_25_29_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_m_total_30_34 ELSE 0 END) AS pop_m_total_30_34_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_m_total_35_39 ELSE 0 END) AS pop_m_total_35_39_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_m_total_40_44 ELSE 0 END) AS pop_m_total_40_44_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_m_total_45_49 ELSE 0 END) AS pop_m_total_45_49_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_m_total_50_54 ELSE 0 END) AS pop_m_total_50_54_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_m_total_55_59 ELSE 0 END) AS pop_m_total_55_59_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_m_total_60_64 ELSE 0 END) AS pop_m_total_60_64_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_m_total_65_69 ELSE 0 END) AS pop_m_total_65_69_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_m_total_70_74 ELSE 0 END) AS pop_m_total_70_74_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_m_total_0_14 ELSE 0 END) AS pop_m_total_0_14_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_m_total_15_64 ELSE 0 END) AS pop_m_total_15_64_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_m_total_65_ ELSE 0 END) AS pop_m_total_65__2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_m_total_75_ ELSE 0 END) AS pop_m_total_75__2km,
	
	-- 2km F
	SUM(CASE WHEN distance <= 2000 THEN pop_f_total ELSE 0 END) AS pop_f_total_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_f_total_0_4 ELSE 0 END) AS pop_f_total_0_4_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_f_total_5_9 ELSE 0 END) AS pop_f_total_5_9_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_f_total_10_14 ELSE 0 END) AS pop_f_total_10_14_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_f_total_15_19 ELSE 0 END) AS pop_f_total_15_19_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_f_total_20_24 ELSE 0 END) AS pop_f_total_20_24_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_f_total_25_29 ELSE 0 END) AS pop_f_total_25_29_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_f_total_30_34 ELSE 0 END) AS pop_f_total_30_34_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_f_total_35_39 ELSE 0 END) AS pop_f_total_35_39_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_f_total_40_44 ELSE 0 END) AS pop_f_total_40_44_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_f_total_45_49 ELSE 0 END) AS pop_f_total_45_49_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_f_total_50_54 ELSE 0 END) AS pop_f_total_50_54_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_f_total_55_59 ELSE 0 END) AS pop_f_total_55_59_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_f_total_60_64 ELSE 0 END) AS pop_f_total_60_64_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_f_total_65_69 ELSE 0 END) AS pop_f_total_65_69_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_f_total_70_74 ELSE 0 END) AS pop_f_total_70_74_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_f_total_0_14 ELSE 0 END) AS pop_f_total_0_14_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_f_total_15_64 ELSE 0 END) AS pop_f_total_15_64_2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_f_total_65_ ELSE 0 END) AS pop_f_total_65__2km,
	SUM(CASE WHEN distance <= 2000 THEN pop_f_total_75_ ELSE 0 END) AS pop_f_total_75__2km,
	
	-- 5km M
	SUM(CASE WHEN distance <= 5000 THEN pop_total ELSE 0 END) AS pop_total_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_m_total ELSE 0 END) AS pop_m_total_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_m_total_0_4 ELSE 0 END) AS pop_m_total_0_4_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_m_total_5_9 ELSE 0 END) AS pop_m_total_5_9_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_m_total_10_14 ELSE 0 END) AS pop_m_total_10_14_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_m_total_15_19 ELSE 0 END) AS pop_m_total_15_19_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_m_total_20_24 ELSE 0 END) AS pop_m_total_20_24_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_m_total_25_29 ELSE 0 END) AS pop_m_total_25_29_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_m_total_30_34 ELSE 0 END) AS pop_m_total_30_34_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_m_total_35_39 ELSE 0 END) AS pop_m_total_35_39_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_m_total_40_44 ELSE 0 END) AS pop_m_total_40_44_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_m_total_45_49 ELSE 0 END) AS pop_m_total_45_49_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_m_total_50_54 ELSE 0 END) AS pop_m_total_50_54_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_m_total_55_59 ELSE 0 END) AS pop_m_total_55_59_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_m_total_60_64 ELSE 0 END) AS pop_m_total_60_64_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_m_total_65_69 ELSE 0 END) AS pop_m_total_65_69_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_m_total_70_74 ELSE 0 END) AS pop_m_total_70_74_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_m_total_0_14 ELSE 0 END) AS pop_m_total_0_14_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_m_total_15_64 ELSE 0 END) AS pop_m_total_15_64_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_m_total_65_ ELSE 0 END) AS pop_m_total_65__5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_m_total_75_ ELSE 0 END) AS pop_m_total_75__5km,
	
	-- 5km F
	SUM(CASE WHEN distance <= 5000 THEN pop_f_total ELSE 0 END) AS pop_f_total_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_f_total_0_4 ELSE 0 END) AS pop_f_total_0_4_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_f_total_5_9 ELSE 0 END) AS pop_f_total_5_9_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_f_total_10_14 ELSE 0 END) AS pop_f_total_10_14_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_f_total_15_19 ELSE 0 END) AS pop_f_total_15_19_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_f_total_20_24 ELSE 0 END) AS pop_f_total_20_24_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_f_total_25_29 ELSE 0 END) AS pop_f_total_25_29_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_f_total_30_34 ELSE 0 END) AS pop_f_total_30_34_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_f_total_35_39 ELSE 0 END) AS pop_f_total_35_39_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_f_total_40_44 ELSE 0 END) AS pop_f_total_40_44_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_f_total_45_49 ELSE 0 END) AS pop_f_total_45_49_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_f_total_50_54 ELSE 0 END) AS pop_f_total_50_54_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_f_total_55_59 ELSE 0 END) AS pop_f_total_55_59_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_f_total_60_64 ELSE 0 END) AS pop_f_total_60_64_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_f_total_65_69 ELSE 0 END) AS pop_f_total_65_69_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_f_total_70_74 ELSE 0 END) AS pop_f_total_70_74_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_f_total_0_14 ELSE 0 END) AS pop_f_total_0_14_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_f_total_15_64 ELSE 0 END) AS pop_f_total_15_64_5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_f_total_65_ ELSE 0 END) AS pop_f_total_65__5km,
	SUM(CASE WHEN distance <= 5000 THEN pop_f_total_75_ ELSE 0 END) AS pop_f_total_75__5km,
	
	-- 10km M
	SUM(CASE WHEN distance <= 10000 THEN pop_total ELSE 0 END) AS pop_total_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_m_total ELSE 0 END) AS pop_m_total_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_m_total_0_4 ELSE 0 END) AS pop_m_total_0_4_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_m_total_5_9 ELSE 0 END) AS pop_m_total_5_9_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_m_total_10_14 ELSE 0 END) AS pop_m_total_10_14_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_m_total_15_19 ELSE 0 END) AS pop_m_total_15_19_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_m_total_20_24 ELSE 0 END) AS pop_m_total_20_24_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_m_total_25_29 ELSE 0 END) AS pop_m_total_25_29_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_m_total_30_34 ELSE 0 END) AS pop_m_total_30_34_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_m_total_35_39 ELSE 0 END) AS pop_m_total_35_39_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_m_total_40_44 ELSE 0 END) AS pop_m_total_40_44_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_m_total_45_49 ELSE 0 END) AS pop_m_total_45_49_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_m_total_50_54 ELSE 0 END) AS pop_m_total_50_54_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_m_total_55_59 ELSE 0 END) AS pop_m_total_55_59_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_m_total_60_64 ELSE 0 END) AS pop_m_total_60_64_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_m_total_65_69 ELSE 0 END) AS pop_m_total_65_69_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_m_total_70_74 ELSE 0 END) AS pop_m_total_70_74_10km,
	
	SUM(CASE WHEN distance <= 10000 THEN pop_m_total_0_14 ELSE 0 END) AS pop_m_total_0_14_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_m_total_15_64 ELSE 0 END) AS pop_m_total_15_64_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_m_total_65_ ELSE 0 END) AS pop_m_total_65__10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_m_total_75_ ELSE 0 END) AS pop_m_total_75__10km,
	
    -- 10km F
    SUM(CASE WHEN distance <= 10000 THEN pop_f_total ELSE 0 END) AS pop_f_total_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_f_total_0_4 ELSE 0 END) AS pop_f_total_0_4_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_f_total_5_9 ELSE 0 END) AS pop_f_total_5_9_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_f_total_10_14 ELSE 0 END) AS pop_f_total_10_14_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_f_total_15_19 ELSE 0 END) AS pop_f_total_15_19_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_f_total_20_24 ELSE 0 END) AS pop_f_total_20_24_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_f_total_25_29 ELSE 0 END) AS pop_f_total_25_29_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_f_total_30_34 ELSE 0 END) AS pop_f_total_30_34_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_f_total_35_39 ELSE 0 END) AS pop_f_total_35_39_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_f_total_40_44 ELSE 0 END) AS pop_f_total_40_44_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_f_total_45_49 ELSE 0 END) AS pop_f_total_45_49_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_f_total_50_54 ELSE 0 END) AS pop_f_total_50_54_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_f_total_55_59 ELSE 0 END) AS pop_f_total_55_59_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_f_total_60_64 ELSE 0 END) AS pop_f_total_60_64_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_f_total_65_69 ELSE 0 END) AS pop_f_total_65_69_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_f_total_70_74 ELSE 0 END) AS pop_f_total_70_74_10km,
	
	SUM(CASE WHEN distance <= 10000 THEN pop_f_total_0_14 ELSE 0 END) AS pop_f_total_0_14_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_f_total_15_64 ELSE 0 END) AS pop_f_total_15_64_10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_f_total_65_ ELSE 0 END) AS pop_f_total_65__10km,
	SUM(CASE WHEN distance <= 10000 THEN pop_f_total_75_ ELSE 0 END) AS pop_f_total_75__10km
	
FROM tmp_distances
GROUP BY 
	source,
	property_inquiry_number,
	address, address_kanji,
	longitude, latitude,
	rent_price,
	size_number,
	
	price_per_sq_m,
	page_url,

	built_age,
	built_year,
	built_month,
	
	dist_to_sta_walk_time,
	dist_to_sta_other_mode,
	dist_to_sta_other_mode_time,
	transportation;
    
GRANT SELECT ON listings_pop_radius_view TO python;
GRANT SELECT ON listings_pop_radius_view TO gen;