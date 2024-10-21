'''
Created on Oct 8, 2024

@author: gen
'''
import pandas as pd
import geopandas as gpd
#from sqlalchemy import create_engine
from config import estat
from readwrite.writer.CsvWriter import CsvWriter

pd.set_option('display.max_columns', None)

gdf = gpd.read_file(estat.get_folderpath("29"))

print(gdf)

writer = CsvWriter("../29geom.csv")
writer.write_df(gdf)