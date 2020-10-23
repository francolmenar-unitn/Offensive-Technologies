import click
from pyfiglet import Figlet

f_path = "scripts/exploit/payload"
str_arr = ["A_really_lo", "ng_string_of_", "_chars"]  # Base strings to construct the string
HTTP_call = "GET "
end_str = "\r\n\r\n"


@click.group()
def main():
    pass


@main.command()
@click.argument('str_length', type=int, nargs=1)
def run(str_length):
    str_out = create_str(str_length) # Create the String

    save_str(str_out)  # Save the String into a file


def create_str(str_length):
    str_out = ""  # Output string to be created

    size_of_str = 0  # Counter to know the size of the base strings

    for arr_i in str_arr:  # Calculate the length of the base array
        size_of_str = size_of_str + len(arr_i)

    if str_length < (size_of_str + len(str(str_length))):  # Short string not long enough for the base string
        for i in range(0, size_of_str):
            num_i = str(i)
            str_out = str_out + num_i[len(num_i) - 1]  # Just add 1-9 numbers

    else:  # Use the base String
        for i in range(0, str_length - size_of_str - len(str(str_length))):
            str_arr[0] = str_arr[0] + 'o'  # Add the 'o's to the base string

        str_arr[1] = str_arr[1] + str(str_length)

        for arr_i in str_arr:  # Merge the parts of the array of Strings
            str_out = str_out + arr_i

    str_out = HTTP_call + str_out + end_str  # Add the GET to the string generated

    return str_out


def save_str(str_out):
    prefix_len = len(str_out) - len(HTTP_call) - len(end_str)

    text_file = open(f_path + str(prefix_len), "w")
    text_file.write(str_out)
    text_file.close()


f = Figlet(font='slant')  # Useless cool text
print(f.renderText('STRING GEN'))

main()  # Runs the cli
