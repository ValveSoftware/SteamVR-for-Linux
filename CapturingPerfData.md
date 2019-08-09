#### How To Collect a Gpuvis Capture:
1. Open SteamVR Settings
2. Click 'Developer'
3. Ensure the 'Enable GPU profiling' checkbox is checked
4. Restart SteamVR
5. Follow the xterm prompt to complete the gpu profiler setup
6. Open the following URL while SteamVR is running:
  * http://localhost:8998/dashboard/debugcommands.html
7. Click on the 'gpu\_profiler\_capture' button
  * Note: Try to activate the capture process while the issue is happening.
  * The gpuvis profiler only keeps a few seconds of buffered data in memory.
7. In gpuvis, click 'File'->'Save as'
8. Save the file to a location you can access
9. Upload the file to Google Drive, Dropbox or your preferred file sharing site.
10. Copy URL and paste it in the issue template

#### How To Collect a Perf Top Snapshot:
1. Run 'sudo perf top' from the commandline
2. Copy the output to the clipboard when the issue occurs
4. Browse to https://gist.github.com/
5. Click in the text entry box (by the 1)
6. Paste clipboard contents
7. Click 'Create Public Gist'
8. Copy URL and paste it in the issue template
