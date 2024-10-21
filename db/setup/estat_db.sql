-- Create the DB (with Japanese character use) and use it
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS postgis_topology; -- Optional, for topology features

-- Create the DB (with Japanese character use) and use it
-- This code has to be run seperately
CREATE DATABASE jp_estat_2020 
WITH ENCODING 'UTF8' 
LC_COLLATE 'ja_JP.utf8' 
LC_CTYPE 'ja_JP.utf8' 
TEMPLATE template0;
