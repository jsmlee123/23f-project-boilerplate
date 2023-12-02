from flask import Blueprint, request, jsonify, make_response
import json
from src import db


mentors = Blueprint('mentors', __name__)

@mentors.route('/mentors/<specialization>', methods=['GET'])
def get_mentors(specialization):
    cursor = db.get_db().cursor()
    cursor.execute('select * from Mentor where UPPER(Specialization)=UPPER(%s)', (specialization))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response