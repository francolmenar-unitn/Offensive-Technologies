#!/usr/bin/python3

# sudo apt install python3-mysql.connector
# pip3 install mysql-connector-python

import mysql.connector
from mysql.connector import Error

import time



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


def check_constraint(conn, query, check, print_bool):
    cursor = conn.cursor()

    if print_bool is True:
        print("=================================================================")
        print("{} check".format(check))

    cursor.execute(query)
    records = cursor.fetchall()

    if len(records) == 0:
        if print_bool is True:
            print("{} not violated".format(check))

        return False

    else:
        if print_bool is True:
            for record in records:
                print(record)
            print("=================================================================")

        return True


def main():
    negative_total_check = "Users with negative balance"
    negative_total_violation = "SELECT user, SUM(amount) AS total FROM transfers GROUP BY (user) HAVING total < 0;"

    fk_constraint_check = "Transfer-User foreign key constraint"
    fk_constraint_violation = "SELECT user, amount FROM transfers WHERE user NOT IN (SELECT user FROM users)"

    conn = connect()
    if conn is not None and conn.is_connected():
        print("Starting constraint checks...")

        const_neg, const_fk = False, False  # Initially not compromised

        while True:
            ###################### Negative constraint ######################
            if const_neg is not check_constraint(conn, negative_total_violation, negative_total_check, False):
                # It got compromised
                if const_neg is False:
                    # Print the results
                    check_constraint(conn, negative_total_violation, negative_total_check, True)
                    const_neg = True

                else:
                    check_constraint(conn, negative_total_violation, negative_total_check, True)
                    const_neg = False

            ###################### FK constraint ######################
            if const_fk is not check_constraint(conn, fk_constraint_violation, fk_constraint_check, False):
                # It got compromised
                if const_fk is False:
                    # Print the results
                    check_constraint(conn, fk_constraint_violation, fk_constraint_check, True)
                    const_fk = True

                else:
                    check_constraint(conn, fk_constraint_violation, fk_constraint_check, True)
                    const_fk = False

            time.sleep(1)

    close(conn)


if __name__ == "__main__":
    main()
