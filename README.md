# SteamVR Release Notes and Known Issues

**This is a development release**. It is intended to allow developers to start creating SteamVR content for Linux platforms. Limited hardware support is provided.

**SteamVR and VR apps require at least a 1.0.54 64-bit Vulkan loader, such as the one included in the Steam Runtime**.

For discussions and questions, please use the SteamVR for Linux forum at http://steamcommunity.com/app/250820/discussions/5/.

For bugs, please file an issue on this github issue tracker. https://github.com/ValveSoftware/SteamVR-for-Linux/issues

## Index FAQ

 * The Index speakers are not working, how can I fix this?
   * See the graphics drivers requirements section. Nvidia and AMD have issued driver updates to address this problem.

## GRAPHICS DRIVER REQUIREMENTS

SteamVR is built on top of the Vulkan API and requires the latest Vulkan drivers.

### NVIDIA

**NVIDIA cards require version 430.26 of the NVIDIA Driver or above and to use
the SteamVR Beta**.

An Ubuntu-packaged version of this driver can be found in the "Graphics
Drivers" PPA at https://launchpad.net/~graphics-drivers/+archive/ubuntu/ppa.

```
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt install nvidia-driver-430 # Or any desired version number
```

### AMD

**SteamVR requires a minimum of Mesa 17.3 compiled with vulkan support and Linux
kernel 4.13**.


**Direct Mode requires a minimum of X.org server 1.20, Linux kernel 4.15 and Mesa 18.2**.

**The Index HMD requires the Linux kernel version: 5.3+ for audio support.
Additionally, the following point releases also contain the fix for Index
audio: 5.2.3+, 5.1.21+, or 4.19.62+**

Ubuntu 18.04's HWE graphic stack provides the above requirements:
```
sudo apt install linux-generic-hwe-18.04 xserver-xorg-hwe-18.04 mesa-vulkan-drivers mesa-vulkan-drivers:i386
```

The "SteamVR Experimental Graphics" PPA at https://launchpad.net/~kisak/+archive/ubuntu/steamvr is also available to help test new driver features.

**Before using this PPA, make sure conflicting PPAs like oibaf is not installed.**

To setup "SteamVR Experimental Graphics" run:
```
sudo add-apt-repository ppa:kisak/steamvr
sudo apt update
sudo apt dist-upgrade
sudo apt install linux-generic-steamvr-20.04 mesa-vulkan-drivers mesa-vulkan-drivers:i386
```

Provide your user password when requested and reboot after the last command
completes to ensure the driver has updated correctly.

### Intel

Intel graphics are not currently supported.

## USB DEVICE REQUIREMENTS

**SteamVR needs to be able to access the HTC Vive's USB devices**. On most Linux distributions this is not allowed by default. The latest version (1.0.0.54) of the Steam package available on http://store.steampowered.com will automatically install udev rules that allow this. However, many distributions repackage Steam. If you have installed one of those packages, you may not have the latest Steam udev rules. **Your udev rules should be in the file /lib/udev/rules.d/60-steam-vr.rules and contain the following rules**: https://github.com/ValveSoftware/steam-devices/blob/master/60-steam-vr.rules

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
