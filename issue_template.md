#### How To Collect SteamVR System Information:
1. Click the 'SteamVR beta' menu in the upper left of the SteamVR Status window
2. Click 'Create System Report'
3. Click 'Copy to Clipboard'
4. Browse to https://gist.github.com/
5. Click in the text entry box (by the 1)
6. Paste clipboard contents
7. Click 'Create Public Gist'
8. Add URL of your new Gist below

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
10. Paste a link to the file in the performance section below.

#### How To Collect a Perf Top Snapshot:
1. Run 'sudo perf top' from the commandline
2. Copy the output to the clipboard when the issue occurs
4. Browse to https://gist.github.com/
5. Click in the text entry box (by the 1)
6. Paste clipboard contents
7. Click 'Create Public Gist'
8. Paste a link to the gist in the performance section below.

#### Your system information
* Steam client version (build number or date): 
* Distribution (e.g. Ubuntu): 
* Graphics driver version (run nvidia-settings):
* Gist for SteamVR System Information: 
* Opted into Steam client beta?: [Yes/No]
* Opted into SteamVR beta?: [Yes/No]
* Have you checked for system updates?: [Yes/No]

#### (Optional) Performance data:
The following fields are helpful in diagnosing performance issues:
* Gpuvis capture:
* Perf top gist:

#### Please describe your issue in as much detail as possible:
Describe what you _expected_ should happen and what _did_ happen. Please link any large code pastes as a [Github Gist](https://gist.github.com/)

#### Steps for reproducing this issue:
1. 
2. 
3. 
