'''
Created on Oct 16, 2024

@author: gen
'''

import psycopg2
from rest.rest_db import dbutils 
connection = psycopg2.connect(
    host="35.243.96.1", 
    dbname="jp_estat_2020",
    user="python", 
    password="pythondevbullion"
)

dict_results = dbutils.run_query_from_file_and_return_dict("queries/population_query.sql", connection)
print(dict_results)




from geopy.geocoders import GoogleV3
geolocator = GoogleV3(api_key="YOUR_API_KEY")

def location_str_to_gps(location_str):
    return geolocator.geocode(location_str)





# import requests
#
# # GET
# api_url = "https://jsonplaceholder.typicode.com/todos/1"
# response = requests.get(api_url)
# print(response.json())
# print(response.status_code)
# print(response.headers["Content-Type"])
# print()
#
# # POST
# api_url = "https://jsonplaceholder.typicode.com/todos"
# todo = {"userId": 1, "title": "Buy milk", "completed": False}
# response = requests.post(api_url, json=todo)
# print(response.json())
# print(response.status_code)
# print(response.headers["Content-Type"])
# print()
#
# # PUT
# api_url = "https://jsonplaceholder.typicode.com/todos/10"
# response = requests.get(api_url)
# print(response.json())
# print(response.status_code)
# print(response.headers["Content-Type"])
# print()
# todo = {"userId": 1, "title": "Wash car", "completed": True}
# response = requests.put(api_url, json=todo)
# print(response.json())
# print(response.status_code)
# print(response.headers["Content-Type"])
# print()