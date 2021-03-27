SNApp Setup Tool

![](https://i.imgur.com/o1fLzMl.png)

# `Daedalus SNAppCrafter` [![Release 1.1](https://img.shields.io/badge/Release-1.1-green.svg)](https://github.com/necro-nemesis/raspap-webgui/releases)

Daedalus SNAppCrafter is an easy to use Lokinet webserver set up tool to rapidly configure a hidden service (SNApp) on a Linux based system which support .deb packages. The installer can configure a hosted webserver for Lokinet using Nginx or can be used to create one on a local machine running Debian, Raspberry OS or Armbian. This allows anyone to host their own privacy website using Lokinet network. After installing a fresh image, running the script and following the installers instructions the device is ready to launch your website providing you with your individual Loki address.

![](https://i.imgur.com/IVkovK4.png)

![](https://i.imgur.com/xnKPFd3.png)

![](https://i.imgur.com/KDYFjEu.png)

## Contents

 - [Prerequisites](#prerequisites)
 - [Preparing the image](#preparing-the-image)
 - [SBC (single board computer) Instructions](#sbc-single-board-computer-instructions)
 - [Accessing the device](#accessing-the-device)
 - [Quick installer](#quick-installer)
 - [Creating your unique SNApp](#creating-your-unique-snapp)
 - [Starting and Stopping the Webserver](#starting-and-stopping-the-webserver)
 - [Support us](#support-us)
 - [How to contribute](#how-to-contribute)
 - [License](#license)

## Prerequisites

Start with a fresh install of Debian on your system or server. Daedalus will install Nginx as a dependency to run the webserver. If you have already have Apache installed it will need it's service stopped or the Apache package removed. Be sure to back up any directories that may hold any previous websites before running the script as it will overwrite any previous files held in tradtional Linux served directories. It is possible to run SNApps using Apache but for simplicy of automating the install Nginx was chosen to be installed by Daedalus and used to host SNApps.

### SBC (single board computer) Instructions

Start with a clean install of [Armbian](https://www.armbian.com/) or [Raspbian](https://www.raspberrypi.org/downloads/raspbian/) (currently Buster and Stretch are verified as working). Lite versions are recommended. If using Raspbian Buster elevate to root with ```sudo su``` before running the Daedalus-SNAppCrafter installer script. For Armbian you will start already elevated to root on login so ```sudo su``` is not required.

For Orange Pi R1 use Armbian Buster found here: https://www.armbian.com/orange-pi-r1/. Recommend using "minimal" which is available for direct download at the bottom of the page or much faster download by .torrent also linked there.

For OrangePi Zero use Armbian Buster found here": https://www.armbian.com/orange-pi-zero/

To burn the image to an SD card on your PC you can use Etcher:
https://www.balena.io/etcher/

### Preparing the image

For Raspbian you will need to remove the SD card from the computer, reinsert it, open the boot directory up and create a new textfile file named `ssh` with no .txt file extension i.e. just `ssh` in order to remotely connect. This step is not required for Armbian.

Insert the SD card into the device and power it up.

### Accessing the device

Obtain a copy of Putty and install it on your PC:
https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html

1.  Log into your router from your PC and find the address it assigned to the Pi.

2.  Start Putty up and enter this obtained address into Putty with settings:

    Host Name Address = the address obtained from router | Port `22` | connection type `SSH` | then `OPEN`

    For Raspbian the default login is `pi` password `raspberry`
    For Armbian the default login is `root` password `1234`

3.  Follow any first user password instructions provided once logged in.

4. If you want to get the lastest updates before installing Daedalus-SNAppCrafter:
```
sudo apt-get update
sudo apt-get upgrade
sudo reboot
```
With the prerequisites done, you can now proceed with the Quick installer.

## Quick installer

Install Daedalus-SNAppCrafter from shell prompt:
```sh
$ wget -q https://git.io/JepoL -O /tmp/snapp && bash /tmp/snapp
```
The installer will update, locate, install and configure all the prerequisites for you. You will be prompted to create a new user account. In future this account and it's associate SNApp directory is used to hold your SNApp files that nginx serves. Enter a username and password, the script will automatically create and elevate privileges of this user account to root while generating the SNApp folder at /home/$USER/snapp.

At the end of the install process you will be presented with your Lokinet address. Either by starting the test server by answer "Y" or exiting the script "N" it will allow you to highlight the address and copy/paste this to clipboard or plug it directly into your browser to test your server. Remember to have Lokinet running on the computer you are using to test the site. Lokinet privately and anonymously only communicates with Lokinet.

## Creating your unique SNApp

SNApps are placed in the /home/$USER/snapp directory "$USER" being substituted by the name of the user you created. The index.html file is there for initial testing. Either move it to another name or remove it and replace it with your own files. If you are using an SBC to host and have a computer that can read the SD card partitions you can simply copy over your SNApp files to the folder on the sd card otherwise sftp into the server and transfer the files you require. As shown in the image above you can use a program like FileZilla to sftp in then navigate to the directory of the SNApp on your pc and the aforementioned SNApp directory on the server then transfer the files to the server.

## Starting and Stopping the Webserver

Nginx installs as a service. If you need to restart the service to host different content then you will need to restart nginx's service this can be done by using the following cli entry.

```sudo systemctl restart nginx```

ensure when testing for changes you clear the browser cache to freshly reload the site.

## Support us

Daedalus-SNAppCrafter is free software, but powered by your support. If you find it beneficial or wish to contribute to inspire ongoing development your donations of any amount; be they even symbolic, are a show of approval and are greatly appreciated.

Oxen Donation Address:
```sh
LA8VDcoJgiv2bSiVqyaT6hJ67LXbnQGpf9Uk3zh9ikUKPJUWeYbgsd9gxQ5ptM2hQNSsCaRETQ3GM9FLDe7BGqcm4ve69bh
```
![](https://i.imgur.com/HGVuijh.jpg) ![](https://i.imgur.com/6dMgBVr.jpg) ![](https://i.imgur.com/gIhGB1X.jpg)

## How to contribute

1. File an issue in the repository, using the bug tracker, describing the
   contribution you'd like to make. This will help us to get you started on the
   right foot.
2. Fork the project in your account and create a new branch:
   `your-great-feature`.
3. Commit your changes in that branch.
4. Open a pull request, and reference the initial issue in the pull request
   message.

## License
See the [LICENSE](./LICENSE) file.
