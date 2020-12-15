# Scripts for the Server

## log_analyze.sh
It has to be run on the nodes.

```
sudo ./log_analyze.sh
```

## monitor_gateway.pl
```
sudo tcpdump -i <eth> src host 10.1.5.2 -l -e -n | ./monitor_server.pl
```

## set_up_server.sh
Creates the HTTP files and installs the qos module. It has to be run on the laptop, not on the nodes.

```
./set_up_server.sh -u <username>
```