##############################################################################
## Raspberry Pi Server for Nikon gphoto2 monitoring
## (c) 2017 by s4ros
## www.s4ros.it
## do.not.fucking.redistribute.for.free ;)
##############################################################################

# time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(1347517370))


import sqlite3
import time
from flask import Flask, redirect, url_for, request, render_template

app = Flask(__name__)

###############################################
## GET index
@app.route('/')
def index():
    conn = sqlite3.connect('database.db')
    result = conn.execute('SELECT * from nikon_monitor LIMIT 60')
    results = str(result)
    conn.close()
    return render_template(
       "index.html", **locals())

###############################################
## GET /dbinit
@app.route('/dbinit')
def dbinit():
    conn = sqlite3.connect('database.db')
    conn.execute('CREATE TABLE nikon_monitor (id INTEGER PRIMARY KEY, date INTEGER, log TEXT, filename TEXT)')
    conn.close()
    return None

###############################################
## POST /input
@app.route('/input', methods=['POST','GET'])
def input():
    if request.method == "POST":
        data = request.get_json()
        log_date = data['date']
        log_content = data['content']
        log_filename = data['filename']

        # sqlite insert
        try:
            conn = sqlite3.connect('database.db')
            cur = conn.cursor()
            insert_str = "INSERT INTO nikon_monitor (date, log, filename) VALUES({}, '{}', '{}')".format(log_date, log_content, log_filename)
            cur.execute(insert_str)
            conn.commit()
            response = "Received date={} with string: {}".format(log_date, log_content)
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