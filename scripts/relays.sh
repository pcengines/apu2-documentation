#modprobe gpio-sunxi

if ! [ -f /sys/class/gpio/gpio6/value ]; then 
	echo 6 > /sys/class/gpio/export
	echo out > /sys/class/gpio/gpio6/direction
#  	 echo 0 > /sys/class/gpio/gpio6/value
fi

if ! [ -f /sys/class/gpio/gpio7/value ]; then 
        echo 7 > /sys/class/gpio/export
        echo out > /sys/class/gpio/gpio7/direction
#        echo 0 > /sys/class/gpio/gpio7/value
fi

if ! [ -f /sys/class/gpio/gpio19/value ]; then 
        echo 19 > /sys/class/gpio/export
        echo out > /sys/class/gpio/gpio19/direction
#        echo 0 > /sys/class/gpio/gpio19/value
fi

if ! [ -f /sys/class/gpio/gpio18/value ]; then 
        echo 18 > /sys/class/gpio/export
        echo out > /sys/class/gpio/gpio18/direction
#        echo 0 > /sys/class/gpio/gpio18/value
fi

if ! [ -f /sys/class/gpio/gpio2/value ]; then 
        echo 2 > /sys/class/gpio/export
        echo out > /sys/class/gpio/gpio2/direction
#        echo 0 > /sys/class/gpio/gpio2/value
fi

if ! [ -f /sys/class/gpio/gpio10/value ]; then 
        echo 10 > /sys/class/gpio/export
        echo out > /sys/class/gpio/gpio10/direction
#        echo 0 > /sys/class/gpio/gpio10/value
fi

if ! [ -f /sys/class/gpio/gpio3/value ]; then 
        echo 3 > /sys/class/gpio/export
        echo out > /sys/class/gpio/gpio3/direction
#        echo 0 > /sys/class/gpio/gpio3/value
fi



#if ! [ -f /sys/class/gpio/gpio13/value ]; then
#	echo 13 > /sys/class/gpio/export
#	echo out > /sys/class/gpio/gpio13/direction
#	echo 0 > /sys/class/gpio/gpio13/value
#fi



#if [ "$1" == 1  ]; then
#    if [ "$2" == "ON"   ]; then
#       echo 0 > /sys/class/gpio/gpio198/value
#    elif [ "$2" == "OFF"   ]; then
#        echo 1 > /sys/class/gpio/gpio198/value
#    else
#        echo "Incorrect argument. Available options: ON, OFF"
#    fi
#
#elif [ "$1" == 2  ]; then
#    if [ "$2" == "ON"   ]; then
#        echo 0 > /sys/class/gpio/gpio13/value
#    elif [ "$2" == "OFF"   ]; then
#        echo 1 > /sys/class/gpio/gpio13/value
#    else
#        echo "Incorrect argument. Available options: ON, OFF"
#    fi
#else
#    echo "Incorrect relay number. Available relays: 1, 2"
#    echo "Corrent syntax: <relay_number> <ON/OFF>"
#fi

if [ "$1" == ON ]; then
	echo 0 > /sys/class/gpio/gpio7/value
	echo 0 > /sys/class/gpio/gpio19/value
	echo 0 > /sys/class/gpio/gpio18/value
	echo 0 > /sys/class/gpio/gpio2/value
	echo 0 > /sys/class/gpio/gpio10/value
	echo 0 > /sys/class/gpio/gpio3/value
	sleep 0.5
	echo 0 > /sys/class/gpio/gpio6/value
elif [ "$1" == OFF ]; then
	echo 1 > /sys/class/gpio/gpio7/value
        echo 1 > /sys/class/gpio/gpio19/value
        echo 1 > /sys/class/gpio/gpio18/value
        echo 1 > /sys/class/gpio/gpio2/value
        echo 1 > /sys/class/gpio/gpio10/value
        echo 1 > /sys/class/gpio/gpio3/value
        sleep 0.5
        echo 1 > /sys/class/gpio/gpio6/value
else
	echo "Incorrect parameter. Available options: ON, OFF"
fi
