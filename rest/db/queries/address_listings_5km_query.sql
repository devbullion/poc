-- Calculate distances first
WITH listing_distances AS (
	SELECT 
        -- Used for calcs
        num_seats * 250 * 4.5 as tgt_num_seats, --250 business days / 4.5 per day
        (pop_m_total_5km_weighted + pop_f_total_5km_weighted) AS total_weighted_pop,
        ABS(CAST(%(size)s AS numeric) - sq_m) / CAST(%(size)s AS numeric) AS abs_size_diff_norm, -- Replaced by size parameter
        ABS(CAST(%(px)s AS numeric) - price_per_sq_m) / CAST(%(px)s AS numeric) AS abs_price_per_sq_m_diff_norm, -- Replaced by px parameter

		* -- The rest of the cols, in case we need them
	FROM (
        SELECT
            -- These are used for calcs
            ROUND((v.sq_m - 15)/5) as num_seats, -- 15sq_m overhead, 5sq_m per seat
            ROUND(v.pop_m_total_5km * CAST(%(m)s AS numeric) * 0.025) AS pop_m_total_5km_weighted,  -- Replaced by the m parameter
            ROUND(v.pop_f_total_5km * (1 - CAST(%(m)s AS numeric)) * 0.025) AS pop_f_total_5km_weighted,  -- Replaced by the m parameter

        v.* -- The rest of the cols, in case we need them
        FROM 
            listings_pop_radius_view v
        WHERE 
            v.latitude = CAST(%(lat)s AS numeric) AND v.longitude = CAST(%(lon)s AS numeric)
  )
)

SELECT 
    source,
    property_inquiry_number,
    longitude, latitude,
    address, address_kanji,
    
    built_age, built_year, built_month,
    dist_to_sta_walk_time,
    dist_to_sta_other_mode,
    dist_to_sta_other_mode_time,
  
    price, sq_m, price_per_sq_m,
    num_seats, tgt_num_seats,
    total_weighted_pop,

    pop_score, 
    size_score,
    price_score,

    ROUND((
        (price_score * CAST(%(px_score_wt)s AS numeric)) + 
        (pop_score * CAST(%(pop_score_wt)s AS numeric)) + 
        (size_score * CAST(%(size_score_wt)s AS numeric))) *100) AS total_score

FROM (
    SELECT 
      -- Scores
      CASE
        WHEN total_weighted_pop >= tgt_num_seats THEN 1.0
        ELSE total_weighted_pop / tgt_num_seats
      END AS pop_score,

      CASE
        WHEN abs_size_diff_norm >= 1 THEN 0
        ELSE 1 - abs_size_diff_norm
      END AS size_score,

      CASE
        WHEN abs_price_per_sq_m_diff_norm >= 1 THEN 0
        ELSE 1 - abs_price_per_sq_m_diff_norm
      END AS price_score,

      * -- The rest of the columns, in case we need them
  FROM listing_distances
)
ORDER BY total_score DESC;