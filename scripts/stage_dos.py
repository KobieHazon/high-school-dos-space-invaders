"""Stage byte-identical source and assets together for historical DOS tools."""
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DESTINATION = ROOT / "build" / "dos"
DESTINATION.mkdir(parents=True, exist_ok=True)
sources = sorted((ROOT / "src").glob("*.asm")) + sorted((ROOT / "assets").glob("*.bmp"))
for source in sources:
    shutil.copyfile(source, DESTINATION / source.name)
print(f"Staged {len(sources)} source and asset files under build/dos; no assembler or game was run.")
