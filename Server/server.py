from flask import Flask, request
from pymongo import MongoClient
import json
from bson import ObjectId
from bson.json_util import dumps


app = Flask(__name__)

mongo = MongoClient('localhost', 27017)

app.db = mongo.MSCompanion

class NewJSONEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, ObjectId):
            return str(o)
        return json.JSONEncoder.default(self, o)

@app.route('/students', methods=['GET'])
def student_route():
    students_path = app.db.students
    student = students_path.find({"firstName": "Duncan"})

    json_ = dumps(student)

    return json_, 200, None

if __name__ == '__main__':
    app.config['TRAP_BAD_REQUEST_ERRORS'] = True
    app.run(debug=True)
