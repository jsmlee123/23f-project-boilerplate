from flask import Blueprint, request, jsonify, make_response
import json
from src import db


students = Blueprint('students', __name__)

@students.route('/students/<major>', methods=['GET'])
def get_students(major):
    cursor = db.get_db().cursor()
    cursor.execute('select * from Student where UPPER(Major)=UPPER(%s)', (major))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response