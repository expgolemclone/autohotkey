"""スタンプ画像を動的生成しクリップボードにコピーする."""

import io
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
    # PNG 形式
    png_buf = io.BytesIO()
    img.save(png_buf, format="PNG")

    # BMP 形式 (白背景、CF_DIB フォールバック)
    bg = Image.new("RGB", img.size, (255, 255, 255))
    bg.paste(img, mask=img.split()[3])
    bmp_buf = io.BytesIO()
    bg.save(bmp_buf, format="BMP")

    CF_PNG = win32clipboard.RegisterClipboardFormat("PNG")

    win32clipboard.OpenClipboard()
    try:
        win32clipboard.EmptyClipboard()
        win32clipboard.SetClipboardData(CF_PNG, png_buf.getvalue())
        win32clipboard.SetClipboardData(win32clipboard.CF_DIB, bmp_buf.getvalue()[14:])
    finally:
        win32clipboard.CloseClipboard()


if __name__ == "__main__":
    stamp = draw_stamp()
    copy_to_clipboard(stamp)
