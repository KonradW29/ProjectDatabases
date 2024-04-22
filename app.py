import psycopg2
from config import config
from flask import Flask, render_template, request

# Connect to the PostgreSQL database server
def connect(query):
    conn = None
    try:
        # read connection parameters
        params = config()
 
        # connect to the PostgreSQL server
        print('Connecting to the %s database...' % (params['database']))
        conn = psycopg2.connect(**params)
        print('Connected.')
      
        # create a cursor
        cur = conn.cursor()
        
        # execute a query using fetchall()
        cur.execute(query)
        rows = cur.fetchall()

        # close the communication with the PostgreSQL
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()
            print('Database connection closed.')
    # return the query result from fetchall()
    return rows
 
app = Flask(__name__)

# serve form web page
@app.route("/")
def form():
    return render_template('UI.html')

# handle venue POST and serve result web page
@app.route('/SearchGoatId', methods=['POST'])
def SearchGoatId():
    rows = connect('SELECT SoloGoats.animal_id, SoloGoats.dam, SoloGoats.totalPoints FROM SoloGoats WHERE animal_id = ' + request.form['animal_id'] + ';')
    heads = ['animal_id', 'dam', 'totalPoints']
    return render_template('results.html', rows=rows, heads=heads)

# handle venue POST and serve result web page
@app.route('/SearchGroup', methods=['POST'])
def SearchGroup():
    if (request.form['group'] == 'High'):
        rows = connect('SELECT * FROM HighQuality')
        heads = ['quality', 'animal_id', 'dam', 'totalPoints']
    elif (request.form['group'] == 'Middle'):
        rows = connect('SELECT * FROM MiddleQuality')
        heads = ['quality', 'animal_id', 'dam', 'totalPoints']
    elif (request.form['group'] == 'Low'):
        rows = connect('SELECT * FROM LowQuality')
        heads = ['quality', 'animal_id', 'dam', 'totalPoints']
    return render_template('results.html', rows=rows, heads=heads)
    
if __name__ == '__main__':
    app.run(debug = True)