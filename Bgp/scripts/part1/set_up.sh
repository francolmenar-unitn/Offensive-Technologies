#!/bin/bash
############### Remove a specific route injected by the kernel - asn1 & as2 ###############

ssh -tt otech2ae@users.deterlab.net "ssh -tt asn2.BGN.OffTech 'sudo ip route del 10.1.1.0/24'"
ssh -tt otech2ae@users.deterlab.net "ssh -tt asn3.BGN.OffTech 'sudo ip route del 10.1.1.0/24'"

