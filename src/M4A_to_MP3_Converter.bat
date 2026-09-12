@echo off
REM M4A to MP3 Batch Converter
REM Based on the original script by Timothy Cuenat
REM Fixed filename/path handling and recursive conversion

SETLOCAL EnableExtensions DisableDelayedExpansion

set "currentDirectory=%CD%"
set "ffmpegBaseUrl=https://www.gyan.dev/ffmpeg/builds"
set "ffmpegLastReleaseZip=ffmpeg-release-essentials.zip"
set "ffmpegLastReleaseUrl=%ffmpegBaseUrl%/%ffmpegLastReleaseZip%"
set "ffmpegFilter=ffmpeg*"
set "sourceFilesExtensionFfmpegFilter=*.m4a"

echo=
echo=  __  __ _  _     _      _____ ___     __  __ ____ _____     ____                          _
echo= ^|  \/  ^| ^|^| ^|   / \    ^|_   _/ _ \   ^|  \/  ^|  _ \___ /    / ___^|___  _ ____   _____ _ __^| ^|_ ___ _ __
echo= ^| ^|\/^| ^| ^|^| ^|_ / _ \     ^| ^|^| ^| ^| ^|  ^| ^|\/^| ^| ^|_) ^|^|_ \   ^| ^|   / _ \^| '_ \ \ / / _ \ '__^| __/ _ \ '__^|
echo= ^| ^|  ^| ^|__   _/ ___ \    ^| ^|^| ^|_^| ^|  ^| ^|  ^| ^|  __/___) ^|  ^| ^|__^| (_) ^| ^| ^| \ V /  __/ ^|  ^| ^|^|  __/ ^|
echo= ^|_^|  ^|_^|  ^|_^|/_/   \_\   ^|_^| \___/   ^|_^|  ^|_^|_^|  ^|____/    \____\___/^|_^| ^|_^|\_/ \___^|_^|   \__\___^|_^|
echo=--------------------------------------------------------------------------------------------------------
echo= M4A to MP3 Converter
echo=

call :downloadOrProcess
pause >NUL
goto :eof


:downloadOrProcess
call :searchDirectory "%ffmpegFilter%" ffmpegFolder
set "ffmpegApp=%currentDirectory%\%ffmpegFolder%\bin\ffmpeg.exe"

if exist "%ffmpegApp%" (
    call :convertProcess "%ffmpegApp%"
) else (
    call :downloadFfmpeg
    call :downloadOrProcess
)
EXIT /B 0


:searchDirectory
set "%~2="
FOR /D %%F IN (%~1) DO (
    set "%~2=%%~nxF"
    goto :searchDirectoryFound
)
:searchDirectoryFound
EXIT /B 0


:downloadFfmpeg
echo Downloading FFMPEG
echo=
curl -# -L -o "%ffmpegLastReleaseZip%" "%ffmpegLastReleaseUrl%"

if exist "%ffmpegLastReleaseZip%" (
    echo=
    echo=Download COMPLETE
    echo=Unzipping FFMPEG .zip
    tar -xf "%ffmpegLastReleaseZip%"
    echo=Removing FFMPEG .zip
    del /q "%ffmpegLastReleaseZip%"
) else (
    echo=
    echo=Download failed
)
EXIT /B 0


:convertProcess
echo=Converting process started!
echo=Converting all .m4a files in all subfolders
echo=
echo=Output quality: MP3 VBR -q:a 2
echo=

REM Recursively find every M4A file.
REM All paths are quoted so spaces, apostrophes, ampersands, brackets, etc.
REM in filenames are handled correctly.

FOR /R "%currentDirectory%" %%F IN (*.m4a) DO (
    echo= - %%F
    "%~1" -i "%%F" -map_metadata 0 -c:a libmp3lame -q:a 2 "%%~dpnF.mp3" -hide_banner -loglevel error -stats -n
    if errorlevel 1 (
        echo=   ERROR converting: %%F
    ) else (
        echo=   OK
    )
    echo=
)

cd /d "%currentDirectory%"
call :deleteFfmpeg

echo=--------------------------
echo=^| Convert process FINISH ^
echo=--------------------------
echo=
EXIT /B 0


:deleteFfmpeg
echo=Deleting FFMPEG
cd /d "%currentDirectory%"
if defined ffmpegFolder (
    rmdir /s /q "%currentDirectory%\%ffmpegFolder%" 2>NUL
)
EXIT /B 0
