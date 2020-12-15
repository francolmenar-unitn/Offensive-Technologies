#!/usr/bin/python3

# sudo apt install python3-mysql.connector
# pip3 install mysql-connector-python

import mysql.connector
from mysql.connector import Error

def connect():
    conn = None
    try:
        conn = mysql.connector.connect(host='localhost',
                                       database='ctf2',
                                       user='root',
                                       password='rootmeansadmin1984')
        if conn.is_connected():
            print('Connected to database')

    except Error as e:
        print("An error occurred")
        print(e)

    return conn

def close(conn):
    if conn is not None and conn.is_connected():
        conn.close()

def check_constraint(conn, query, check):

    cursor = conn.cursor()
    print("=================================================================")
    print("{} check".format(check))
    cursor.execute(query)
    records = cursor.fetchall()
    if len(records) == 0:
        print("{} not violated".format(check))
    else:
        print("{} violated... Printing results".format(check))
        for record in records:
            print(record)
    print("=================================================================")

def main():
    negative_total_check = "Users with negative balance"
    negative_total_violation = "SELECT user, SUM(amount) AS total FROM transfers GROUP BY (user) HAVING total < 0;"
    
    fk_constraint_check = "Transfer-User foreign key constraint"
    fk_constraint_violation = "SELECT user, amount FROM transfers WHERE user NOT IN (SELECT user FROM users)"

    conn = connect()
    if conn is not None and conn.is_connected():
        print("Starting constraint checks...")
        check_constraint(conn, negative_total_violation, negative_total_check)
        check_constraint(conn, fk_constraint_violation, fk_constraint_check)

    close(conn)



if __name__ == "__main__":
    main()
    
