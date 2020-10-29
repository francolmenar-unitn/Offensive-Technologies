#!/usr/bin/env bash

enable #type "test" when prompted for password
config terminal
router bgp 65004
network 10.1.0.0/16
end
exit
