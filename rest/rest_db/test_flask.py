'''
Created on Oct 16, 2024

@author: gen
'''

from psycopg2 import pool
from flask import Flask, request, jsonify
from flask_cors import CORS, cross_origin
import dbutils

app = Flask(__name__)
CORS(app)
print(f"NAME: {__name__}")

host="35.243.96.1"
dbname="jp_estat_2020"
user="python"
password="pythondevbullion"

connection_string = (
    f"host='{host}' "
    f"dbname='{dbname}' "
    f"user='{user}' "
    f"password='{password}' "
    "port='5432'"  # Default port for PostgreSQL
)
connection_pool = pool.SimpleConnectionPool(
    minconn=1,
    maxconn=10,
    dsn=connection_string
)


btype_dict = {
    'beauty':{
        'pop_radius': 10,
        'pop_score_wt': 0.30,
        'size_score_wt': 0.30,
        'px_score_wt': 0.40
    },
    
    'gym':{
        'pop_radius': 2,
        'pop_score_wt': 0.50,
        'size_score_wt': 0.40,
        'px_score_wt': 0.10
    }
}



@app.get("/listings")
@cross_origin()
def get_listings():
    # The parameters have to be in this specific order to fit the SQL code
    b_type = request.args.get('btype')
    params = { param: request.args.get(param) for param in ['lon', 'lat', 'dist', 'm', 'size', 'px'] } | btype_dict[b_type]
    
    # Run the SQL code to get the results
    dict_results = dbutils.run_query_from_file_and_return_dict(
        f"queries/gps_listings_{b_type}_query.sql", 
        params,
        connection_pool
    )
    
    return jsonify(dict_results)



