import os
from os import listdir
from os.path import isfile

import click
from pyfiglet import Figlet

import pandas as pd

from src.constant.const import SYN_code, ACK_code, FIN_code, CSV_PATH, CSV, CSV_NAME, PCAP_TXT, PCAP_PATH, TXT
from src.functions.func import create_folder, save_result_csv
from src.graph.createGraph import create_graph
from os.path import isfile, join


@click.group()
def main():
    pass


def pcap_to_txt(pcap_nm):
    """
    Runs the command to convert the pcap file to a txt with the desired columns
    """
    os.system("tshark -n -r pcap/{}.pcap -E separator=\;  -E header=y -T fields \
                -e frame.time_epoch \
                -e ip.proto \
                -e ip.src \
                -e ip.dst \
                -e tcp.srcport \
                -e tcp.dstport \
                 -e tcp.flags > pcap/{}.txt".format(pcap_nm, pcap_nm))
    return 0


def create_hash_table(df_hash):
    """
    Receives a df and return a hash table with a list per each different port used
    :param df_hash: The dataframe
    :return: dic_hash which is the created hash table
    """
    dic_hash = {}
    for index, row in df_hash.iterrows():  # Go for each row of the df
        # Get the port used by the client
        if row['tcp.srcport'] == 80:
            port = row['tcp.dstport']
        else:
            port = row['tcp.srcport']

        # If the port is new a new entry is created indicating the new connection
        if port not in dic_hash:
            dic_hash[port] = [row]  # Add the actual row as a list with only itself

        # The connection is not new
        else:
            dic_hash[port].append(row)  # Add the actual row to the existing list inside the hash table

    return dic_hash


def calc_connect_time(dic_connect, origin_time_calc):
    """
    Creates a hash table with the duration and start time for each of the connections.
    :param dic_connect: The hash table with all the information about all of the different connections.
    :param origin_time_calc: The time to be taken as the origin.
    :return: connect_times_dic which is a hash table with the key the connection and the
    "start_time" and "duration" as entries.
    """
    connect_times_dic = {}

    # Iterate through each of the connection
    for connect in dic_connect:
        # Get the starting time of the connection
        start_time = -1

        # Iterate through the rows from the current connection
        for connect_i in dic_connect[connect]:
            # First SYN found
            if connect_i['tcp.flags'] == SYN_code:
                start_time = connect_i['frame.time_epoch']
                break

        # Get the ending time of the connection
        end_time = -1

        for idx, connect_i in reversed(list(enumerate(dic_connect[connect]))):
            # No more indexes to iterate through
            if idx == 0:
                end_time = start_time + 200

            if connect_i['tcp.flags'] == ACK_code and dic_connect[connect][idx - 1]['tcp.flags'] == FIN_code:
                end_time = connect_i['frame.time_epoch']
                break

        # Create the entry to the time list
        connect_times_dic[connect] = {"start_time": start_time - origin_time_calc, "duration": end_time - start_time}

    return connect_times_dic


def csv_exec(pcap_name, csv_name):
    # Check what pcap file is to be read
    if pcap_name is not None:  # Pcap file name introduced
        pcap_nm = pcap_name

    else:  # Default pcap name
        pcap_nm = PCAP_TXT

    pcap_to_txt(pcap_nm)  # Create the txt file from the pcap

    df = pd.read_csv(PCAP_PATH + pcap_nm + TXT, error_bad_lines=False, sep=';')  # Read txt
    dic = create_hash_table(df)  # Create the hash table with the different connections

    origin_time = None  # Initialize the origin time
    for connect in dic:
        origin_time = dic[connect][0]['frame.time_epoch']
        break

    if origin_time is None:  # Error checking
        print("Error while getting the origin time")
        quit(-1)

    connect_times = calc_connect_time(dic, origin_time)  # Calculates the correct time

    create_folder(CSV_PATH)  # Create csv folder in case it does not exist

    # Set the name of the csv file is to be created
    if csv_name is not None:  # Csv file name introduced
        csv_file = CSV_PATH + csv_name + CSV

    elif pcap_name is not None:  # Pcap file name introduced so it is used the same one for the csv
        csv_file = CSV_PATH + pcap_name + CSV

    else:  # Default csv name
        csv_file = CSV_PATH + CSV_NAME + CSV

    save_result_csv(connect_times, csv_file)  # Save the results into a csv file


@main.command(help='Creates the csv file from the pcap file.')
@click.option('--pcap_name', '-pcap', required=False, nargs=1, help='Name of the pcap file to be read.')
@click.option('--csv_name', '-csv', required=False, nargs=1, help='Name of the csv file to be created.')
@click.option('--all', '-a', is_flag=True, help='Run all the pcap files at the folder pcap.')
def csv(all, pcap_name=None, csv_name=None):
    if all:  # Run all the pcap files
        list_f = []
        for f_i in listdir(PCAP_PATH):  # Get the names of the pcap files to be used
            if isfile(join(PCAP_PATH, f_i)):
                list_f.append(f_i.split(".pcap")[0])

        for f_i in list_f:  # Create the csv file for all the pcap files
            csv_exec(f_i, csv_name)

    else:  # Run only the specified pcap file
        csv_exec(pcap_name, csv_name)

    os.system("rm {}*.txt".format(PCAP_PATH))  # Remove all the txt files
    return 0


@main.command(help='Generates the Graphs from the data.')
def graph():
    """
    Generates the Graphs
    """
    create_graph()
    return 0


f = Figlet(font='slant')  # Useless cool text
print(f.renderText('TCP SYN FLOOD'))

main()  # Runs the cli
