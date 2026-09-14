import os
import subprocess
from typing import List
from urllib.parse import unquote

from gi.repository import GObject, Nautilus

LAUNCHER = os.path.expanduser("~/.local/bin/mediafix-open-terminal")
VIDEO_EXTENSIONS = {".mp4", ".mkv", ".mov", ".avi", ".mxf", ".webm", ".ts", ".mts", ".m2ts", ".flv", ".wmv", ".mpg", ".mpeg", ".m4v", ".3gp"}


class MediafixNautilus(GObject.GObject, Nautilus.MenuProvider):
    @staticmethod
    def path(file: Nautilus.FileInfo) -> str:
        uri = file.get_uri()
        return unquote(uri[7:]) if uri.startswith("file://") else ""

    def activate(self, menu: Nautilus.MenuItem, files: List[Nautilus.FileInfo]) -> None:
        paths = [self.path(file) for file in files]
        paths = [path for path in paths if path]
        if paths:
            subprocess.Popen([LAUNCHER, *paths], start_new_session=True,
                             stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

    def get_file_items(self, files: List[Nautilus.FileInfo]) -> List[Nautilus.MenuItem]:
        if not files or any(file.get_uri_scheme() != "file" for file in files):
            return []
        if any(file.is_directory() or not self.is_video(self.path(file)) for file in files):
            return []
        item = Nautilus.MenuItem(
            name="MediafixNautilus::prepare",
            label="Подготовить для DaVinci Resolve (mediafix)",
        )
        item.connect("activate", self.activate, files)
        return [item]

    @staticmethod
    def is_video(path: str) -> bool:
        return os.path.splitext(path)[1].lower() in VIDEO_EXTENSIONS
