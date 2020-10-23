###################### Set Up the server ######################
PORT_NUMBER=8080
USER="otech2ae"

# Ask to the user to introduce the port number to be used
echo "What port do you want to use for the web server? (Press Enter for 8080)."
read -r port_input

if [ -n "$port_input" ]
then
  PORT_NUMBER=$port_input
fi

# Ask to the user to introduce the username for accessing the correct path
echo "What is your user name? (Press Enter for otech2ae)."
read -r username_input

if [ -n "$username_input" ]
then
  USER=$username_input
fi

cd /home/giorgio/fhttpd

sudo make clean
sudo make

cp webserver.c /home/giorgio/webserver.orig.c

sudo ./webserver "$PORT_NUMBER"


