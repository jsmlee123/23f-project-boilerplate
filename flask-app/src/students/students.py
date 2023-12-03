from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


students = Blueprint('students', __name__)

# (Notes: can also be a dropdown in UI - Modify later)
# Get student details for students with a particular major [Stella-1]
@students.route('/students/<string:major>', methods=['GET'])
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

@students.route('/students/<int:id>', methods=['GET'])
def get_student_by_id(id):
    cursor = db.get_db().cursor()
    cursor.execute('select * from Student where s_id=%s', (id))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# [GET] Return a list of all mentors that are part of the specified specialization [Jane-1] [Alex-1]
# (Notes: SHOULD modify to become a dropdown in AppSmith) Watch Lec17_	
	# Modify New Product -> Capture Category
	# 	Dropdown widget = SELECT widget in AppSmith
	# 	"label" being displayed
	# 	"value" sent to the backend
	# (add a route)
	# query ... SELECT DISTINCT category As label, category as value 
	# 	  FROM products
	# 	  WHERE ...
@students.route('/mentors/<specialization>', methods=['GET'])
def get_mentor_specialization(specialization):
    query = 'SELECT * FROM Mentor WHERE UPPER(Specialization)=UPPER(' + str(id) + ')'
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    
    return jsonify(json_data)



# [GET] a list of all soft skill resources. [Alex-3] [Jane-4]
@students.route('/soft_skill_resources', methods=['GET'])
def get_softskill_resources():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Soft_Skill_Resource')
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return ""

#ALEX - PERSONA 1 (5)
# [GET] Return all detailed information for a specific profile [Alex-2]
@students.route('profile/<int:p_id>')
def get_profile_detail (p_id): 
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Profile WHERE p_id = %s', (p_id,))
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    if not the_data:
        return jsonify({"error": "Profile not found"}), 404
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)

# [GET] Return a singular soft skill resource [Alex-4]
@students.route('/soft_skill_resource/<title>', methods=['GET'])
def get_soft_skill_resource(title):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Soft_Skill_Resource WHERE Title = %s', (title,))
    column_headers = [x[0] for x in cursor.description]
    the_data = cursor.fetchone()
    if not the_data:
        return jsonify({"error": "Soft skill resource not found"}), 404
    json_data = dict(zip(column_headers, the_data))
    return jsonify(json_data)

# [DELETE] Deletes this soft_skill_resource [Alex-4]
@students.route('/soft_skill_resource/<title>', methods=['DELETE'])
def delete_soft_skill_resource(title):
    cursor = db.get_db().cursor()

    # First check if the resource exists
    cursor.execute('SELECT * FROM Soft_Skill_Resource WHERE Title = %s', (title,))
    resource = cursor.fetchone()
    if not resource:
        return jsonify({"error": "Soft skill resource not found"}), 404

    # Execute the delete operation
    cursor.execute('DELETE FROM Soft_Skill_Resource WHERE Title = %s', (title,))
    db.get_db().commit()

    if cursor.rowcount == 0:
        return jsonify({"error": "Deletion failed"}), 500

    return jsonify({"success": True, "message": "Soft skill resource deleted successfully"}), 200

# [GET] Return a list of all interviewing resources [Alex-4]
@students.route('/interview_resources', methods=['GET'])
def get_interview_resources():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Interview_Resource')
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)

# [GET] Returns a specific interview resource [Alex-4]
@students.route('/interview_resource/<title>', methods=['GET'])
def get_interview_resource(title):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT Title, Content, Format FROM Interview_Resource WHERE Title = %s', (title,))
    column_headers = [x[0] for x in cursor.description]
    theData = cursor.fetchone()
    if not theData:
        return jsonify({"error": "Interview resource not found"}), 404
    json_data = dict(zip(column_headers, theData))
    return jsonify(json_data)

# [DELETE] Deletes a specific interview resource [Alex-4]
@students.route('/interview_resource/<title>', methods=['DELETE'])
def delete_interview_resource(title):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Interview_Resource WHERE Title = %s', (title,))
    resource = cursor.fetchone()
    if not resource:
        return jsonify({"error": "Interview resource not found"}), 404
    cursor.execute('DELETE FROM Interview_Resource WHERE Title = %s', (title,))
    db.get_db().commit()
    if cursor.rowcount == 0:
        return jsonify({"error": "Deletion failed"}), 500
    return jsonify({"success": True, "message": "Interview resource deleted successfully"}), 200

# [GET] Return the type of industry that the company is in. [Alex-2]
@students.route('/company_industry/<company_name>', methods=['GET'])
def get_company_industry(company_name):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT Industry FROM Work WHERE CompanyName = %s', (company_name,))
    column_headers = [x[0] for x in cursor.description]
    theData = cursor.fetchone()
    if not theData:
        return jsonify({"error": "Company not found"}), 404
    json_data = dict(zip(column_headers, theData))
    return jsonify(json_data)

# [GET] Return the ranking of the college and application requirements [Alex-5]
@students.route('/college_info/<college_name>', methods=['GET'])
def get_college_info(college_name):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT Ranking, AppReqs FROM College WHERE College_Name = %s', (college_name,))
    column_headers = [x[0] for x in cursor.description]
    theData = cursor.fetchone()
    if not theData:
        return jsonify({"error": "College not found"}), 404
    json_data = dict(zip(column_headers, theData))
    return jsonify(json_data)

# [GET] Return all detailed information for a  particular mentor.  [Alex-2]
@students.route('/professional_page/<int:p_id>', methods=['GET'])
def get_professional_page(p_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Professional_Page WHERE p_id = %s', (p_id,))
    column_headers = [x[0] for x in cursor.description]
    theData = cursor.fetchone()
    if not theData:
        return jsonify({"error": "Professional page not found"}), 404
    json_data = dict(zip(column_headers, theData))
    return jsonify(json_data)

#JANE - PERSONA 2 (5)
# [PUT] Update certain attributes of a profile [Jane-2]
@students.route('/profile/<int:p_id>', methods=['PUT'])
def update_profile(p_id):
    data = request.json
    update_data = []
    query_parameters = []

    if 'FirstName' in data:
        update_data.append("FirstName = %s")
        query_parameters.append(data['FirstName'])
    if 'LastName' in data:
        update_data.append("LastName = %s")
        query_parameters.append(data['LastName'])
    if 'Email' in data:
        update_data.append("Email = %s")
        query_parameters.append(data['Email'])
    if 'Phone' in data:
        update_data.append("Phone = %s")
        query_parameters.append(data['Phone'])
    if 'Background' in data:
        update_data.append("Background = %s")
        query_parameters.append(data['Background'])

    if not update_data:
        return jsonify({"error": "No data provided for update"}), 400

    query = "UPDATE Profile SET " + ", ".join(update_data) + " WHERE p_id = %s"
    query_parameters.append(p_id)

    cursor = db.get_db().cursor()
    cursor.execute(query, tuple(query_parameters))
    db.get_db().commit()

    if cursor.rowcount == 0:
        return jsonify({"error": "Update failed or no changes made"}), 500

    return jsonify({"success": True, "message": "Profile updated successfully"}), 200


# [GET] Return a list of labs at the specified college [Jane-3]
@students.route('/labs/<college_name>', methods=['GET'])
def get_labs_at_college(college_name):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Lab WHERE College_Name = %s', (college_name,))
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)


# [POST] Uploads a new lab to the college [Jane-3]
@students.route('/add_lab', methods=['POST'])
def add_lab():
    # Collecting data from the request object 
    lab_data = request.json
    current_app.logger.info(lab_data)

    # Extracting variables from the data
    lab_name = lab_data['Lab_Name']
    lab_type = lab_data['LabType']
    college_name = lab_data['College_Name']

    # Constructing the query
    query = 'INSERT INTO Lab (Lab_Name, LabType, College_Name) VALUES ("' 
    query += lab_name + '", "'
    query += lab_type + '", "'
    query += college_name + '")'
    current_app.logger.info(query)

    # Executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'


# [GET] Return a list of all students that are linked to specified student [Jane-5]
@students.route('/network/<int:s_id>', methods=['GET'])
def get_student_network(s_id):
    cursor = db.get_db().cursor()
    # Use cursor to query the database for all students linked to the specified student
    cursor.execute('SELECT s2.* FROM Student AS s1 JOIN Network ON s1.s_id = Network.s_id JOIN Student AS s2 ON Network.connection = s2.s_id WHERE s1.s_id = %s', (s_id,))
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)


# [PUT] Update the list of colleagues for a specific student[Jane-5]
@students.route('/network/<int:s_id>', methods=['PUT'])
def update_network(s_id):
    data = request.json
    new_connections = data['colleagues']
    # Validate the data
    if not isinstance(new_connections, list):
        return jsonify({"error": "Invalid data format. 'colleagues' should be a list."}), 400
    cursor = db.get_db().cursor()
    # Clear existing connections
    cursor.execute('DELETE FROM Network WHERE s_id = %s', (s_id,))
    # Insert new connections
    for colleague_id in new_connections:
        cursor.execute('INSERT INTO Network (s_id, connection) VALUES (%s, %s)', (s_id, colleague_id))
    db.get_db().commit()
    return jsonify({"success": True, "message": "Network updated successfully"}), 200

# [DELETE] Deletes this student from the network [Jane-5]
@students.route('/network/<int:s_id>', methods=['DELETE'])
def delete_student_from_network(s_id):
    cursor = db.get_db().cursor()

    # Delete all connections where this student is either the source or the target
    cursor.execute('DELETE FROM Network WHERE s_id = %s OR connection = %s', (s_id, s_id))

    db.get_db().commit()

    return jsonify({"success": True, "message": "Student removed from network successfully"}), 200 