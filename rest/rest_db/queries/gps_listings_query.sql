-- Calculate distances first
WITH listing_distances AS (
	SELECT 
		ST_Distance(
			ST_MakePoint(%s, %s)::geography, -- These will be replaced by the parameters from the call (lon, lat)
			ST_MakePoint(l.lon, l.lat)::geography
		) AS distance,
		l.*
	FROM
		listings_pop_radius_view l
)

-- Filter by the distances
-- Returns a list of listings within the specific radius
SELECT 
	listing_id,
	distance,
  	lon, lat,
  	add_pref_name, add_city_name, add_street_name,

  	price, sq_m, price_per_sq_m,
  	
FROM 
	listing_distances 
WHERE 
	distance <= %s; --The dist parameter