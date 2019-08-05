from flask import Flask, request, jsonify
from pymongo import MongoClient
import time
import json
from datetime import datetime, timedelta
import logging

app = Flask(__name__)

client = MongoClient('db:27017')
db = client.test_database


@app.route("/")
def hello():
    return "hello from flask"

@app.route("/ping")
def ping():
    return "pong"

if __name__ == "__main__":
    app.run()
