DROP TABLE IF EXISTS shapes;

-- Create the shapes table
CREATE TABLE shapes(
  key_code VARCHAR(30) NOT NULL, -- This is not unique because of islands
  pref INT NOT NULL,
  city INT NOT NULL,
  s_area VARCHAR(30),
  
  -- Address cols
  pref_name VARCHAR(10) NOT NULL,
  city_name VARCHAR(20) NULL,
  s_name VARCHAR(30) NULL,
  
  kigo_e VARCHAR(20) NULL,		-- When there are multiple shapes (ie, islands), this is filled
  hcode INT NULL,
  
  area FLOAT,
  perimeter FLOAT,
  
  r2kaxx INT,
  r2kaxx_id INT,
  kihon1 VARCHAR(10) NULL,
  dummy1 VARCHAR(10) NULL,
  kihon2 INT NULL,
  keycode1 VARCHAR(30) NULL,
  keycode2 VARCHAR(30) NULL,
  
  area_max_f VARCHAR(5) NULL,
  
  -- Always empty
  kigo_d VARCHAR(5) NULL,
  n_ken VARCHAR(5) NULL,
  n_city VARCHAR(5) NULL,
  kigo_i VARCHAR(5) NULL,
  kbsum INT NOT NULL,
  
  jinko INT NULL,
  setai INT NULL,
  x_code FLOAT,
  y_code FLOAT,
  
  kcode1 VARCHAR(10),
  geometry GEOMETRY NOT NULL,
  
  created_by VARCHAR(30),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE INDEX idx_shapes_key_code on shapes (key_code);
CREATE INDEX idx_shapes_address on shapes (city_name, s_name);
CREATE INDEX idx_shapes_gps ON shapes USING GIST(ST_MakePoint(x_code, y_code));
CREATE INDEX idx_shapes_geo ON shapes USING GIST(geometry);



GRANT SELECT ON TABLE shapes TO python;
GRANT SELECT ON TABLE shapes TO gen;

GRANT INSERT ON TABLE shapes TO python;
GRANT INSERT ON TABLE shapes TO gen;