# Changelog

### 1.2.0: 2026-07-17

* Pin Temp and Fan under Idle, always on top: temperature in celsius, fan as a percentage, bars read as global scale with the usual colour thresholds
* Show each row's own unit instead of forcing %

### 1.1.0: 2026-07-17

* Add a popout listing per-process GPU load, biggest first, with a kill icon on each process
* Pin Idle to the top of the list in the accent colour. Idle comes from the GPU-wide utilisation, not from 100 minus the sum: unlike memory, per-process `sm%` does not partition
* Show a second, dimmer word per process: the script for interpreters, the working directory for shells, the subprocess type for Electron apps. `pmon` truncates its own command column and picks up argv, so names come from `/proc/<pid>/comm`
* Add a slider for how many rows the popout lists, 5 to 60, default 30
* Only collect the list while the popout is open

### 1.0.0: 2026-07-07

* Initial release: GPU load as an animated progress bar in the DankBar, updated every second
