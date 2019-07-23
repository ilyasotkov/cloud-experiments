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
    return "Hello World!"

@app.route("/ping")
def ping():
    return "pong"

@app.route("/oddgen/<int:low>/<int:high>")
def oddgen(low, high):
    start_time = time.time()
    result = sum(odd_generate(low, high))
    t = time.time() - start_time
    response = jsonify({"status": "success", "sum": str(result), "took": str(timedelta(seconds=t))})
    return response

@app.route("/oddlst/<int:low>/<int:high>")
def oddlst(low, high):
    start_time = time.time()
    result = sum(odd_list(low, high))
    t = time.time() - start_time
    response = jsonify({"status": "success", "sum": str(result), "took": str(timedelta(seconds=t))})
    return response

@app.route("/generator-expression")
def genexp():
    lst1 = [1,2,3,4]
    gen1 = (10**i for i in lst1)
    result = []
    for i in gen1:
        result.append(i)
    return jsonify({"result": result})

@app.route("/worked/<worker_id>/<worker_class>/<int:hours_worked>")
def classtest(worker_id, worker_class, hours_worked):
    class Employee(object):
        numEmployee = 0
        def __init__(self, name, rate):
            self.owed = 0
            self.name = name
            self.rate = rate
            Employee.numEmployee += 1

        def __del__(self):
            Employee.numEmployee -= 1

        def hours(self, numHours):
            self.owed += numHours * self.rate
            return ("%.2f hours worked" % numHours)

        def pay(self):
            self.owed = 0
            return (f"paid {self.name}")

    class SpecialEmployee(Employee):
        def hours(self, numHours):
            self.owed += numHours * self.rate * 2
            return("%.2f hours worked" % numHours)

    if worker_class == "gold":
        employee = SpecialEmployee("Joe Johnson (Gold)", 20.00)
    else:
        employee = Employee("Joe Johnson (Std)", 20.00)

    worklog = employee.hours(hours_worked)
    owed = employee.owed
    return jsonify({"worker_id": employee.name, "owed": owed, "worklog": worklog})

# def itertest(low, high):
#     while low < high:
#         print(low)
#         low += 1


def recurtest(low, high):
    if low <= high:
        print(low)
        low += 1
        recurtest(low, high)
    return f"{low}/{high}"


# to check DB connection:
@app.route("/users", methods=['GET', 'POST'])
def users_route():
    if request.method == 'GET':
        users = []
        for user in db.users.find():
            users.append(user.get("name", ""))
        return jsonify({"status": "success", "payload": users})
    elif request.method == 'POST':
        try:
            name = json.loads(request.get_data().decode()).get('name')
            user_id = db.users.insert_one({'name': name}).inserted_id
            return jsonify({"status": "success", "payload": str(user_id)})
        except Exception as e:
            return jsonify({"status": "failed", "payload": f"Please insert a name, {str(e)}"})


#generator function creates an iterator of odd numbers between n and m
# instead of creating a single result, it returns a sequence of
def odd_generate(n, m):
   while n < m:
       yield n
       n += 2

#builds a list of odd numbers between n and m
def odd_list(n,m):
   lst=[]
   while n<m:
       lst.append(n)
       n +=2
   return lst

if __name__ == "__main__":
    app.run()
