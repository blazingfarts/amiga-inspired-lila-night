#!/usr/bin/env python3
"""Creates the 'Rot-Zeiger' cursor theme: Adwaita cursors with a red fill and white outline.
Erzeugt das Zeiger-Thema 'Rot-Zeiger': Adwaita-Zeiger mit roter Füllung und weißem Rand.
Reads the Adwaita cursors installed on your system, writes to ~/.local/share/icons/Rot-Zeiger."""
import os, struct, sys
SRC = '/usr/share/icons/Adwaita/cursors'
DST = os.path.expanduser('~/.local/share/icons/Rot-Zeiger/cursors')
RED = (0xE0, 0x1B, 0x24)
if not os.path.isdir(SRC):
    sys.exit('Adwaita cursors not found (' + SRC + ')')
os.makedirs(DST, exist_ok=True)

def recolor(data):
    _, _, _, n = struct.unpack('<4sIII', data[:16])
    out = bytearray(data)
    for i in range(n):
        typ, _, pos = struct.unpack('<III', data[16 + i * 12:28 + i * 12])
        if typ != 0xfffd0002:
            continue
        hs, _, _, _, w, h = struct.unpack('<IIIIII', data[pos:pos + 24])
        for k in range(w * h):
            o = pos + hs + k * 4
            b, g, r, a = out[o:o + 4]
            if a == 0:
                continue
            ur, ug, ub = [min(255, c * 255 // a) for c in (r, g, b)]
            l = (0.299 * ur + 0.587 * ug + 0.114 * ub) / 255
            nr, ng, nb = [round(RED[j] * (1 - l) + 255 * l) for j in range(3)]
            out[o], out[o + 1], out[o + 2] = nb * a // 255, ng * a // 255, nr * a // 255
    return bytes(out)

for name in os.listdir(SRC):
    s, d = os.path.join(SRC, name), os.path.join(DST, name)
    if os.path.lexists(d):
        os.remove(d)
    if os.path.islink(s):
        os.symlink(os.readlink(s), d)
    else:
        open(d, 'wb').write(recolor(open(s, 'rb').read()))
with open(os.path.join(os.path.dirname(DST), 'index.theme'), 'w') as f:
    f.write('[Icon Theme]\nName=Rot-Zeiger\nComment=Adwaita cursors, red fill, white outline\nInherits=Adwaita\n')
print('Rot-Zeiger created in', os.path.dirname(DST))
