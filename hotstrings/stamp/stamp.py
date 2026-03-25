"""スタンプ画像を動的生成しクリップボードにコピーする."""

import struct
from datetime import date

import win32clipboard
from PIL import Image, ImageDraw, ImageFont

WIDTH, HEIGHT = 75, 75
RED = (220, 40, 40, 255)
TRANSPARENT = (0, 0, 0, 0)
FONT_PATH = "C:/Windows/Fonts/msgothic.ttc"
BORDER_WIDTH = 2


def draw_stamp() -> Image.Image:
    img = Image.new("RGBA", (WIDTH, HEIGHT), TRANSPARENT)
    draw = ImageDraw.Draw(img)

    # 円形の枠線
    draw.ellipse(
        [1, 1, WIDTH - 2, HEIGHT - 2],
        outline=RED,
        width=BORDER_WIDTH,
    )

    # フォント
    font_name = ImageFont.truetype(FONT_PATH, 18)
    font_date = ImageFont.truetype(FONT_PATH, 11)

    # 当日の日付
    today = date.today().strftime("%Y/%m/%d")

    # テキスト描画(中央揃え)
    cx = WIDTH // 2

    draw.text((cx, 17), "藤田", fill=RED, font=font_name, anchor="mm")
    draw.text((cx, 38), today, fill=RED, font=font_date, anchor="mm")
    draw.text((cx, 58), "充人", fill=RED, font=font_name, anchor="mm")

    # 日付の上下に横線
    draw.line([(15, 28), (60, 28)], fill=RED, width=1)
    draw.line([(15, 48), (60, 48)], fill=RED, width=1)

    return img


def copy_to_clipboard(img: Image.Image) -> None:
    # RGBA -> RGB (白背景)
    bg = Image.new("RGB", img.size, (255, 255, 255))
    bg.paste(img, mask=img.split()[3])

    # BGR バイト列を取得し、BMP の bottom-to-top 順に並べ替え
    w, h = bg.size
    row_bytes = w * 3
    stride = (row_bytes + 3) & ~3
    pad = stride - row_bytes

    raw = bg.tobytes("raw", "BGR")
    rows = [raw[i * row_bytes : (i + 1) * row_bytes] + b"\x00" * pad for i in range(h)]
    rows.reverse()
    pixel_data = b"".join(rows)

    # BITMAPINFOHEADER (40 bytes)
    header = struct.pack(
        "<IiiHHIIiiII",
        40, w, h, 1, 24, 0, len(pixel_data), 0, 0, 0, 0,
    )

    win32clipboard.OpenClipboard()
    try:
        win32clipboard.EmptyClipboard()
        win32clipboard.SetClipboardData(win32clipboard.CF_DIB, header + pixel_data)
    finally:
        win32clipboard.CloseClipboard()


if __name__ == "__main__":
    stamp = draw_stamp()
    copy_to_clipboard(stamp)
