import os

from src.constant.const import CSV_PATH, CSV_NAME, CSV


def create_folder(folder):
    """
    Checks if a folder exists, if it does not it creates it
    :param folder: Folder to be created
    :return:
    """
    # Check if the folder does not exists
    if not os.path.isdir(folder):
        os.makedirs(folder)  # Create folder


def save_result_csv(connect_times_obj, csv_file):
    output_f = open(csv_file, "w+")  # Open the output file
    csv_str = ""

    # Save duration against time
    for i in connect_times_obj:
        csv_str += str(connect_times_obj[i]['start_time']) + ',' + str(connect_times_obj[i]['duration']) + '\n'

    output_f.write(csv_str)  # Write the processed line to the output text file
    output_f.close()
