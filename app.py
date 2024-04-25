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

# handle SearchTag POST and serve result web page
@app.route('/SearchTag', methods=['POST'])
def SearchTag():
    print(request.form['tag'])
    rows = connect('SELECT dam, tag, totalPoints FROM SoloGoats WHERE dam = (SELECT dam FROM SoloGoats WHERE tag = \'' + str(request.form['tag']) + '\');')
    heads = ['dam', 'tag', 'totalPoints']
    return render_template('results.html', rows=rows, heads=heads)

# handle SearchGroup POST and serve result web page
@app.route('/SearchGroup', methods=['POST'])
def SearchGroup():
    if (request.form['group'] == 'High'):
        rows = connect('SELECT HighQuality.quality, tag, dam, totalPoints, SoldCount FROM HighQuality INNER JOIN HighSold ON HighQuality.quality = HighSold.quality;')
        heads = ['quality', 'tag', 'dam', 'totalPoints', 'SoldCount']
    elif (request.form['group'] == 'Middle'):
        rows = connect('SELECT MiddleQuality.quality, tag, dam, totalPoints, SoldCount FROM MiddleQuality INNER JOIN MiddleSold ON MiddleQuality.quality = MiddleSold.quality;');
        heads = ['quality', 'tag', 'dam', 'totalPoints', 'SoldCount']
    elif (request.form['group'] == 'Low'):
        rows = connect('SELECT LowQuality.quality, tag, dam, totalPoints, SoldCount FROM LowQuality INNER JOIN LowSold ON LowQuality.quality = LowSold.quality;')
        heads = ['quality', 'tag', 'dam', 'totalPoints', 'SoldCount']
    return render_template('results.html', rows=rows, heads=heads)
    
if __name__ == '__main__':
    app.run(debug = True)