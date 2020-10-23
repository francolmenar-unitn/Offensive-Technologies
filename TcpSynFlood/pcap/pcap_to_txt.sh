#!/bin/bash

tshark -n -r pcap/output.pcap -E separator=\;  -E header=y -T fields \
-e frame.time_epoch \
-e ip.proto \
-e ip.src \
-e ip.dst \
-e tcp.srcport \
-e tcp.dstport \
 -e tcp.flags > pcap/pcap.txt