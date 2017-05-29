##############################################################################
## Raspberry Pi Server for Nikon gphoto2 monitoring
## (c) 2017 by s4ros
## www.s4ros.it
## do.not.fucking.redistribute.for.free ;)
##############################################################################

import sqlite3
import time
from datetime import datetime
from flask import Flask, redirect, url_for, request, render_template

app = Flask(__name__)

# database file path
DBFILE = "./rpi/database.db"
# how many items pull from database
LIMIT = 8
# time after we set status to FAIL [seconds]
FAILURE_TIME = 1200

###############################################
## GET index
@app.route('/')
def index():
    conn = sqlite3.connect(DBFILE)
    c = conn.cursor()
    rows = []
    for row in c.execute('SELECT * from nikon_monitor ORDER BY id DESC LIMIT {} '.format(LIMIT)):
        rows.append({
            'id':row[0],
            'date':datetime.fromtimestamp(float(row[1])).strftime('%Y-%m-%d %H:%M:%S'),
            'epoch': row[1],
            'log':row[2],
            'filename':row[3]
        })
    conn.close()
    currentTime = datetime.fromtimestamp(float(time.time())).strftime('%Y-%m-%d %H:%M:%S')

    # counting the status
    lastTime = int(rows[0]['epoch'])
    timeNow = time.time()
    deltaTime = timeNow - lastTime
    print("deltaTime = {}, timeNow = {}, lastTime = {}".format(deltaTime, timeNow, lastTime))
    if deltaTime > FAILURE_TIME:
        status="FAIL"
    else:
        status="OK"
    return render_template(
       "index.html", results=rows, time=currentTime, status=status, limit=LIMIT)

###############################################
## GET /dbinit
@app.route('/dbinit')
def dbinit():
    conn = sqlite3.connect(DBFILE)
    conn.execute('CREATE TABLE nikon_monitor (id INTEGER PRIMARY KEY, date INTEGER, log TEXT, filename TEXT, rpi_id TEXT)')
    conn.close()
    return None

###############################################
## POST /insert
@app.route('/insert', methods=['POST','GET'])
def insert():
    if request.method == "POST":
        data = request.get_json()
        log_date = data['date']
        log_content = data['content']
        log_filename = data['filename']

        # sqlite insert
        try:
            conn = sqlite3.connect(DBFILE)
            cur = conn.cursor()
            insert_str = "INSERT INTO nikon_monitor (date, log, filename) VALUES({}, '{}', '{}')".format(log_date, log_content, log_filename)
            cur.execute(insert_str)
            conn.commit()
            response = "Received date={} with string: {}\n".format(log_date, log_content)
        except:
            response = "Error ocurred"
            conn.rollback()
        conn.close()
        return response
    else:
        return "POST req only"

##############################################################################
## main code
if __name__ == '__main__':
   app.run(host='0.0.0.0', port=56789)
