Enabling OS boot serial console and setting connection parameters
=================================================================

# Intro
-------
* Instructions is written for Voyage Linux, but steps shown here should work
for another Linux distributions
* Used serial connection parameters: `baudrate`: 115200, `data bits`: 8,
`parity`: none, `stop bits`: 1
* Used text editor is `nano`, but it can be any another text editor e.g. `vi`
* Root user is recommended

# Enabling sending OS boot logs via serial console
--------------------------------------------------

Often sending OS boot logs via serial console is disabled as default setting.
To enable that function `menu.lst` file has to be edited. To do that follow
the steps below.

1. Login to Linux Voyage. Default login/password: `root`/`voyage`.

2. After logging to Voyage Linux filesystem is mounted as `read-only`. To
    change that type:

    ```
    remountrw
    ```

3. Open `menu.lst` file with any text editor. E.g:

    ```
    nano /boot/grub/menu.lst
    ```

4. Find the settings of configuration from grub menu which you choose. The
    structure should look like:

    ```
    title           Debian GNU/Linux, kernel 3.10.11
    root            (hd0,0)
    kernel          /boot/vmlinuz-3.10.11 root=UUID=f45cf8c7-311e-47d6-88d0-a3a8861f37be ro
    initrd          /boot/initrd.img-3.10.11
    ```

5. Add to the kernel line following options:

    ```
    vga=normal console=tty0 console=ttyS0,115200n8
    ```

    After that step settings of selected configuration should look like:

    ```
    title           Debian GNU/Linux, kernel 3.10.11
    root            (hd0,0)
    kernel          /boot/vmlinuz-3.10.11 root=UUID=f45cf8c7-311e-47d6-88d0-a3a8861f37be ro console=ttyS0,115200n8
    initrd          /boot/initrd.img-3.10.11
    ```

6. Save the changes and close the file. For `nano` it's `Ctrl+O` to save the
    file and `Ctrl+X` to exit from file.

7. Now you can reboot the system and check that OS boot logs appear in serial
    console:

```
reboot
```

# Changing serial console connection parameters
-----------------------------------------------

1. Login to Linux Voyage. Default login/password: `root`/`voyage`.

2. After logging to Voyage Linux filesystem is mounted as `read-only`. To
    change that type:

    ```
    remountrw
    ```

3. Turn on serial redirection in the GRUB. To do that open `grub.conf` file
    with any text editor. There can be no `grub.conf` file in your OS. Opening
    text editor with correctly chosen directory and file name will create it
    automatically:

    ```
    nano /boot/grub/grub.conf
    ```

    Then add lines shown below to the file:

    ```
    serial --unit=1 --speed=19200
    terminal --timeout=8 console serial
    ```

    Save the changes and exit from the file (for `nano`: `Ctrl+O` next `Ctrl+X`).

4. Enable serial output from the Linux kernel. That step is descibed
    [above](#enabling-sending-OS-boot-logs-via-serial-console).

5. Turn on logging in via the serial console. Edit file named `inittab`:

    ```
    nano /etc/inittab
    ```

    Find uncommented line which looks similar to the shown below:

    ```
    T0:23:respawn:/sbin/getty -L ttyS0 115200
    ```

    The last parameter is responsible for the set baudrate. In the example that
    value is set to `115200`. You can change it to the wanted baudrate.

    >There can be more uncommented lines as indicated.

    Save the changes and exit from the file.

6. Now you can reboot system and check that serial console baudrate was
    correctly changed:

    ```
    reboot
    ```

    > If you are using serial console to perform steps from this instruction take
    a note that you should change connection parameters in used serial terminal
    (e.g. `minicom`) too. Because characters won't be shown correctly after
    `reboot`.
