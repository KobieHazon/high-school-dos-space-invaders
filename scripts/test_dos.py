import os
from pathlib import Path
import shutil
import subprocess
import time

import sys
import tempfile

root=Path(__file__).resolve().parents[1]
scratch=tempfile.TemporaryDirectory(prefix="dos-game-")
stage=Path(scratch.name)
subprocess.run([sys.executable,str(root/'scripts/build_dos.py'),str(stage)],check=True)
output=stage/'screenshots'
output.mkdir()
process=subprocess.Popen(['dosbox','-c','mount c '+str(stage),'-c','c:','-c','game.com','-c','exit'],stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
try:
    window=''
    for _ in range(50):
        result=subprocess.run(['xdotool','search','--name','DOSBox'],capture_output=True,text=True)
        if result.returncode==0:
            window=result.stdout.splitlines()[-1];break
        time.sleep(.1)
    assert window,'DOSBox window not found'
    time.sleep(2)
    subprocess.run(['import','-window',window,str(output/'menu.png')],check=True)
    print(subprocess.check_output(['xdotool','getwindowgeometry',window],text=True))
    subprocess.run(['xdotool','windowfocus',window],check=True)
    subprocess.run(['xdotool','mousemove','--window',window,'320','200','click','1'],check=True)
    time.sleep(.3)
    subprocess.run(['xdotool','mousemove_relative','--','-240','-120'],check=True)
    time.sleep(.3)
    subprocess.run(['xdotool','mousedown','1'],check=True)
    time.sleep(.3)
    subprocess.run(['xdotool','mouseup','1'],check=True)
    time.sleep(1)
    subprocess.run(['import','-window',window,str(output/'story.png')],check=True)
    subprocess.run(['xdotool','mousemove_relative','--','180','120'],check=True)
    time.sleep(.3)
    subprocess.run(['xdotool','mousedown','1'],check=True)
    time.sleep(.3)
    subprocess.run(['xdotool','mouseup','1'],check=True)
    time.sleep(1)
    subprocess.run(['import','-window',window,str(output/'play.png')],check=True)
    subprocess.run(['xdotool','key','--window',window,'Right','Right','space'],check=True)
    time.sleep(.5)
    subprocess.run(['import','-window',window,str(output/'input.png')],check=True)
finally:
    process.terminate()
    try:process.communicate(timeout=3)
    except subprocess.TimeoutExpired:process.kill();process.communicate()

def pixels(name):
    raw=subprocess.check_output(['convert',str(output/(name+'.png')),'-depth','8','RGB:-'])
    assert len(raw)==640*400*3
    return [tuple(raw[i:i+3]) for i in range(0,len(raw),3)]
menu,story,play,after=[pixels(name) for name in ('menu','story','play','input')]
assert len(set(menu)) > 50 and len(set(story)) > 50, 'Bitmap screens were not rendered'
assert sum(a!=b for a,b in zip(menu,story)) > 640*400//3, 'Play did not open the story'
assert sum(max(rgb)<20 for rgb in play) > 640*400*.9, 'Gameplay did not start'
def hero_x(frame):
    points=[i%640 for i,(r,g,b) in enumerate(frame) if i//640>300 and g>150 and r<120 and b<120]
    assert len(points)>200, 'Hero was not drawn'
    return sum(points)/len(points)
assert hero_x(after)>hero_x(play), 'Right-arrow input did not move the hero'
assert sum(r>150 and g<120 and b<120 for r,g,b in after)>10, 'Shot was not drawn'
scratch.cleanup()
print('PASS: assembled game, menu bitmap, story transition, gameplay, right-arrow movement and shooting')
