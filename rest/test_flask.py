'''
Created on Oct 16, 2024

@author: gen
'''

from psycopg2 import pool
from flask import Flask, request, jsonify
from flask_cors import CORS, cross_origin
from db import dbutils
import os
import logging

app = Flask(__name__)
CORS(app)
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)
app.logger.handlers = logger.handlers
app.logger.setLevel(logger.level)

logger.info(f"NAME: {__name__}")

host="10.26.208.4" # Private IP of the PostgreSQL server
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
        'px_score_wt': 0.40,

        'business_days': 250, # number of days open
        'target_clients_per_day': 4.5, # number of clients per day
    },
    
    'gym':{
        'pop_radius': 2,
        'pop_score_wt': 0.50,
        'size_score_wt': 0.40,
        'px_score_wt': 0.10,

        'business_days': 200, # number of days open (A gym is usually open 350 days, but there is a lot of overlap with members)
        'target_clients_per_day': 1, # number of clients per day (A gym is usually open 350 days, but there is a lot of overlap with members)
    }
}



@app.get("/listings")
@cross_origin()
def get_listings():
    b_type = request.args.get('btype')
    params = { param: request.args.get(param) for param in ['lon', 'lat', 'dist', 'm', 'size', 'px'] } | btype_dict[b_type]
    pop_radius = str(btype_dict[b_type]['pop_radius'])+'km'
    query_file = f"db/queries/gps_listings_{pop_radius}_query.sql"

    logger.info(f"Business type: {b_type}")
    logger.info(f"Using query file: {query_file}")
    logger.info(f"Parameters: {params}")

    # Run the SQL code to get the results
    dict_results = dbutils.run_query_from_file_and_return_dict(
        query_file, 
        params,
        connection_pool
    )
    
    return jsonify(dict_results)

@app.get("/address")
def get_address_listings():
    '''
    Get all the listings for a specific address (lat/lon)
    We need to pass in the other args to calc the score
    '''
    b_type = request.args.get('btype')
    params = {param: request.args.get(param) for param in ['lon', 'lat', 'm', 'size', 'px']} | btype_dict[b_type]

    pop_radius = str(btype_dict[b_type]['pop_radius'])+'km'
    query_file = f"db/queries/address_listings_{pop_radius}_query.sql"

    dict_results = dbutils.run_query_from_file_and_return_dict(
        query_file, 
        params,
        connection_pool
    )
    return jsonify(dict_results)

@app.get("/listing")
def get_listing():
    '''
    Get the details of a specific listing
    '''
    b_type = request.args.get('btype')
    params = {param: request.args.get(param) for param in ['m', 'size', 'px', 'id']} | btype_dict[b_type]
    
    pop_radius = str(btype_dict[b_type]['pop_radius'])+'km'
    query_file = f"db/queries/addrelisting_detail_{pop_radius}_query.sql"

    dict_results = dbutils.run_query_from_file_and_return_dict(
        query_file, 
        params,
        connection_pool
    )
    return jsonify(dict_results)

if __name__ == "__main__":
    # Use the PORT environment variable or default to 8080
    port = int(os.environ.get("PORT", 8080))
    app.run(host='0.0.0.0', port=port)