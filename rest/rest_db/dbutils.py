'''
Created on Oct 16, 2024

@author: gen
'''

def default_json_serializer(obj):
    from datetime import datetime
    # Check if the object is a datetime instance and convert it to a string
    if isinstance(obj, (datetime)):
        return obj.isoformat()  # Convert to ISO 8601 string
    raise TypeError(f"Object of type {type(obj)} is not JSON serializable")

def convert_db_results_to_dict(cursor, results):
    if results is None or cursor is None: return None
    
    cols = [desc[0] for desc in cursor.description]
    dict_results = [dict(zip(cols, row)) for row in results]
    return dict_results




def run_query_from_file_and_return_dict(query_filename, params, connection_pool):
    connection  = connection_pool.getconn()
    try:
        # Open the connection and execute the query
        cursor = connection.cursor()
        with open(query_filename, 'r') as file:
            query = file.read()
        cursor.execute(query, params)
        
        # Get the results
        results = cursor.fetchall()
        dict_results = convert_db_results_to_dict(cursor, results)
        
        # Close the connection
        connection.commit()
        cursor.close()
    finally: 
        connection_pool.putconn(connection)
    
    return dict_results