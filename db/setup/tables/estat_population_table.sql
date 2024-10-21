-- PostGre!!
DROP TABLE IF EXISTS population;

-- Create the population table
CREATE TABLE population(
  pref_code INT NOT NULL,               -- This is derived from the filename
  key_code VARCHAR(30) NOT NULL UNIQUE, -- We have to make this a varchar since we are unsure how many digits this could become
  hyoso INT,
  cityname VARCHAR(10),
  name VARCHAR(20) NULL,
  htksyori INT NULL,
  htksaki INT NULL,
  gassan VARCHAR(30) NULL,

  -- Total Population cols
  pop_total int NULL,
  pop_total_0_4 INT NULL,
  pop_total_5_9 INT NULL,
  pop_total_10_14 INT NULL,
  pop_total_15_19 INT NULL,
  pop_total_20_24 INT NULL,
  pop_total_25_29 INT NULL,
  pop_total_30_34 INT NULL,
  pop_total_35_39 INT NULL,
  pop_total_40_44 INT NULL,
  pop_total_45_49 INT NULL,
  pop_total_50_54 INT NULL,
  pop_total_55_59 INT NULL,
  pop_total_60_64 INT NULL,
  pop_total_65_69 INT NULL,
  pop_total_70_74 INT NULL,
  
  pop_total_0_14 INT NULL,
  pop_total_15_64 INT NULL,
  pop_total_65_ INT NULL,
  pop_total_75_ INT NULL,

  -- Male Population totals
  pop_m_total INT NULL,
  pop_m_total_0_4 INT NULL,
  pop_m_total_5_9 INT NULL,
  pop_m_total_10_14 INT NULL,
  pop_m_total_15_19 INT NULL,
  pop_m_total_20_24 INT NULL,
  pop_m_total_25_29 INT NULL,
  pop_m_total_30_34 INT NULL,
  pop_m_total_35_39 INT NULL,
  pop_m_total_40_44 INT NULL,
  pop_m_total_45_49 INT NULL,
  pop_m_total_50_54 INT NULL,
  pop_m_total_55_59 INT NULL,
  pop_m_total_60_64 INT NULL,
  pop_m_total_65_69 INT NULL,
  pop_m_total_70_74 INT NULL,

  pop_m_total_0_14 INT NULL,
  pop_m_total_15_64 INT NULL,
  pop_m_total_65_ INT NULL,
  pop_m_total_75_ INT NULL,

  -- Female Population totals
  pop_f_total INT NULL,
  pop_f_total_0_4 INT NULL,
  pop_f_total_5_9 INT NULL,
  pop_f_total_10_14 INT NULL,
  pop_f_total_15_19 INT NULL,
  pop_f_total_20_24 INT NULL,
  pop_f_total_25_29 INT NULL,
  pop_f_total_30_34 INT NULL,
  pop_f_total_35_39 INT NULL,
  pop_f_total_40_44 INT NULL,
  pop_f_total_45_49 INT NULL,
  pop_f_total_50_54 INT NULL,
  pop_f_total_55_59 INT NULL,
  pop_f_total_60_64 INT NULL,
  pop_f_total_65_69 INT NULL,
  pop_f_total_70_74 INT NULL,

  pop_f_total_0_14 INT NULL,
  pop_f_total_15_64 INT NULL,
  pop_f_total_65_ INT NULL,
  pop_f_total_75_ INT NULL,

  created_by VARCHAR(30),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_key_code on population (key_code);

GRANT SELECT ON TABLE population TO python;
GRANT SELECT ON TABLE population TO gen;

GRANT INSERT ON TABLE population TO python;
GRANT INSERT ON TABLE population TO gen;