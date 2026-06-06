#### SteamVR Error Codes

These are error codes you may encounter within the SteamVR ecosystem. Generally, these will appear within vrmonitor (the program which actually shows you a 'SteamVR' window). If any error suggests checking a logfile, you'll find that file in the Steam logs directory. On Linux, that's `~/.steam/steam/logs/` so (for instance) if something says to check `vrcompositor.txt` then the file to look at will be `~/.steam/steam/logs/vrcompositor.txt`.

##### OpenVR Error Codes

When an OpenVR error turns up in vrmonitor, they will show up as _positive_ error codes in the status window. Rather than provide an exhaustive table here which would need to be maintained, just check [`openvr.h`](https://github.com/ValveSoftware/openvr/blob/master/headers/openvr.h) in the [OpenVR SDK](https://github.com/ValveSoftware/openvr). Look for `enum EVRInitError` to find the list.

##### vrmonitor Error Codes

These are error codes specific to vrmonitor. They will show as _negative_ error codes in the vrmonitor status window.

| Code | Name | Meaning
| ---- | ------------- | ------------------ |
| -101 | `StatusError_NoHMDAvailable` | No supported headset was found. |
| -102 | `StatusError_HMDDoesNotTrack` | Headset is not sending supported pose data. |
| -103 | `StatusError_HMDStandby` | Headset is in standby. (Not actually an error, just pick up headset and put it back on.) |
| -201 | `StatusError_NoCompositorAvailable` | SteamVR was unable to find the compositor. |
| -202 | `StatusError_CompositorNotFullscreen` | The compositor is not running in fullscreen mode. (For wired headsets that show up as a monitor.) |
| -203 | `StatusError_CompositorNotRunning` | The compositor is not running, and has probably crashed. (Look in `vrcompositor.txt` for more information.) |
| -204 | `StatusError_CompositorTooManyRunning` | There are _multiple_ compositors running. Shutdown SteamVR and kill any extra vrcompositor processes, then restart. |
| -205 | `StatusError_PrismNotRunning` | We are using prism, but it doesn't seem to be running. |
| -301 | `StatusError_VRServerNotRunning` | vrserver is not running, and has probably crashed. (Look in `vrserver.txt` for more information.) |
| -401 | `StatusError_Chaperone_Error` | The chaperone system is not running, or returning invalid data. |
| -501 | `StatusError_TrackingDevice_NotValid` | We have a tracking device in the system that doesn't seem to be connected/working. |
| -601 | `StatusError_LighthouseEvent` | A lighthouse is returning a fatal error. |

##### Steam VRLink Client Error Codes

These are a few error codes which can show up on the VR-capable Steam Link client on Quest, Pico, and so on.

| Code | Name | Meaning
| ---- | ------------- | ------------------ |
| 450 | `StreamError_HostNotResponding` | Steam Link tried to connect to the host we were told to connect to, but it didn't actually answer. **This may mean you're running a VPN on your PC; check and try turning it off if so.** |
| 451 | `StreamError_ConnectedNoVideo` | Steam Link connected, but the host is not sending any video. (Look in `driver_vrlink.txt` on the host for more information.) |
| 452 | `StreamError_ConnectedNoDecode` | Steam Link connected and is receiving video, but the local decoder is not giving back decoded frames. |
| 616 | `StreamCheck_WifiNotConnected` | Your headset doesn't seem to have a WiFi connection right now. |
| 617 | `StreamCheck_StreamNotPossible` | Your headset and your computer don't seem to be on the same network. **This may mean you're running a VPN on your Quest; check and try turning it off if so.** |
