import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import os

from src.constant.graph_const import *
from src.constant.const import *
from src.functions.func import create_folder


def save_data(arr, file):
    output_f = open(file, "w+")  # Open the output file

    data_str = ""

    for idx, arr_i in enumerate(arr):
        ge_i = arr_i[1].split("-")
        ge_i = np.asarray(ge_i)
        ge_i = ge_i.astype(int)

        ge_avg = np.mean(ge_i, axis=0)

        data_str += str(arr_i[3]) + "," + str(int(ge_avg)) + "\n"

    output_f.write(data_str)  # Write the processed line to the output text file
    output_f.close()
    return


def obtain_mean(data_list):
    mean_data = np.array([COL_NM[0], COL_NM[1]])
    for data_f_i in data_list:
        mean_i = np.mean(data_f_i, axis=0)
        mean_data = np.vstack((mean_data, mean_i))

    mean_data = np.delete(mean_data, 0, axis=0)

    df = pd.DataFrame(data=mean_data, dtype=float)

    df.columns = [COL_NM[0], COL_NM[1]]
    df[COL_NM[1]] = df[COL_NM[1]].round(decimals=2)
    # df[COL_NM[0]] = df[COL_NM[0]].round(decimals=0)

    return [df]


def readFiles(files, col, round_val=None):
    """
    Read a list of csv files and returns its data
    :param round_val: It sets the decimal values to round the execution time value
    :param files: List of file names
    :param col: Column names
    :return: A list with the data of each of the files
    """
    data = []  # Data list to return

    # Read the data from each of the files
    for file in files:
        data_tmp = pd.read_csv(file, sep=",", header=None, names=[col[0], col[1]])

        # Check if it has to round execution time
        if round_val is not None:  # TODO Change the scale here
            data_tmp[col[1]] = data_tmp[col[1]].round(decimals=2)

        # insert zero in both columns at index 1
        # line = pd.DataFrame({col[0]: 0, col[1]: 0}, index=[0])
        # data_tmp = pd.concat([data_tmp.iloc[:0], line, data_tmp.iloc[0:]]).reset_index(drop=True)

        data.append(data_tmp)  # Add the new data from the csv file to the list
    return data


def update_path_mod(g_mode, img_folder):
    if g_mode is PTN:
        img_folder += PTN_F
    elif g_mode is LN_DISC:
        img_folder += LN_DISC_F
    elif g_mode is LN_MEDIAN:
        img_folder += LN_MEDIAN_F
    elif g_mode is VLN:
        img_folder += VLN_F
    else:
        print("ERROR: Incorrect mode")
        print(g_mode)
    return img_folder


def add_legend(g_mode, lgn_mode, plt_counter, lgn_pt_size):
    # For violin graphs the legend does not work
    if g_mode is VLN or g_mode is LN_MEDIAN:
        return

    # Add legend
    lgnd = plt.legend(loc=lgn_mode, numpoints=1, fontsize=10)

    # Set the size of the points in the legend
    for i in range(0, plt_counter):
        lgnd.legendHandles[i]._legmarker.set_markersize(lgn_pt_size)


def single_graph(data, col, axis, axis_name,
                 g_name, g_mode, grid_mode, colour,
                 lgn_mode, lgn_pt_size, pt_size, labels,
                 img_folder, img, img_type, img_size):
    # Update the path to the folder with the correct mode
    img_folder = update_path_mod(g_mode, img_folder)

    # Go through all the list of data in data - which are the number of graphs to plot
    for idx, arr in enumerate(data):
        # Plot counter
        plt_counter = 0

        # Create the graph
        createPlots(col[0], col[1], data[idx], labels[idx], colour[idx],
                    axis[0], axis[1], pt_size, g_name[idx], axis_name,
                    grid_mode, g_mode)

        # Update plot counter
        plt_counter += 1

        # Add the legend to the graph
        add_legend(g_mode, lgn_mode, plt_counter, lgn_pt_size)

        # Save graph as an image
        plt.savefig(img_folder + img[idx] + img_type, dpi=img_size)
        plt.close()


def multiple_graph(data, col, axis, axis_name,
                   g_name, g_comp_name, g_mode, grid_mode, grid_colour, colour,
                   lgn_mode, lgn_pt_size, pt_size, labels,
                   img_folder, img, img_type, img_size):
    # Update the path to the folder with the correct mode
    img_folder = update_path_mod(g_mode, img_folder)

    # Go through all the list of data in data - which are the number of graphs to plot
    for idx, arr in enumerate(data):
        # Set to initial values
        name, name_plt, plt_counter = "", "", 0

        # Do not print the last graph - it assumes that the single graphs have been plot already
        if idx == len(data) - 1:
            break

        # Update the name for the graph
        name += img_folder + img[idx]
        name_plt += g_comp_name[idx]

        # Create first plot
        createPlots(col[0], col[1], data[idx], labels[idx], colour[idx],
                    axis[0], axis[1], pt_size, g_name[idx], axis_name,
                    grid_mode, g_mode, grid_colour=grid_colour)

        # Update plot counter
        plt_counter += 1

        # Each graph prints the comparison with the following graphs
        for i in range(idx + 1, len(data)):
            # Add subsequent graph points to the comparison graph
            createPlots(col[0], col[1], data[i], labels[i], colour[i],
                        axis[0], axis[1], pt_size, g_name[i], axis_name,
                        grid_mode, g_mode, grid_colour=grid_colour)
            plt_counter += 1

            # Update the name for the graph
            name += " & " + img[i]
            name_plt += " & \n" + g_comp_name[i]

        # Add the legend to the graph
        add_legend(g_mode, lgn_mode, plt_counter, lgn_pt_size)

        # Set the name for the comparison graph
        plt.title(name_plt)

        # Save graph as an image
        plt.savefig(name + img_type, dpi=img_size)
        plt.close()


def two_graphs(data, col, axis, axis_name,
               g_name, g_comp_name, g_mode, grid_mode, grid_colour, colour,
               lgn_mode, lgn_pt_size, pt_size, labels,
               img_folder, img, img_type, img_size):
    # Update the path to the folder with the correct mode
    img_folder = update_path_mod(g_mode, img_folder)

    # Go through all the list of data in data - which are the number of graphs to plot
    for idx, arr in enumerate(data):
        # The two last ones are already plotted
        if idx == len(data) - 2:
            break

        # Each graph prints the comparison with one of the following ones
        for i in range(idx + 1, len(data)):
            # Plot counter
            plt_counter = 0

            # Update the name for the graph
            name = img_folder + img[idx]
            name_plt = g_comp_name[idx]

            # Base graph
            createPlots(col[0], col[1], data[idx], labels[idx], colour[idx],
                        axis[0], axis[1], pt_size, g_name[idx], axis_name,
                        grid_mode, g_mode, grid_colour=grid_colour)

            # Update plot counter
            plt_counter += 1

            # Update the name for the graph
            name += " & " + img[i]
            name_plt += " & \n" + g_comp_name[i]

            # Comparison graph
            createPlots(col[0], col[1], data[i], labels[i], colour[i],
                        axis[0], axis[1], pt_size, g_name[i], axis_name,
                        grid_mode, g_mode, grid_colour=grid_colour)

            # Update plot counter
            plt_counter += 1

            # Add the legend to the graph
            add_legend(g_mode, lgn_mode, plt_counter, lgn_pt_size)

            # Set the name for the comparison graph
            plt.title(name_plt)

            # Save graph as an image
            plt.savefig(name + img_type, dpi=img_size)
            plt.close()


def create_graph():
    """
    It creates the graphs for the CSV files created.
    Uses the data from graph_const and const
    """
    from os import listdir
    from os.path import isfile, join
    file_list = [f for f in listdir(CSV_PATH) if isfile(join(CSV_PATH, f))]

    data = readFiles([
        # CSV_PATH + CSV_50 + CSV,
        # CSV_PATH + CSV_100 + CSV,
        # CSV_PATH + CSV_150 + CSV,
        CSV_PATH + CSV_200 + CSV,
        # CSV_PATH + CSV_250 + CSV,
        # CSV_PATH + CSV_300 + CSV,
        CSV_PATH + CSV_200_ON + CSV
    ], COL_NM, round_val=ROUND_VAL)

    # Modes to use, change by the user - Median mode should be used alone
    modes = [LN_DISC]
    colour = COLOUR  # This is for all the graphs but for the median

    # Check if there is no folder for the images
    create_folder(IMG_FOLDER_PATH)
    # Check all the folders for the different type of graphs
    for mode_i in MODE_F:
        create_folder(IMG_FOLDER_PATH + mode_i)

    # Set the variables for the Median Graph, it is a special case
    if LN_MEDIAN in modes:
        data = obtain_mean(data)
        colour = [[COLOUR_FILL_MEDIAN, colour]]

    # Create the graphs for all the different types specified
    for mode in modes:
        # Creates single graphs
        single_graph(data, COL_NM, AXIS, AXIS_NM,
                     GRAPH_NM, mode, GRID_DISC, colour,
                     LGN_LR, PTN_SIZE_LGN, PTN_SIZE, LABEL,
                     IMG_FOLDER_PATH, IMG, IMG_TYPE, IMG_SIZE)

        # Creates comparison graphs
        multiple_graph(data, COL_NM, AXIS, AXIS_NM,
                       GRAPH_NM, GRAPH_COMP_NM, mode, GRID_DISC, GRID_COLOUR, colour,
                       LGN_LR, PTN_SIZE_LGN, PTN_SIZE, LABEL,
                       IMG_FOLDER_PATH, IMG, IMG_TYPE, IMG_SIZE)

        # Creates comparison of two graphs
        two_graphs(data, COL_NM, AXIS, AXIS_NM,
                   GRAPH_NM, GRAPH_COMP_NM, mode, GRID_DISC, GRID_COLOUR, colour,
                   LGN_LR, PTN_SIZE_LGN, PTN_SIZE, LABEL,
                   IMG_FOLDER_PATH, IMG, IMG_TYPE, IMG_SIZE)


def createPlots(c1, c2, data, label, colour,
                x_axis, y_axis, point_size, name, axis,
                grid_linestyle, mode, grid_colour=None):
    # Load the data
    x = data[c1]
    y = data[c2]

    # Arrange the data
    x_axis = np.arange(x_axis[0], x_axis[1], x_axis[2])
    y_axis = np.arange(y_axis[0], y_axis[1], y_axis[2])

    # Graph with points
    if mode is PTN:
        plt.plot(x, y, 'o', label=label, markersize=np.sqrt(point_size[0]), color=colour)

    # Line graph with discontinuous lines
    elif mode is LN_DISC:
        plt.plot(x, y, label=label, marker='.', markersize=np.sqrt(point_size[1]), color=colour, linestyle=':')
        plt.fill_between(x, y, alpha=0.4, color=colour)


    elif mode is LN_MEDIAN:
        grid_col = colour[0]
        graph_col = colour[1]
        plt.plot(x, y, label=label, marker='.', markersize=np.sqrt(point_size[1]), color=grid_col, linestyle=':')
        plt.fill_between(x, y, alpha=0.2, color=grid_col)
        for idx, x_i in enumerate(x):
            # Vertical line
            plt.plot((x_i, x_i), (0, y[idx]), alpha=0.7, color=graph_col[idx], linestyle="dashed")

            # Horizontal line
            plt.plot((0, x_i), (y[idx], y[idx]), alpha=0.7, color=graph_col[idx], linestyle="dashed")

            # Point
            plt.plot(x_i, y[idx], 'o', markersize=3, alpha=0.7, color=graph_col[idx])

        # Set colour variable to set the grid
        colour = grid_col


    elif mode is VLN:
        violin_parts = plt.violinplot(y, [x[1]], points=100, widths=4, showmeans=True,
                                      showextrema=True, showmedians=True, bw_method=0.5)

        for part in ('cbars', 'cmins', 'cmaxes', 'cmeans', 'cmedians'):
            vp = violin_parts[part]
            vp.set_color(colour)
            vp.set_linewidth(1)

        for part in violin_parts['bodies']:
            part.set_color(colour)
            part.set_alpha(0.3)

    # Incorrect plot mode
    else:
        print("ERROR: Wrong plot mode")
        return -1

    # Set the ranges for the
    plt.xlim([x_axis[0], x_axis[len(x_axis) - 1]])
    plt.ylim([y_axis[0], y_axis[len(y_axis) - 1]])

    plt.xticks(x_axis)
    plt.yticks(y_axis)

    # Set the name to the graph and the names for the axis
    plt.title(name)
    plt.xlabel(axis[0])
    plt.ylabel(axis[1])

    plt.axvline(x=30, color='indianred')
    plt.axvline(x=150, color='indianred')

    # Set the colour to the grid
    if grid_colour is None:
        plt.grid(True, color=colour, alpha=0.3, linestyle=grid_linestyle)
    else:
        plt.grid(True, color=grid_colour, linestyle=grid_linestyle)
