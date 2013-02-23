'''
A simple flask script to print the
request info. useful for dubugging your
rest client.

dhilipsiva@gmail.com

'''
from flask import Flask, request

app = Flask(__name__)


@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def hello(path):
    app.logger.debug(path)
    app.logger.debug(request.headers)
    app.logger.debug(request.args)
    app.logger.debug(request.form)
    return 'hello'


if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=8888,
        debug=True)
