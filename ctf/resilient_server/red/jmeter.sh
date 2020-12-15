if [ "$#" -ne 1 ];then
    echo "Usage: ./jmeter.sh <test_plan_file.jmx>";
    exit 0
fi

test_plan=$1

if ! which java &> /dev/null
then
    echo "Installing Java ..."
    sudo apt update
    sudo apt install default-jre
fi

if ! which jmeter &> /dev/null
then
    echo "Installing Jmeter ..."
    wget http://www.gtlib.gatech.edu/pub/apache/jmeter/binaries/apache-jmeter-5.3.tgz
    tar xf apache-jmeter-5.3.tgz
fi

cd apache-jmeter-5.3/bin/
./jmeter.sh -n -t $test_plan 
