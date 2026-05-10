# StudioQL — QuickLook for BrickLink Studio .io Files

A macOS QuickLook plugin that shows thumbnails and previews for BrickLink Studio 2.0 `.io` files directly in Finder and Quick Look.

The .io format is BrickLink Studio's proprietary binary format, storing brick placements, colors, and model configuration. Rendering a meaningful QuickLook preview requires parsing this format and rendering a 3D or at minimum a flat thumbnail. This QL plugin does that. 

## What it does

- **Thumbnails**: Shows the model thumbnail in Finder icon view, column view, and Cover Flow
- **Preview**: Press Space on a `.io` file to see the full model preview with version and part count

## Build & Install

```bash
./build_and_install.sh
```

Or build from Xcode with the StudioQL scheme (requires automatic signing with a development team).

## Install binaries

Download the .zip files of the release and run the first time the .app. This will register and install the plugins. 

#### Installing the Built App
Once the .app is in /Applications:

Launch the app at least once — this is mandatory; macOS will not register the extension until the host app has run.

Enable the extension — go to System Settings → Privacy & Security → Extensions → Quick Look and toggle the extension on.

Test it — select a file in Finder and press Space. 

## How it works

`.io` files are ZIP archives (encrypted with PKZIP traditional encryption) containing:
- `thumbnail.png` — rendered model preview
- `model.ldr` — LDraw model data
- `.info` — JSON metadata (version, part count)

The plugin extracts and displays the embedded thumbnail.

## Requirements

- macOS 12.0+
- Xcode 15+
- Apple Developer account (for code signing the Quick Look extensions)

