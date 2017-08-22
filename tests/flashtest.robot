*** Settings ***
Library         SSHLibrary

*** Test Cases ***
Open Connection and Log In
    Open Connection  %{OPI_IP}    timeout=360 seconds
    Login  root    armbian1234
    
Flash firmware
	# turn APU on and put it in S5 state
	Write    ./relays.sh ON\n
	# wait for diodes to turn off
	Sleep    7s
	# flash the APU chip
	Write    flashrom -w ./apu2_v4.6.0.rom -p linux_spi:dev=/dev/spidev1.0\n
	# contro lthe output
	Read Until     Reading old flash
	Read Until     done
	Read Until     Erase/write done.\r\n
	# sometimes flash is verified, it is not verified when flash content remains
	# unchanged, output has to be cleared by reading it
	${output}=     Read
	Run Keyword If    'Verifying flash' in "${output}"    Read Until     VERIFIED
	Sleep    5s
	# turn off APU 
	Write    ./relays.sh OFF\n
	Sleep    1s
	Close All Connections



