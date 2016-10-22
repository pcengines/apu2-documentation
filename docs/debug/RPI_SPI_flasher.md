### RPI flasher

1. Flashing Jessie image to RPI2:

  ```
  unzip Jessie.zip
  sudo time dd if=jessie20160302.dmg of=/dev/mmcblk0 bs=16M
  sudo sh -c "while true; do killall -USR1 dd; sleep 10; done"
  ```

2. Connect to RPI2 via SSH:

  ```
  sudo ssh -i keys/rpi_key pi@192.168.1.33
  ```

3. Getting the latest flashrom source code:


  ```
  sudo apt-get update && sudo apt-get dist-upgrade && reboot
  sudo apt-get install build-essential pciutils usbutils libpci-dev libusb-dev libftdi1 libftdi-dev zlib1g-dev subversion
  svn co svn://flashrom.org/flashrom/trunk ~/flashrom
  cd ~/flashrom
  make
  sudo make install
  ```

4. Sending `coreboot.rom` files to RPI:

  ```
  sudo rsync -avz -e "ssh -i /home/user/keys/rpi_key" /home/user/Desktop/coreboot pi@192.168.1.33:/home/pi/
  ```

5. Flashing:

If SPI device is not visible, enable SPI in:

  ```
  sudo raspi-config
  ```

  spi_bcmxxxx may differ on different devices
  
  ```
  sudo modprobe spi_bcm2835
  sudo modprobe spidev
  ```
  Read from flash:
  
  sudo flashrom -V -p linux_spi:dev=/dev/spidev0.0 -r test_A.rom



