from flask import Blueprint, request, jsonify, make_response, current_app
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

@mentors.route('/professional_page/<p_id>', methods=['GET'])
def get_professional_page(p_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Professional_Page WHERE p_id = ' + str(p_id))
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@mentors.route('/professional_page/<p_id>', methods=['PUT'])
def update_professional_page(p_id):
    cursor = db.get_db().cursor()

    # collecting data from the request object 
    updated_data = request.json
    current_app.logger.info(updated_data)

    # extracting variables
    phone = updated_data['Phone']
    email = updated_data['Email']

    # defines query
    query = '''
        UPDATE Professional_Page
        SET Phone = %s, Email = %s
        WHERE p_id = %s
    '''
    
    # executes query
    cursor.execute(query, (phone, email, p_id))
    db.get_db().commit()

    return 'Success!'

@mentors.route('/professional_page', methods=['POST'])
def create_professional_page():
    cursor = db.get_db().cursor()

    # Collecting data from the request object 
    new_data = request.json
    current_app.logger.info(new_data)

    # Extracting variables
    phone = new_data['Phone']
    email = new_data['Email']
    m_id = new_data['m_id']

    # Defines the INSERT query
    query = '''
        INSERT INTO Professional_Page (Phone, Email, m_id)
        VALUES (%s, %s, %s)
    '''

    cursor.execute(query, (phone, email, m_id))
    db.get_db().commit()

    return 'Success!'


@mentors.route('/schedule/<schedule_id>', methods=['GET'])
def get_schedule(schedule_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Schedule WHERE schedule_id = ' + str(schedule_id))
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


@mentors.route('/schedule/<schedule_id>', methods=['PUT'])
def update_schedule(schedule_id):
    cursor = db.get_db().cursor()

    # collecting data from the request object 
    updated_data = request.json
    current_app.logger.info(updated_data)

    # extracting variables
    event_type = updated_data['EventType']
    start_time = updated_data['StartTime']
    end_time = updated_data['EndTime']
    background = updated_data['Background']
    m_id = updated_data['m_id']

    # defines query
    query = '''
        UPDATE Schedule
        SET EventType = %s, StartTime = %s, EndTime = %s, Background = %s, m_id = %s
        WHERE schedule_id = %s
    '''
    
    # executes query
    cursor.execute(query, (event_type, start_time, end_time, background, m_id))
    db.get_db().commit()

    return 'Success!'


@mentors.route('/schedule', methods=['POST'])
def create_schedule():
    cursor = db.get_db().cursor()

    # collecting data from the request object 
    new_data = request.json
    current_app.logger.info(new_data)

    # extracting variables
    event_type = new_data['EventType']
    start_time = new_data['StartTime']
    end_time = new_data['EndTime']
    background = new_data['Background']
    m_id = new_data['m_id']

    # defines query with parameterized query
    query = '''
        INSERT INTO Schedule (EventType, StartTime, EndTime, Background, m_id)
        VALUES (%s, %s, %s, %s, %s)
    '''

    # executes query
    cursor.execute(query, (event_type, start_time, end_time, background, m_id))
    
    # commits changes to the database
    db.get_db().commit()

    return 'Success!'

@mentors.route('/mentoring_resource', methods=['GET'])
def get_mentoring_resources():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Mentoring_Resource')
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


@mentors.route('/mentoring_resource', methods=['POST'])
def upload_mentoring_resources():
    cursor = db.get_db().cursor()

    # collecting data from the request object 
    new_data = request.json
    current_app.logger.info(new_data)

    # extracting variables
    title = new_data['Title']
    content = new_data['Content']  # Content is optional
    formats = new_data['Format']    # Format is optional

    # Defines query
    query = '''
        INSERT INTO Mentoring_Resource (Title, Content, Format)
        VALUES (%s, %s, %s)
    '''

    # executes query
    cursor.execute(query, (title, content, formats))
    
    # commits changes to the database
    db.get_db().commit()

    return 'Success!'

@mentors.route('/mentoring_resource/<title>', methods=['PUT'])
def update_mentoring_resource(title):
    cursor = db.get_db().cursor()

    # collecting data from the request object 
    updated_data = request.json
    current_app.logger.info(updated_data)

    # extracting variables
    new_title = updated_data.get('Title', title)  # Assuming Title is not updated
    content = updated_data.get('Content')
    formats = updated_data.get('Format') 

    # Defines query
    query = '''
        UPDATE Mentoring_Resource
        SET Content = %s, Format = %s
        WHERE Title = %s
    '''

    # executes query
    cursor.execute(query, (content, formats, new_title))
    
    # commits changes to the database
    db.get_db().commit()

    return 'Success!'

@mentors.route('/mentoring_resource/<title>', methods=['DELETE'])
def update_mentoring_resource(title):
    cursor = db.get_db().cursor()

    # Define query
    query = '''
        DELETE FROM Mentoring_Resource
        WHERE Title = %s
    '''

    # Execute query
    cursor.execute(query, (title,))

    # Commit changes to the database
    db.get_db().commit()

    return 'Success!'

@mentors.route('/profile/<p_id>', methods=['GET'])
def get_profile(p_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Profile WHERE p_id =' + str(p_id) )
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@mentors.route('/profile/<int:p_id>', methods=['PUT'])
def update_profile(p_id):
    cursor = db.get_db().cursor()

    # collecting data from the request object 
    updated_data = request.json
    current_app.logger.info(updated_data)

    # extracting variables
    first_name = updated_data['FirstName']
    last_name = updated_data['LastName']
    phone = updated_data['Phone']
    email = updated_data['Email']
    background = updated_data['Background']

    # Defines query
    query = '''
        UPDATE Profile
        SET FirstName = %s, LastName = %s, Phone = %s, Email = %s, Background = %s
        WHERE p_id = %s
    '''

    # executes query
    cursor.execute(query, (first_name, last_name, phone, email, background, p_id))
    
    # commits changes to the database
    db.get_db().commit()

    return 'Success!'




