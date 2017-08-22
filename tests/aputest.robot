# Usage:
# S2N_PORT=<telnet port> PXE_SRV_IP=<server IP> robot -b debug.log -L TRACE aputest.robot


*** settings ***
Library    Telnet
Library    String
*** Test Cases ***
Enable iPXE
    # provide ser2net port where serial was redirected
    Open Connection    localhost    port=%{S2N_PORT}
    Set Encoding    errors=strict
    # wait for configuration menu
    Set Timeout    60
    ${output}=    Read Until    Save configuration and exit
    # get the line responsible for iPXE and get rid of annoying EOLs
    ${lines}=    Get Lines Containing String    ${output}    Network/PXE boot - Currently Disabled
    # enable iPXE if disabled
    Run Keyword If   'Network/PXE boot - Currently Disabled' in "${lines}"   Write Bare    n
    Run Keyword If   'Network/PXE boot - Currently Disabled' in "${lines}"   Read Until    Save configuration and exit
    # save configuration either changed or not
    Write Bare    s
    
Enter iPXE shell
    # find string indicating network booting is enabled
    Read Until    N for PXE boot
    # use n/N to enter network boot menu
    Write Bare    n
    Read Until    Booting from ROM
    Read Until    autoboot
    # move arrow up to choose iPXE shell position
    # https://github.com/pcengines/apu2-documentation/blob/master/ipxe/menu.ipxe
    Write Bare    \x1b[A
    Read Until    ipxe shell
    # press enter
    Write Bare    \n
    # make sure we are inside iPXE shell
    Read Until    iPXE> \x1b[?25h

Download and boot pxelinux
    # request IP address
    Write Bare Slow  dhcp net0\n
    Read Until    ok
    Read Until    iPXE>
    # provide pxelinux filename on PXE server
    Write Bare Slow  set filename pxelinux.0\n
    Read Until    iPXE>
    # provide PXE server IP address
    Write Bare Slow  set next-server %{PXE_SRV_IP}\n
    Read Until    iPXE>
    # download and boot pxelinux
    Write Bare Slow  chain tftp://\${next-server}/\${filename}\n
    Read Until    PXE server boot menu

Boot diskless Debian 
    # choose nfs option
    Write Bare    r
    Read Until    NFS
    # enter
    Write Bare    \n
    Read Until    ready

Login into Debian
    # wait until login prompt and disable encoding errors
    Set Encoding  errors=ignore
    Set Timeout   120
    Read Until    login:
    # try to log in
    Write Bare Slow    apu
    Write Bare    \n
    Read Until    Password:
    Write Bare Slow    apu
    Write Bare    \n
    # check prompt
    Set Timeout   15
    Read Until    apu@pcengines:~$
    Close Connection
