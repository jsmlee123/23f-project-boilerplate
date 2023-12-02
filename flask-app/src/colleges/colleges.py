from flask import Blueprint, request, jsonify, make_response
import json
from src import db


colleges = Blueprint('colleges', __name__)

@colleges.route('/colleges/<college_name>', methods=['GET'])
def get_mentors(college_name):
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