#!/usr/bin/env python3
import re
import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SOURCE_FILES = {"MUSIC.asm", "SPACE_V1.asm", "SPACE_V2.asm", "TEST.asm"}
BITMAP_FILES = {
    "GAMELOSE.bmp",
    "STORY.bmp",
    "black.bmp",
    "gameover.bmp",
    "lose.bmp",
    "mainmenu.bmp",
    "rules.bmp",
}
SOURCE_FILES = {"src/" + name for name in SOURCE_FILES}
BITMAP_FILES = {"assets/" + name for name in BITMAP_FILES}
REPOSITORY_FILES = (
    SOURCE_FILES
    | BITMAP_FILES
    | {
        ".gitattributes",
        ".gitignore",
        "Makefile",
        "README.md",
    "docs/project-report.pdf",
        "scripts/check_repository.py",
        "scripts/stage_dos.py",
        "scripts/build_dos.py",
        "scripts/test_dos.py",
        "docker/Dockerfile",
        ".dockerignore",
    }
)


def fail(message: str) -> None:
    print(message, file=sys.stderr)
    raise SystemExit(1)


missing = sorted(
    name for name in SOURCE_FILES | BITMAP_FILES if not (ROOT / name).is_file()
)
if missing:
    fail("Missing required project files: " + ", ".join(missing))

actual_files = {
    path.relative_to(ROOT).as_posix()
    for path in ROOT.rglob("*")
    if path.is_file() and ".git" not in path.parts and "build" not in path.relative_to(ROOT).parts
}
unexpected = sorted(actual_files - REPOSITORY_FILES)
if unexpected:
    fail("Unapproved extra project files: " + ", ".join(unexpected))

for name in BITMAP_FILES:
    data = (ROOT / name).read_bytes()
    if len(data) < 54 or data[:2] != b"BM":
        fail(f"Invalid BMP header: {name}")
    width, height = struct.unpack_from("<ii", data, 18)
    if width <= 0 or height == 0:
        fail(f"Invalid BMP dimensions: {name}")

combined = "\n".join(
    (ROOT / name).read_text(encoding="utf-8", errors="ignore") for name in SOURCE_FILES
)
for marker in ["ORG 100H", "Int 10h", "mainmenu.bmp", "GAMEOVER.bmp"]:
    if marker.lower() not in combined.lower():
        fail(f"Missing expected assembly marker: {marker}")

for path in ROOT.rglob("*"):
    if ".git" in path.parts or "build" in path.relative_to(ROOT).parts or not path.is_file():
        continue
    rel = path.relative_to(ROOT).as_posix()
    if any(part.startswith("._") for part in path.parts) or path.name in {
        ".DS_Store",
        "Thumbs.db",
    }:
        fail(f"Metadata file should not be staged: {rel}")
    if path.suffix.lower() in {
        ".com",
        ".debug",
        ".list",
        ".symbol",
        ".~asm",
        ".doc",
        ".docx",
    }:
        fail(f"Generated or private artifact should not be staged: {rel}")

text_files = [
    path
    for path in ROOT.rglob("*")
    if path.is_file()
    and ".git" not in path.parts
    and path.suffix.lower() in {".asm", ".md", ".py", ""}
]
text = "\n".join(
    path.read_text(encoding="utf-8", errors="ignore") for path in text_files
)
private_markers = [
    "".join(["208", "234", "161"]),  # noqa: FLY002 - avoid matching this checker
    "/" + "Users" + "/",
    "/" + "home" + "/",
    "C:" + "\\" + "Users",
]
if (
    any(marker in text for marker in private_markers)
    or re.search(r"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+", text)
    or re.search(r"(?<!\d)\d{9}(?!\d)", text)
):
    fail("Privacy or machine-path marker found in tracked text")

print("DOS Space Invaders static checks passed.")
