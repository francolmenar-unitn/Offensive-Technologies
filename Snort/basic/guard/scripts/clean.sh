#!/usr/bin/env bash

ssh -tt otech2ae@users.deterlab.net "ssh -tt client1.snort-2bk.OffTech 'sudo -s; rm /home/test/*.txt /home/test/*.xml;exit'; exit"; exit
ssh -tt otech2ae@users.deterlab.net "ssh -tt client2.snort-2bk.OffTech 'sudo -s; rm /home/test/*.txt /home/test/*.xml;exit'; exit"; exit
ssh -tt otech2ae@users.deterlab.net "ssh -tt outsider.snort-2bk.OffTech 'sudo -s; rm /home/test/*.txt /home/test/*.xml;exit'; exit"; exit