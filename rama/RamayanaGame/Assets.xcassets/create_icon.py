#!/usr/bin/env python3
from PIL import Image, ImageDraw, ImageFont
import os

def create_icon(size, filename):
    # Create a new image with purple to orange gradient
    img = Image.new('RGB', (size, size), color='purple')
    draw = ImageDraw.Draw(img)
    
    # Create a simple gradient effect
    for y in range(size):
        # Interpolate between purple and orange
        r = int(128 + (y / size) * 127)  # Purple to orange
        g = int(0 + (y / size) * 165)    # Purple to orange  
        b = int(128 + (y / size) * 127)  # Purple to orange
        draw.line([(0, y), (size, y)], fill=(r, g, b))
    
    # Add a white "R" in the center
    try:
        # Try to use a system font
        font_size = size // 3
        font = ImageFont.truetype("/System/Library/Fonts/Arial.ttf", font_size)
    except:
        # Fallback to default font
        font = ImageFont.load_default()
    
    text = "R"
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    
    x = (size - text_width) // 2
    y = (size - text_height) // 2
    
    draw.text((x, y), text, fill='white', font=font)
    
    # Save the image
    img.save(filename, 'PNG')
    print(f"Created: {filename}")

# Create icons for different sizes
icon_sizes = [
    (40, "20x20@2x.png"),    # 20x20 @2x
    (60, "20x20@3x.png"),    # 20x20 @3x
    (58, "29x29@2x.png"),    # 29x29 @2x
    (87, "29x29@3x.png"),    # 29x29 @3x
    (80, "40x40@2x.png"),    # 40x40 @2x
    (120, "40x40@3x.png"),   # 40x40 @3x
    (120, "60x60@2x.png"),   # 60x60 @2x
    (180, "60x60@3x.png"),   # 60x60 @3x
    (152, "76x76@2x.png"),   # 76x76 @2x
    (167, "83.5x83.5@2x.png"), # 83.5x83.5 @2x
    (1024, "1024x1024@1x.png") # 1024x1024 @1x
]

output_dir = "RamayanaGame/Assets.xcassets/AppIcon.appiconset"

for size, filename in icon_sizes:
    filepath = os.path.join(output_dir, filename)
    create_icon(size, filepath)

print("Icon generation complete!")
