#!/usr/bin/env python3
"""
design/icon/candidates/final.png（1024×1024）から、各プラットフォームのアイコンを生成する。

  python3 design/icon/generate.py [source.png]

生成先:
  - flutter_app/ios/Runner/Assets.xcassets/AppIcon.appiconset/  （Contents.json の全サイズ）
  - flutter_app/android/app/src/main/res/mipmap-*/ic_launcher.png（レガシー）
  - flutter_app/android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml + 前景/背景（アダプティブ）
  - flutter_app/web/favicon.png, web/icons/Icon-*.png
  - web/public/favicon.png, apple-touch-icon.png, icon-512.png
"""
import json
import sys
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
SRC = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "design/icon/candidates/final.png"

master = Image.open(SRC).convert("RGBA")
assert master.size == (1024, 1024), f"1024x1024 が必要です: {master.size}"

# iOS は透過を許さないので、不透明化した RGB 版を作る
opaque = Image.new("RGB", master.size, (0, 0, 0))
opaque.paste(master, mask=master.split()[3])


def save(img: Image.Image, size: int, path: Path, *, rgb: bool = False) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    out = img.resize((size, size), Image.LANCZOS)
    if rgb:
        out = out.convert("RGB")
    out.save(path, optimize=True)
    print(f"  {path.relative_to(ROOT)}  {size}x{size}")


# ---------------------------------------------------------------- iOS
print("iOS:")
ios_dir = ROOT / "flutter_app/ios/Runner/Assets.xcassets/AppIcon.appiconset"
contents = json.loads((ios_dir / "Contents.json").read_text())
seen = set()
for entry in contents["images"]:
    name = entry["filename"]
    if name in seen:
        continue
    seen.add(name)
    pt = float(entry["size"].split("x")[0])
    scale = int(entry["scale"].rstrip("x"))
    px = int(round(pt * scale))
    save(opaque, px, ios_dir / name, rgb=True)

# ---------------------------------------------------------------- Android
print("Android:")
res = ROOT / "flutter_app/android/app/src/main/res"
for dpi, px in {"mdpi": 48, "hdpi": 72, "xhdpi": 96, "xxhdpi": 144, "xxxhdpi": 192}.items():
    save(opaque, px, res / f"mipmap-{dpi}" / "ic_launcher.png", rgb=True)

# アダプティブアイコン: 108dp キャンバスに全面（full-bleed）で置く。
# 中央 72dp（66%）がセーフゾーンなので、主要図形を中央 70〜80% に収めたデザインならそのまま使える。
for dpi, px in {"mdpi": 108, "hdpi": 162, "xhdpi": 216, "xxhdpi": 324, "xxxhdpi": 432}.items():
    save(master, px, res / f"mipmap-{dpi}" / "ic_launcher_foreground.png")

# 背景色は左上ピクセルから採る（グラデーションでも端の色で自然につながる）
r, g, b, _ = master.getpixel((8, 8))
bg_hex = f"#{r:02X}{g:02X}{b:02X}"
(res / "values").mkdir(exist_ok=True)
colors_xml = res / "values/ic_launcher_background.xml"
colors_xml.write_text(
    '<?xml version="1.0" encoding="utf-8"?>\n<resources>\n'
    f'    <color name="ic_launcher_background">{bg_hex}</color>\n</resources>\n'
)
print(f"  {colors_xml.relative_to(ROOT)}  ({bg_hex})")
anydpi = res / "mipmap-anydpi-v26"
anydpi.mkdir(exist_ok=True)
adaptive_xml = (
    '<?xml version="1.0" encoding="utf-8"?>\n'
    '<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">\n'
    '    <background android:drawable="@color/ic_launcher_background"/>\n'
    '    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>\n'
    '</adaptive-icon>\n'
)
(anydpi / "ic_launcher.xml").write_text(adaptive_xml)
print(f"  {(anydpi / 'ic_launcher.xml').relative_to(ROOT)}")

# ---------------------------------------------------------------- Flutter web
print("Flutter web:")
fweb = ROOT / "flutter_app/web"
save(master, 64, fweb / "favicon.png")
for px in (192, 512):
    save(master, px, fweb / "icons" / f"Icon-{px}.png")
    save(master, px, fweb / "icons" / f"Icon-maskable-{px}.png")

# ---------------------------------------------------------------- React web
print("React web:")
rweb = ROOT / "web/public"
save(master, 64, rweb / "favicon.png")
save(master, 180, rweb / "apple-touch-icon.png")
save(master, 512, rweb / "icon-512.png")

print("done.")
