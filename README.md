# Arc Raiders Tools (AHK v2 Overlay)

A lightweight AutoHotkey v2 overlay for Arc Raiders that provides instant item identification, value lookups, and crafting recipes using screen scraping (OCR).

## Features

- **Always-on-Top Overlay:** Unobtrusive, transparent, click-through overlay.
- **Template Matching:** Automatically finds tooltips using image recognition.
- **Instant Scan:** Press `Ctrl+D` to scan and identify items.
- **Smart Lookup:** Uses fuzzy matching to find items even with OCR typos.
- **Rich Data:** Displays item Value, Weight, and Crafting Recipes.
- **Performance Optimized:** Scans only the tooltip area, not the entire screen.

## Prerequisites

- **AutoHotkey v2:** Download and install from [autohotkey.com](https://www.autohotkey.com/).
- **Arc Raiders Data:** Ensure the `arcraiders-data` repository is cloned/located alongside the `src` folder.

## Installation

1.  Clone this repository.
2.  Ensure your folder structure looks like this:
    ```
    /ProjectRoot
      /arcraiders-data  <-- JSON data files here
      /src              <-- This tool's source code
        main.ahk
    ```

## Usage

1.  Run `src/main.ahk` (Double-click or run from command line).
2.  The overlay will appear at the top-left of your screen.
3.  **In Game:**
    - **Hover your mouse** over an item (tooltip will appear)
    - Press **Ctrl+D** to scan
    - The tool automatically finds the tooltip using the action icons
    - The overlay will update with the item's details
    - Works automatically - no configuration needed!
4.  **Toggle Overlay:** Press **F12** to show/hide the overlay.

## How It Works

The tool uses **template matching** to locate tooltips:

1. When you press `Ctrl+D`, it searches for the "actions" icon row (from `actions.png`)
2. Once found, it scans the area directly below the icons (where tooltip text is)
3. OCR extracts the text from that specific region
4. Fuzzy matching identifies the item and displays its information

This approach is **fast** (scans ~240,000 pixels instead of 2M+) and **reliable** (works regardless of tooltip position on screen).

## Hotkeys

- **F12** - Toggle overlay visibility
- **Ctrl+D** - Scan for items and display information

## Configuration

The tool automatically saves its scan area configuration in `config.json`. You can manually adjust these values if needed:

- `ScanOffsetX` - Horizontal offset from template (default: 0)
- `ScanOffsetY` - Vertical offset from template (default: 40)
- `ScanWidth` - Width of scan region (default: 600)
- `ScanHeight` - Height of scan region (default: 400)

## Troubleshooting

- **"Template not found":** The tool can't find the action icons. Ensure tooltips are visible and try adjusting in-game graphics settings. The tool will fall back to scanning the full screen.
- **"No match found":** The scanned text might be garbled. Ensure good lighting/contrast in-game.
- **"Scanner Error":** Check that `actions.png` exists in the `src/` directory.
- **Overlay not visible:** Press `F12`. Ensure the game is in "Borderless Windowed" mode if "Fullscreen" prevents the overlay from drawing on top.
- **Slow performance:** If template matching is slow, try adjusting the ImageSearch variation parameter in `Scanner.ahk` (line 72).

## Dependencies

- **Descolada/OCR:** Included in `src/Lib/OCR.ahk`.
