# SteamVR Release Notes and Known Issues

**This is a development release**. It is intended to allow developers to start creating SteamVR content for Linux platforms. Limited hardware support is provided.

**SteamVR and VR apps require at least a 1.0.54 64-bit Vulkan loader, such as the one included in the Steam Runtime**.

For discussions and questions, please use the SteamVR for Linux forum at http://steamcommunity.com/app/250820/discussions/5/.

For bugs, please file an issue on this github issue tracker. https://github.com/ValveSoftware/SteamVR-for-Linux/issues

## GRAPHICS DRIVER REQUIREMENTS

SteamVR is built on top of the Vulkan API and requires the latest Vulkan drivers.

### NVIDIA

**NVIDIA cards require version 387.12 of the NVIDIA Driver or above and to use
the SteamVR Beta**.

An Ubuntu-packaged version of this driver can be found in the "Graphics
Drivers" PPA at https://launchpad.net/~graphics-drivers/+archive/ubuntu/ppa.

```
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt install nvidia-driver-396 # Or any desired version number
```

### AMD

**SteamVR requires a minimum of Mesa 17.3 compiled with vulkan support and Linux
kernel 4.13**.

**Direct Mode requires a minimum of X.org server 1.20, Linux kernel 4.15 and Mesa 18.2**.

An Ubuntu-packaged version of this driver can be found in the "SteamVR Experimental Graphics" PPA
at https://launchpad.net/~kisak/+archive/ubuntu/steamvr

**If using this PPA, make sure a conflicting PPA like oibaf or padoka are not installed.**

To setup "SteamVR Experimental Graphics" run:
```
sudo add-apt-repository ppa:kisak/steamvr
sudo apt dist-upgrade
sudo apt install linux-generic-steamvr-18.04 xserver-xorg-hwe-18.04 mesa-vulkan-drivers mesa-vulkan-drivers:i386
```

Provide your user password when requested and reboot after the last command
completes to ensure the driver has updated correctly.

### Intel

Intel graphics are not currently supported.

## USB DEVICE REQUIREMENTS

**SteamVR needs to be able to access the HTC Vive's USB devices**. On most Linux distributions this is not allowed by default. The latest version (1.0.0.54) of the Steam package available on http://store.steampowered.com will automatically install udev rules that allow this. However, many distributions repackage Steam. If you have installed one of those packages, you may not have the latest Steam udev rules. **Your udev rules should be in the file /lib/udev/rules.d/60-HTC-Vive-perms.rules and contain the following rules**:

```
# HTC Vive HID Sensor naming and permissioning
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="0bb4", ATTRS{idProduct}=="2c87", TAG+="uaccess"
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="28de", ATTRS{idProduct}=="2101", TAG+="uaccess"
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="28de", ATTRS{idProduct}=="2000", TAG+="uaccess"
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="28de", ATTRS{idProduct}=="1043", TAG+="uaccess"
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="28de", ATTRS{idProduct}=="2050", TAG+="uaccess"
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="28de", ATTRS{idProduct}=="2011", TAG+="uaccess"
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="28de", ATTRS{idProduct}=="2012", TAG+="uaccess"
SUBSYSTEM=="usb", ATTRS{idVendor}=="0bb4", ATTRS{idProduct}=="2c87", TAG+="uaccess"
# HTC Camera USB Node
SUBSYSTEM=="usb", ATTRS{idVendor}=="114d", ATTRS{idProduct}=="8328", TAG+="uaccess"
# HTC Mass Storage Node
SUBSYSTEM=="usb", ATTRS{idVendor}=="114d", ATTRS{idProduct}=="8200", TAG+="uaccess"
SUBSYSTEM=="usb", ATTRS{idVendor}=="114d", ATTRS{idProduct}=="8a12", TAG+="uaccess"
```

## NATIVE DEVELOPMENT

Version 1.0.7 of the OpenVR SDK has full support for Linux platforms: https://github.com/ValveSoftware/openvr

## RUNTIME REQUIREMENTS

SteamVR applications must run within the Steam runtime which supplies all the required shared libraries. 

    ~/.steam/steam/ubuntu12_32/steam-runtime/run.sh ./my_steamvr_app

will launch the application in the correct environment. See https://github.com/ValveSoftware/steam-runtime for more information about the Steam Runtime.

## UNREAL ENGINE

Unreal Engine 4.16+ has support for SteamVR on Linux, using the OpenGL RHI (GL4 SM5)

Starting with Unreal Engine 4.19, we recommend using the Vulkan RHI for VR, which requires a patch to the engine. See https://github.com/EpicGames/UnrealEngine/pull/4730 for details. For 4.20, this patch is also required: https://github.com/EpicGames/UnrealEngine/pull/5019

## UNITY DEVELOPMENT

Unity development is not currently supported.

## KNOWN ISSUES
* Even with Vulkan applications, performance issues are still being worked on on both the runtime and the game engine side
* ~~Desktop view in the dashboard currently doesn't work~~ (fixed in May 8 Steam client beta)
* Power management of base stations is not currently implemented
* Headset audio device switching is not currently implemented
* The VR status window isn't currently aware of direct mode being enabled or not, so the "enable direct mode" and "disable direct mode" buttons should not be used; direct mode is automatically enabled where supported
* Firmware update of base stations is not supported (both USB and Bluetooth connections)
