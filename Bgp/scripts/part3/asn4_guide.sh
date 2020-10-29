#!/usr/bin/env bash
telnet localhost bgpd

enable   #type "test" when prompted for password
config terminal
router bgp 65004
no network 10.1.0.0/16
network 10.1.1.0/24
end
exit
