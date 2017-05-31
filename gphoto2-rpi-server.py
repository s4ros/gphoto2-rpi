##############################################################################
## Raspberry Pi Server for Nikon gphoto2 monitoring
## (c) 2017 by s4ros
## www.s4ros.it
## do.not.fucking.redistribute.for.free ;)
##############################################################################

import os, sys
import sqlite3
import time
from datetime import datetime
from flask import Flask, redirect, url_for, request, render_template

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

app = Flask(__name__)

# database file path
DBFILE = os.path.join(BASE_DIR,'rpi','database.db')
DBFILE = './rpi/database.db'
# how many items pull from database
LIMIT = 8
# time after we set status to FAIL [seconds]
FAILURE_TIME = 1200

###############################################
## GET index (new, for multi rpis)
@app.route('/')
def multi_index():
    conn = sqlite3.connect(DBFILE)
    c = conn.cursor()
    all_rpi = []
    # take all the rpi_ids from database
    # and build all_rpi[] list
    for row in c.execute("SELECT id,value FROM gphoto2_rpi_ids"):
        new_entry = dict()
        new_entry['rpi_id'] = row[0]
        new_entry['rpi_name'] = row[1]
        all_rpi.append(new_entry)
    # fillup the all_rpi dictionaries for each RPI existing in db
    for i in range(len(all_rpi)):
        row = c.execute("SELECT * FROM gphoto2_rpi_monitor WHERE rpi_id = {} ORDER BY id DESC LIMIT 1".format(all_rpi[i]['rpi_id'])).fetchone()

        print(row)
        all_rpi[i]['id'] = row[0]
        all_rpi[i]['date'] = row[2]
        all_rpi[i]['log'] = row[3]
        all_rpi[i]['filename'] = row[4]

    print(all_rpi)
    return render_template('multi_index.html', all_rpi=all_rpi)

###############################################
## GET index (old)
@app.route('/old')
def index():
    conn = sqlite3.connect(DBFILE)
    c = conn.cursor()
    rows = []
    for row in c.execute('SELECT * from gphoto2_rpi_monitor ORDER BY id DESC LIMIT {} '.format(LIMIT)):
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
    # create 'rpi' directory if doesn't exist
    if not os.path.isdir(os.path.join(BASE_DIR,'rpi')):
        print("Creating {} directory".format(os.path.join(BASE_DIR,'rpi')))
        os.mkdir(os.path.join(BASE_DIR,'rpi'))
    # delete old sqlite databases if exist
    try:
        print("Removing {} database file".format(DBFILE))
        os.remove(DBFILE)
    except:
        print("Cannot remove {} file. Maybe it doesn't exist.".format(DBFILE))
        pass
    print("Database file is: {}".format(DBFILE))
    conn = sqlite3.connect(DBFILE)
    conn.execute('CREATE TABLE gphoto2_rpi_ids (id INTEGER PRIMARY KEY, value TEXT UNIQUE)')
    conn.execute('CREATE TABLE gphoto2_rpi_monitor (id INTEGER PRIMARY KEY, rpi_id INTEGER ,date INTEGER, log TEXT, filename TEXT, FOREIGN KEY(rpi_id) REFERENCES gphoto2_rpi_ids(id))')
    conn.close()
    return "dbinit"

###############################################
## POST /insert
@app.route('/insert', methods=['POST','GET'])
def insert():
    if request.method == "POST":
        data = request.get_json()
        log_date = data['date']
        log_content = data['content']
        log_filename = data['filename']
        rpi_id = data['rpi_id']
        rpi_found = False
        # sqlite insert
        try:
            conn = sqlite3.connect(DBFILE)
            c = conn.cursor()
            # check if we the rpi_id doesn't exist in the db already
            for row in c.execute("SELECT * FROM gphoto2_rpi_ids"):
                if rpi_id == row[1]:
                    rpi_found = True
                    rpi_found_id = row[0]
            if not rpi_found:
                print "Didn't found {} in our database. Adding new one.".format(rpi_id)
                insert_str = "INSERT INTO gphoto2_rpi_ids (value) VALUES('{}')".format(rpi_id)
                c.execute(insert_str)
                conn.commit()
                rows = c.execute("SELECT id,value FROM gphoto2_rpi_ids WHERE value = '{}'".format(rpi_id))
                print("new rpi data")
                rpi_found_id = rows.fetchone()[0]
                print(rpi_found_id)
            insert_str = "INSERT INTO gphoto2_rpi_monitor (date, log, filename, rpi_id) VALUES({}, '{}', '{}', {})".format(log_date, log_content, log_filename, rpi_found_id)
            c.execute(insert_str)
            conn.commit()
            response = "Received date={} with string: {}\n".format(log_date, log_content)
        except:
            response = "Error ocurred"
            conn.rollback()
        conn.close()
        return response
    else:
        return "POST requests only"

##############################################################################
## main code
if __name__ == '__main__':
   app.run(host='0.0.0.0', port=56789)
