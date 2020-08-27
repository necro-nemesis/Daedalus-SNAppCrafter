# SNApp-PI-HOST
Scripted SNApp hosting on a Pi

![](https://i.imgur.com/ywSbzAz.png)

## Prerequisites
Start with a clean install of [Armbian](https://www.armbian.com/) or [Raspbian](https://www.raspberrypi.org/downloads/raspbian/) (currently Buster and Stretch are verified as working). Lite versions are recommended. If using Raspbian Buster you will need to run the command ```sudo apt-get update --allow-releaseinfo-change``` then elevate to root with ```sudo su``` before running the LokiAP installer script. These additional steps are not required when using Armbian.

For Orange Pi R1 use Armbian Buster found here: https://www.armbian.com/orange-pi-r1/. Recommend using "minimal" which is available for direct download at the bottom of the page or much faster download by .torrent also linked there.

Specific code has been incorporated to take advantage of the OrangePi R1's second ethernet interface. The AP will provide access via ethernet in addition to wifi when using this board.

For OrangePi Zero use Armbian Buster found here": https://www.armbian.com/orange-pi-zero/

To burn the image to an SD card on your PC you can use Etcher:
https://www.balena.io/etcher/

## Preparing the image

For Raspbian you will need to remove the SD card from the computer, reinsert it, open the boot directory up and create a new textfile file named `ssh` with no .txt file extension i.e. just `ssh` in order to remotely connect. This step is not required for Armbian.

Insert the SD card into the device and power it up.

## Accessing the device

Obtain a copy of Putty and install it on your PC:
https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html

1.  Log into your router from your PC and find the address it assigned to the Pi.

2.  Start Putty up and enter this obtained address into Putty with settings:

    Host Name Address = the address obtained from router | Port `22` | connection type `SSH` | then `OPEN`

    For Raspbian the default login is `root` password `raspberry`
    For Armbian the default login is `root` password `1234`

3.  Follow any first user password instructions provided once logged in.

4. If you want to get the lastest updates before installing SNApp-PI-HOST:
```
sudo apt-get update
sudo apt-get upgrade
sudo reboot
```
With the prerequisites done, you can now proceed with the Quick installer.

Now conitnue from [README.md#Quick installer](Quick installer section) of README.md
