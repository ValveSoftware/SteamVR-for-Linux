## SteamVR Release Notes and Known Issues

**This is a development release**. It is intended to allow developers to start creating SteamVR content for Linux platforms. Limited hardware support is provided, and pre-release drivers are required. **Linux support is currently only available in the "beta" branch**, make sure you are using SteamVR[beta] before reporting issues.

**SteamVR on Linux is only supported on the latest version of the Steam Beta Client**. Make sure you are opted into the public Beta of the Steam client or SteamVR will not run due to missing dependencies.

**SteamVR and VR apps require a special build of the 64-bit Vulkan loader, which is included in the Steam Runtime**. Make sure a system copy of libvulkan isn't being picked up by SteamVR or the games, which might involve disabling STEAM_RUNTIME_PREFER_HOST_LIBRARIES if you have a libvulkan installed on your system.

For discussions and questions, please use the SteamVR for Linux forum at http://steamcommunity.com/app/250820/discussions/5/.

For bugs, please file an issue on this github issue tracker. https://github.com/ValveSoftware/SteamVR-for-Linux/issues

## GRAPHICS DRIVER REQUIREMENTS

SteamVR is built on top of the Vulkan API and requires the latest Vulkan drivers. 

**NVIDIA cards require version 375.27.xx of the NVIDIA Developer Beta Driver**. This can be downloaded from https://developer.nvidia.com/vulkan-driver. A Debian packaged version of this driver can be found in the "NVIDIA Development Drivers" PPA at https://launchpad.net/~mamarley/+archive/ubuntu/nvidia-dev/+packages. If you're also  using the graphics-drivers PPA, make sure the nvidia-dev PPA is pinned higher to use its driver over the nvidia-375 package in the graphics-drivers PPA. Thanks to Michael Marley for maintaining this PPA! Add the PPA with the following:

```
sudo add-apt-repository ppa:mamarley/nvidia-dev
```

AUR packages providing the NVIDIA Developer Beta Driver are available for Arch Linux thanks to [gehneo on the SteamVR for Linux forum](http://steamcommunity.com/app/250820/discussions/5/133257959063392200/). Install with the following:

```
yaourt -S nvidia-vulkan-developer-beta lib32-nvidia-libgl-vulkan-developer-beta
```

The NVIDIA driver supports direct mode, meaning the HMD will not appear on your desktop, or if it does, the display will have to be turned off in xrandr before being able to use VR.

The latest driver in NVIDIA's stable branch has a higher version number, but will not work. You need the driver from the vulkan development branch that is at almost exactly version 375.27.xx.

**AMD graphics require a specific tree of the radv driver**. Use the **radv-wip-steamvr** branch of this repository: https://github.com/airlied/mesa. It doesn't support direct mode currently, so the HMD display will have to be positioned on your desktop in extended mode, and your system compositor disabled while using VR.
 
**Intel graphics are not currently supported**.

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

## UNITY DEVELOPMENT

**Linux OpenVR development requires version 5.6 of Unity**. This can be downloaded from https://unity3d.com/unity/beta. Only the Vulkan renderer is currently supported on Linux. To select the Vulkan renderer, go to Edit->Project Settings->Player. Uncheck "Auto Graphics API for Linux" and add "Vulkan (Experimental)" to the Graphics APIs for Linux option.

If you are using the Unity SteamVR plugin, **download the latest plugin from the Unity Asset Store** at https://www.assetstore.unity3d.com/en/#!/content/32647. Older versions of the plugin do not support Linux.

There is a known issue with the Lab Renderer adaptive quality and Unity 5.6. If your project is using the SteamVR Lab Renderer, disable adaptive quality. (select your camera, and uncheck "Adaptive Quality Enabled" on the Valve Camera script pane)

## KNOWN ISSUES
* OpenGL applications are currently too slow to use interactively; only the Vulkan Submit path is optimal. See: https://github.com/ValveSoftware/openvr/wiki/Vulkan
* Even with Vulkan applications, performance issues are still being worked on on both the runtime and the game engine side
* Desktop view in the dashboard currently doesn't work
* Power management of base stations is not currently implemented
* Headset audio device switching is not currently implemented
* The VR status window isn't currently aware of direct mode being enabled or not, so the "enable direct mode" and "disable direct mode" buttons should not be used; direct mode is automatically enabled where supported
* Firmware update of base stations is not supported (both USB and Bluetooth connections)
