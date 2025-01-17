DROP MATERIALIZED VIEW IF EXISTS pop_and_shapes_view;

CREATE MATERIALIZED VIEW pop_and_shapes_view AS
SELECT
	pc.pref_name,
	(pc.pref_name || p.cityname || p.name) AS address_chome,
	p.*,
	
	-- shapes columns below
	s.kigo_e,
	s.area,
	s.perimeter,
	
	s.area_max_f,
	
	s.x_code, s.y_code,
	s.geometry
	
FROM population p 
JOIN shapes s 
	ON s.key_code = p.key_code
	-- Shapes has several rows for the same keycode! (islands)
	-- So shapes needs to be the left!
JOIN pref_codes pc
	ON pc.pref_code = p.pref_code
;

CREATE INDEX idx_address_shapes on pop_and_shapes_view (address_chome);

GRANT SELECT ON pop_and_shapes_view TO python;
GRANT SELECT ON pop_and_shapes_view TO gen;