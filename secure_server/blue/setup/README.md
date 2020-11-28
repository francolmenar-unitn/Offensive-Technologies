# Scripts for the Setup 

## setup.sh
Runs the whole Server setup process. It calls to send_files.sh, server_setup.sh and server_qos_setup.sh. 

It is recommended to run this command for the server setup.

```
./setup.sh -u <username>
```

## server_setup.sh
Set up the server DB and copies the php files to the correct location on the node. It has to be run on the node.

```
./server_setup.sh
```

## server_qos_setup.sh
Installs the qos module. It has to be run on the laptop, not on the nodes.

```
./server_qos_setup.sh -u <username>
```

## server_iptables_setup.sh
Setup the iptables rules at the server. It has to be run at the server node.
```
./server_iptables_setup.sh
```