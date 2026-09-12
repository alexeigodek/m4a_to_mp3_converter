# M4A to MP3 Converter (Windows)

Convert an entire folder of `.m4a` files to `.mp3` with a single command, including subfolders.

Perfect for quickly processing voice recordings, iPhone exports, or full audio libraries.

## What the script does

- Scans the current folder **and all subfolders**.
- Converts every `.m4a` file to `.mp3`.
- Keeps source `.m4a` files untouched.
- Automatically downloads `ffmpeg` when needed.

## Requirements

- Windows (PowerShell or CMD)
- Internet connection (first run only, to download `ffmpeg`)

## Quick start

1. Download or copy `M4A_TO_MP3_Converter.bat`.
2. Place it at the **root of the folder** that contains your `.m4a` files.
3. Double-click the `.bat` file (or run it from CMD/PowerShell in that folder).

```bat
.\M4A_TO_MP3_Converter.bat
```

The script converts all `.m4a` files found in that folder and all its subfolders.

## Output

- For `audio.m4a`, you get `audio.mp3` in the same location.
- If the `.mp3` already exists, it is not overwritten.

## Useful notes

- The script downloads a recent `ffmpeg` build, uses it for conversion, then removes the `ffmpeg` folder at the end.
- Audio quality currently used: `-q:a 8` (high compression, smaller files).  
  If you want better quality, adjust this parameter in `src/M4A_TO_MP3_Converter.bat`.

## Useful notes 2 

Updated the script to handle filenames with spaces

It will:

Automatically download FFmpeg if it isn't present
Scan the folder and all subfolders
Handle filenames containing spaces, apostrophes, &, brackets, commas, etc.
Create the MP3 beside the original M4A
Preserve metadata with -map_metadata 0
Use high-quality VBR MP3 (-q:a 2)
Not overwrite existing MP3s (-n)
Report files that fail to convert
Delete the temporary FFmpeg folder when finished

The filename errors you're seeing in the original are consistent with the way its FOR /F/call combination is parsing paths and special characters.

Usage: put the .bat file in the top-level folder containing your music, then double-click it. 
