#!/bin/bash
#make script executable with chmod u+x ASCII-encoding.sh
#to run the script use the command ./ASCII-encoding.sh

#ssh into snort node
ssh snort.snort-2bk.OffTech.isi.deterlab.net

cd /usr/local/snort-2.9.2.2/src/dynamic-examples/dynamic-preprocessor
sudo cp -r /usr/local/snort-2.9.2.2/src/dynamic-preprocessors/include/ ..
sudo make
sudo make install

#run snort
echo "Provide path to config file: "
read path
sudo snort --daq nfq -Q -v -c path

#in case of errors:
#sudo mkdir snort in var/log
#sudo touch alert in snort
