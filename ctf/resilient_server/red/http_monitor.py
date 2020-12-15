#!/usr/bin/python3

## install setuptools: sudo apt update && sudo apt install python3-setuptools
## cd scapy
## sudo python3 setup.py install

from scapy.all import *
from scapy.layers.http import HTTPRequest

def sniffer(iface=None):
    if iface:
        sniff(filter="port 80", prn=process, iface=iface, store=False)
    else:
        sniff(filter="port 80", prn=process, store=False)

def process(pkt):
    if pkt.haslayer(HTTPRequest):

        path = pkt[HTTPRequest].Path.decode()
        ip = pkt[IP].src
        method = pkt[HTTPRequest].Method.decode()

        http_version = ""
        host = ""
        user_agent = ""
        connection = ""
        cache_control = ""

        if not pkt[HTTPRequest].Http_Version is None:
            http_version = pkt[HTTPRequest].Http_Version.decode()
        
        if not pkt[HTTPRequest].Host is None:
            host = pkt[HTTPRequest].Host.decode()

        if not pkt[HTTPRequest].User_Agent is None:
            user_agent = pkt[HTTPRequest].User_Agent.decode()

        if not pkt[HTTPRequest].Connection is None:
            connection = pkt[HTTPRequest].Connection.decode()

        if not pkt[HTTPRequest].Cache_Control is None:
            cache_control = pkt[HTTPRequest].Cache_Control.decode()

        print("=======================================================HTTP REQUEST=========================================")
        print("{} request from {} for {}".format(method, ip, path))
        print("HTTP Version {}, Host: {}, User_Agent: {}, Connection: {}, Cache Control: {}".format(http_version, host, user_agent, connection, cache_control))
        if show_raw and pkt.haslayer(Raw) and method == "POST":
            print("Raw data from POST Request {pkt[RAW].load}")
        print("============================================================================================================")

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="HTTP Packet Sniffer")
    parser.add_argument("-i", "--iface", help="Interface to use, default is scapy's default interface")
    parser.add_argument("--show-raw", dest="show_raw", action="store_true", help="Whether to print POST raw data, such as passwords, search queries, etc.")

    args = parser.parse_args()
    iface = args.iface
    show_raw = args.show_raw
    sniffer(iface)