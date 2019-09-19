#### How To Collect a Gpuvis Capture:

##### First time setup:

1. Open SteamVR Settings
2. Click 'Developer'
3. Ensure the 'Enable GPU profiling' checkbox is checked
4. Restart SteamVR
5. Follow the xterm prompt to complete the gpu profiler setup

##### Performing a gpuvis capture:
1. Open VRmonitor Menu -> Developer -> Debug Commands
2. Click on the 'gpu\_profiler\_capture' button
  * Note: Try to activate the capture process while the issue is happening.
  * The gpuvis profiler only keeps a few seconds of buffered data in memory.
3. In gpuvis, click 'File'->'Save as'
4. Save the file to a location you can access
4. Upload the file to Google Drive, Dropbox or your preferred file sharing site.
5. Copy URL and paste it in the issue template

Alternative to step 1-2:
  * Execute `kill -10 $(pgrep -f gpu-trace)` on the commandline

#### How To Collect a Perf Top Snapshot:
1. Run 'sudo perf top' from the commandline
2. Copy the output to the clipboard when the issue occurs
4. Browse to https://gist.github.com/
5. Click in the text entry box (by the 1)
6. Paste clipboard contents
7. Click 'Create Public Gist'
8. Copy URL and paste it in the issue template
