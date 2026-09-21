from pathlib import Path
import re
import subprocess

import sys
import shutil

root = Path(__file__).resolve().parents[1]
stage = Path(sys.argv[1]).resolve()
stage.mkdir(parents=True, exist_ok=True)
source=(root/'src/SPACE_V2.asm').read_text()
source=source.replace('ENDP GAMEWIN','ENDP WIN')
source=re.sub(r'(?m)^(\s*)\.\.\.',r'\1; ...',source)
source=re.sub(r'\bEND\b','GAME_EXIT',source,flags=re.I)
source=re.sub(r'(?im)^(\s*)ENDP\s+(\w+)',r'\1\2 ENDP',source)
pattern=r'(?ims)^[ \t]*\w+\s+MACRO\b.*?^[ \t]*ENDM\b[^\n]*(?:\n|$)'
macros=re.findall(pattern,source)
source=re.sub(pattern,'',source)
# EMU8086 implicit code segment and END directive are explicit for MASM/JWasm.
(stage/'game.asm').write_text('.186\n.model tiny\n.code\n'+'\n'.join(macros)+source+'\nend\n')
subprocess.run(['jwasm','-bin','-Zm','-Fo'+str(stage/'game.com'),str(stage/'game.asm')],check=True)

for path in (root/'assets').glob('*.bmp'):
    shutil.copy2(path,stage/path.name)
