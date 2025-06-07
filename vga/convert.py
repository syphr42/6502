#!/usr/bin/env python3

import os
from PIL import Image

SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))
INPUT_IMAGE_FILE = os.path.join(SCRIPT_DIR, "finch.png")
OUTPUT_BIN_FILE = os.path.join(SCRIPT_DIR, "../output/rom.bin")

image = Image.open(INPUT_IMAGE_FILE)
pixels = image.load()

with open(OUTPUT_BIN_FILE, "wb") as out_file:
    for y in range(256):
        for x in range(128):
            try:
                out_file.write(bytes([pixels[x, y]]))
            except IndexError:
                out_file.write(bytes([0]))
