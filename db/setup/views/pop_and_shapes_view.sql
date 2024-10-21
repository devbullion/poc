DROP MATERIALIZED VIEW IF EXISTS pop_and_shapes_view;

CREATE MATERIALIZED VIEW pop_and_shapes_view AS
SELECT
	p.*,
	
	-- shapes columns below
	s.kigo_e,
	s.area,
	s.perimeter,
	
	s.area_max_f,
	
	s.x_code, s.y_code,
	s.geometry
	
FROM population p JOIN shapes s 
	-- Shapes has several rows for the same keycode! (islands)
	-- So shapes needs to be the left!
	ON s.key_code = p.key_code;

GRANT SELECT ON pop_and_shapes_view TO python;
GRANT SELECT ON pop_and_shapes_view TO gen;