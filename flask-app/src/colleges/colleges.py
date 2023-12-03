from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


colleges = Blueprint('colleges', __name__)

@colleges.route('/college/<college_name>', methods=['GET'])
def get_college(college_name):
    cursor = db.get_db().cursor()
    cursor.execute('select * from College where College_Name=%s', (college_name))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# I think the route should be /college and not /college/<college_name>
@colleges.route('/college', methods=['POST'])
def add_new_college():
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    name = the_data['college_name']
    ranking = the_data['ranking']
    appreqs = the_data['appreqs']

    # Constructing the query
    query = 'insert into College (College_Name, Ranking, AppReqs) values ("'
    query += name + '", "'
    query += ranking + '", "'
    query += str(appreqs) + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'

@colleges.route('/college/<college_name>', methods=['PUT'])
def update_college(college_name):
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    name = college_name
    ranking = the_data['ranking']
    appreqs = the_data['appreqs']

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    # Execute the UPDATE query
    cursor.execute("UPDATE College SET Ranking = %s, SET AppReqs = %s, WHERE College_Name = %s", (ranking, appreqs, name))
    db.get_db().commit()
    
    return 'Success!'

@colleges.route('/labs/<college_name>', methods=['GET'])
def get_labs(college_name):
    cursor = db.get_db().cursor()
    cursor.execute('select * from Lab where College_Name=%s', (college_name))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


@colleges.route('/labs/<college_name>', methods=['POST'])
def add_new_lab(college_name):
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    lab_name = the_data['lab_name']
    lab_type = the_data['lab_type']

    # Constructing the query
    query = 'insert into Lab (Lab_Name, LabType, College_Name) values ("'
    query += lab_name + '", "'
    query += lab_type + '", "'
    query += college_name + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'

@colleges.route('/labs/<lab_name>', methods=['DELETE'])
def delete_lab(lab_name):

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute("DELETE FROM College WHERE Lab_Name = %s", (lab_name))
    db.get_db().commit()
    
    return 'Success!'