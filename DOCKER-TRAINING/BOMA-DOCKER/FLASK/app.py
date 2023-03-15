from flask import flask

app = Flask(_name_)

@app.route('/')
def response():
    return "Hello world from python flask"

if _name_ == '_main_':
    app.run(host='0.0.0.0', port=80)