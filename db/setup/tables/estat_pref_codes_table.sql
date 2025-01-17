DROP TABLE IF EXISTS pref_codes;

-- Create the pref_codes table
CREATE TABLE pref_codes(
  pref_code INT NOT NULL UNIQUE,
  pref_name VARCHAR(10) NOT NULL,

  created_by VARCHAR(30),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_pref_code on pref_codes (pref_code);

GRANT SELECT ON TABLE pref_codes TO python;
GRANT SELECT ON TABLE pref_codes TO gen;

GRANT INSERT ON TABLE pref_codes TO python;
GRANT INSERT ON TABLE pref_codes TO gen;