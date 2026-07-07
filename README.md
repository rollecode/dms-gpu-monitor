# GPU Monitor

NVIDIA GPU load as an animated progress bar in your [DankBar](https://github.com/AvengeMedia/DankMaterialShell), updated every second.

![Screenshot](Screenshot.png)

Shown next to its siblings [RAM Monitor](https://github.com/rollecode/dms-ram-monitor) and [VRAM Monitor](https://github.com/rollecode/dms-vram-monitor).

## What it does

- Compact bar pill: icon, optional label, animated progress bar and percentage
- Updates every second from `nvidia-smi --query-gpu=utilization.gpu`
- Fill follows your theme accent, turns orange above 75% and red above 90%

## Requirements

- NVIDIA GPU with the proprietary driver (`nvidia-smi` must be on PATH)

## Installation

From the DMS plugin browser (Settings, Plugins tab, Browse), or manually:

```bash
git clone https://github.com/rollecode/dms-gpu-monitor ~/.config/DankMaterialShell/plugins/gpuMonitor
```

Then enable it in Settings, Plugins, and add the widget to your bar layout in Settings, Bar.

## Settings

- **Show label**: toggle the text label between the icon and the bar (on by default)
- **Label text**: customize the label (default `GPU`)

## License

MIT
