COPY shapes (key_code, pref, city, s_area, pref_name, city_name, s_name, kigo_e, hcode, area, perimeter, r2kaxx, r2kaxx_id, kihon1, dummy1, kihon2, keycode1, keycode2, area_max_f, kigo_d, n_ken, n_city, kigo_i, kbsum, jinko, setai, x_code, y_code, kcode1, geom, created_by)
FROM 'gs://your_bucket/data.csv'
DELIMITER ','
CSV HEADER;
