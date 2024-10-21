# '''
# Created on Oct 9, 2024
#
# Quick and dirty script to get estat geometry files into our database
#
# @author: gen
# '''
# import pandas as pd
# import geopandas as gpd
# import psycopg2
# from shapely.geometry import Polygon
#
#
# pd.set_option('display.max_columns', None)
#
#
#
# def convert_to_wkt(polygon_coords):
#     polygon = Polygon(polygon_coords)
#     return polygon.wkt
#
#
#
#
# print("getting the file")
# #gdf = gpd.read_file(estat.get_folderpath("29")).head(20)
#
#
# connection = psycopg2.connect(
#     host="35.243.96.1", 
#     dbname="jp_estat_2020",
#     user="python", 
#     password="pythondevbullion"
# )
# cursor = connection.cursor()
#
#
# # The Insert part of the query
# insert_str = "INSERT INTO shapes ("
# for col_name in  gdf.columns:
#     insert_str = insert_str + col_name.lower() +", "
# insert_str = insert_str + "created_by)\n"
# print(insert_str)
#
#
#
# for idx, row in gdf.iterrows():
#     # Create the values part of the query for the row
#     values_str = "VALUES ("
#     for col_name in gdf.columns:
#         val = row[col_name]
#         if pd.isna(val) or val =='-':
#             val = "NULL"
#         elif col_name in ['KEY_CODE', 'S_AREA', 'PREF_NAME', "CITY_NAME", "S_NAME", "KIGO_E", "KIHON1", "DUMMY1", "KEYCODE1", "KEYCODE2", "AREA_MAX_F", "KIGO_D", "N_KEN", "N_CITY", "KIGO_I", "KCODE1"]:
#             val = f"'{val}'"
#         elif col_name =='geometry':
#             val = f"ST_GeomFromText('{val}')"
#
#         values_str = values_str + f"{val}, "
#     values_str = values_str + "CURRENT_USER);"
#
#     insert_query = insert_str + values_str
#
#     #print(f"{idx}: {insert_query}")
#     if idx % 100 == 0 and idx > 0: print(f"Done with {idx} rows")
#     cursor.execute(insert_query)
#
# print("Finished, closing")
# connection.commit()
# cursor.close()
# connection.close()