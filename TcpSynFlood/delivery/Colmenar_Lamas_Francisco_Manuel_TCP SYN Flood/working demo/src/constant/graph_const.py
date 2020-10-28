########################### Values for reading the CSV files ###########################
# Rounding value for the execution time. If it is set to None no round is performed
ROUND_VAL = None

# Names for the columns of the np array
COL_NM = ["Time",
          "Duration"]

########################### Constants for Graph Creation  ###########################
# Range of values for the axis
AXIS = [
    [0, 200, 20],
    # [0, 250, 25]
    [0, 240, 20]
]

# Names for the axis
AXIS_NM = [
    "Time",
    "Duration of the connection (s)"
]

# Colours for the different graphs
COLOUR = [
    "tab:blue",
    "coral",
    "tab:green",
    "gold",
    "tab:red",
    "coral",
    "tab:green"
]

COLOUR_FILL_MEDIAN = "cornflowerblue"

# Default colour for the grid for comparison graphs
GRID_COLOUR = '#cfe0e8'

IMG_FOLDER_PATH = "img/"

# Name for the images files
IMG = [
    # "Highrate_of_50",
    # "Highrate_of_100",
    # "Highrate_of_150",
    "Highrate_of_200_off",
    # "Highrate_of_250",
    # "Highrate_of_300",
    "Highrate_of_200_on"
]

IMG_SIZE = 600

# Type of the output image file
IMG_TYPE = ".png"

# Names for the labels from the legend
LABEL = [
    # "Highrate of 50/s",
    # "Highrate of 100/s",
    # "Highrate of 150/s",
    "Highrate of 200/s off",
    # "Highrate of 250/s",
    # "Highrate of 300/s",
    "Highrate of 200/s on"
]

# Names for the different graphs
GRAPH_NM = [
    # "Highrate of 50/s",
    # "Highrate of 100/s",
    # "Highrate of 150/s",
     "Highrate of 200/s off",
    # "Highrate of 250/s",
    # "Highrate of 300/s",
    "Highrate of 200/s on"
]

# Names for the comparison graphs
GRAPH_COMP_NM = [
    # "Highrate of 50/s",
    # "Highrate of 100/s",
    # "Highrate of 150/s",
    "Highrate of 200/s off",
    # "Highrate of 250/s",
    # "Highrate of 300/s",
    "Highrate of 200/s on"
]

# Size of the points for the graph
PTN_SIZE = [3,  # For graph with points
            3]  # For discontinuous line graphs

# Size for the points for the legend
PTN_SIZE_LGN = 3

############# Modes for the legend of the graphs  #############
LGN_LR = "lower right"

############# Modes for the graphs  #############
PTN = "POINT"
PTN_F = "points/"

LN_DISC = "LN_DISC"
LN_DISC_F = "line_disc/"

LN_MEDIAN = "LN_MEDIAN"
LN_MEDIAN_F = "line_median/"

VLN = "VLN"
VLN_F = "violin/"

ALL_MODES = [PTN, LN_DISC, VLN]
MODE_F = [PTN_F, LN_DISC_F, LN_MEDIAN_F, VLN_F]

############# Modes for the Grid Linestyle  #############
GRID_DISC = '--'
