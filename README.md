# mediafix

[Русская версия](README.ru.md)

A small terminal utility for preparing video files for DaVinci Resolve. It copies the video stream without re-encoding and converts every audio track to uncompressed PCM 24-bit little-endian at 48 kHz.

![File picker](docs/file-picker.png)

## What it does

- Keeps the video codec, resolution, frame rate, quality, stream order, and timestamps.
- Converts each audio track independently to `pcm_s24le` at 48000 Hz.
- Preserves the number of channels and, when available, language and track titles.
- Writes new `.mov` files to `~/Videos/MediaFix` and never changes the originals.
- Shows real FFmpeg progress, speed, completed files, full output paths, and useful errors.
- Skips subtitles, attachments, and extra video streams with a clear notice.
- Refuses incompatible video codecs instead of silently re-encoding them.

![Conversion result](docs/conversion-result.png)

A successful conversion verifies the output with `ffprobe`. It does not guarantee that DaVinci Resolve supports the original video codec; import compatibility must be checked in Resolve.

## Install

Requirements: Linux, Python 3, `ffmpeg`, and `ffprobe`.

```bash
sudo pacman -S ffmpeg
cd /home/mixad/mediafix
git pull
./install.sh
export PATH="$HOME/.local/bin:$PATH"
```

The installer copies one Python file and creates `mediafix` in `~/.local/bin`. It does not install Python packages globally, use `sudo` for Python, or require a server, Docker, or database.

## Run

```bash
mediafix
mediafix "video.mp4" "video 2.mkv"
```

With no arguments, use the terminal picker:

1. Move with the arrow keys and press `Enter` to open a folder.
2. Press `Space` to mark videos.
3. Press `Enter` on a marked file to start the queue.
4. Press `Backspace` to go up and `q` to quit.

Outputs are named `original_name_DR.mov`. Existing files are never overwritten; a numeric suffix is added instead.
