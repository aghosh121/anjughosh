#!/usr/bin/env python3
"""
Create high-resolution anime-style RPG artwork for Ramayana Game
Generates character portraits, backgrounds, and UI elements
"""

from PIL import Image, ImageDraw, ImageFont
import os
import math

def create_directory(path):
    """Create directory if it doesn't exist"""
    if not os.path.exists(path):
        os.makedirs(path)

def create_gradient_background(width, height, colors, direction='vertical'):
    """Create a beautiful gradient background"""
    img = Image.new('RGB', (width, height))
    draw = ImageDraw.Draw(img)
    
    if direction == 'vertical':
        for y in range(height):
            ratio = y / height
            r = int(colors[0][0] * (1 - ratio) + colors[1][0] * ratio)
            g = int(colors[0][1] * (1 - ratio) + colors[1][1] * ratio)
            b = int(colors[0][2] * (1 - ratio) + colors[1][2] * ratio)
            draw.line([(0, y), (width, y)], fill=(r, g, b))
    else:  # horizontal
        for x in range(width):
            ratio = x / width
            r = int(colors[0][0] * (1 - ratio) + colors[1][0] * ratio)
            g = int(colors[0][1] * (1 - ratio) + colors[1][1] * ratio)
            b = int(colors[0][2] * (1 - ratio) + colors[1][2] * ratio)
            draw.line([(x, 0), (x, height)], fill=(r, g, b))
    
    return img

def create_anime_character(width, height, character_type, colors):
    """Create anime-style character portrait"""
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Character base (simplified anime style)
    if character_type == "rama":
        # Lord Rama - blue skin, golden crown, bow
        # Head
        draw.ellipse([width//4, height//6, 3*width//4, height//2], fill=(135, 206, 235))
        # Crown
        crown_points = [(width//2, height//8), (width//3, height//4), (2*width//3, height//4)]
        draw.polygon(crown_points, fill=(255, 215, 0))
        # Eyes
        draw.ellipse([width//3, height//3, width//2-10, height//2-10], fill=(255, 255, 255))
        draw.ellipse([width//2+10, height//3, 2*width//3, height//2-10], fill=(255, 255, 255))
        # Bow
        draw.arc([width//6, height//2, 5*width//6, height], start=0, end=180, fill=(139, 69, 19), width=8)
        
    elif character_type == "sita":
        # Goddess Sita - golden skin, red sari, lotus
        # Head
        draw.ellipse([width//4, height//6, 3*width//4, height//2], fill=(255, 228, 196))
        # Hair
        draw.ellipse([width//4-10, height//6-10, 3*width//4+10, height//3], fill=(139, 69, 19))
        # Eyes
        draw.ellipse([width//3, height//3, width//2-10, height//2-10], fill=(255, 255, 255))
        draw.ellipse([width//2+10, height//3, 2*width//3, height//2-10], fill=(255, 255, 255))
        # Lotus flower
        for i in range(8):
            angle = i * 45
            x = width//2 + int(20 * math.cos(math.radians(angle)))
            y = height//2 + int(20 * math.sin(math.radians(angle)))
            draw.ellipse([x-15, y-15, x+15, y+15], fill=(255, 182, 193))
            
    elif character_type == "hanuman":
        # Lord Hanuman - orange skin, mace, flying
        # Head
        draw.ellipse([width//4, height//6, 3*width//4, height//2], fill=(255, 165, 0))
        # Ears (monkey style)
        draw.ellipse([width//6, height//8, width//3, height//3], fill=(255, 165, 0))
        draw.ellipse([2*width//3, height//8, 5*width//6, height//3], fill=(255, 165, 0))
        # Eyes
        draw.ellipse([width//3, height//3, width//2-10, height//2-10], fill=(255, 255, 255))
        draw.ellipse([width//2+10, height//3, 2*width//3, height//2-10], fill=(255, 255, 255))
        # Mace
        draw.rectangle([width//2-5, height//2, width//2+5, height], fill=(139, 69, 19))
        draw.ellipse([width//2-15, height//2-15, width//2+15, height//2+15], fill=(255, 215, 0))
    
    return img

def create_rpg_ui_element(width, height, element_type, text=""):
    """Create RPG-style UI elements"""
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    if element_type == "button":
        # RPG button with gradient and border
        # Outer border
        draw.rectangle([0, 0, width-1, height-1], fill=(139, 69, 19))
        # Inner gradient
        for y in range(2, height-2):
            ratio = y / height
            r = int(255 * (1 - ratio) + 200 * ratio)
            g = int(215 * (1 - ratio) + 150 * ratio)
            b = int(0 * (1 - ratio) + 50 * ratio)
            draw.line([(2, y), (width-3, y)], fill=(r, g, b))
        # Text
        if text:
            try:
                font = ImageFont.truetype("Arial", 20)
            except:
                font = ImageFont.load_default()
            bbox = draw.textbbox((0, 0), text, font=font)
            text_width = bbox[2] - bbox[0]
            text_height = bbox[3] - bbox[1]
            x = (width - text_width) // 2
            y = (height - text_height) // 2
            draw.text((x, y), text, fill=(255, 255, 255), font=font)
            
    elif element_type == "panel":
        # RPG panel with ornate border
        # Outer border
        draw.rectangle([0, 0, width-1, height-1], fill=(139, 69, 19))
        # Inner panel
        draw.rectangle([5, 5, width-6, height-6], fill=(25, 25, 25))
        # Corner decorations
        corner_size = 15
        for corner in [(0, 0), (width-corner_size, 0), (0, height-corner_size), (width-corner_size, height-corner_size)]:
            draw.rectangle([corner[0], corner[1], corner[0]+corner_size, corner[1]+corner_size], fill=(255, 215, 0))
    
    return img

def create_title_screen():
    """Create the main title screen"""
    width, height = 1024, 768
    
    # Create background
    bg = create_gradient_background(width, height, 
                                  [(25, 25, 50), (75, 25, 100)], 'vertical')
    
    # Add some mystical particles
    draw = ImageDraw.Draw(bg)
    for i in range(50):
        x = (i * 37) % width
        y = (i * 23) % height
        size = (i % 3) + 1
        draw.ellipse([x-size, y-size, x+size, y+size], fill=(255, 255, 255, 100))
    
    # Create title text
    try:
        title_font = ImageFont.truetype("Arial", 72)
        subtitle_font = ImageFont.truetype("Arial", 36)
    except:
        title_font = ImageFont.load_default()
        subtitle_font = ImageFont.load_default()
    
    # Title with shadow effect
    title = "RAMAYANA"
    subtitle = "Divine Epic Adventure"
    
    # Shadow
    draw.text((width//2-2, height//3-2), title, fill=(0, 0, 0), font=title_font)
    # Main text
    draw.text((width//2, height//3), title, fill=(255, 215, 0), font=title_font)
    
    # Subtitle
    bbox = draw.textbbox((0, 0), subtitle, font=subtitle_font)
    subtitle_width = bbox[2] - bbox[0]
    draw.text((width//2-subtitle_width//2, height//3+100), subtitle, fill=(255, 255, 255), font=subtitle_font)
    
    return bg

def create_character_select():
    """Create character selection screen"""
    width, height = 1024, 768
    
    # Background
    bg = create_gradient_background(width, height, 
                                  [(50, 25, 75), (100, 50, 125)], 'vertical')
    
    # Character portraits
    characters = ["rama", "sita", "hanuman"]
    for i, char in enumerate(characters):
        char_img = create_anime_character(200, 300, char, None)
        x = 100 + i * 250
        y = height//2 - 150
        bg.paste(char_img, (x, y), char_img)
        
        # Character name
        draw = ImageDraw.Draw(bg)
        try:
            font = ImageFont.truetype("Arial", 24)
        except:
            font = ImageFont.load_default()
        name = char.upper()
        bbox = draw.textbbox((0, 0), name, font=font)
        name_width = bbox[2] - bbox[0]
        draw.text((x + 100 - name_width//2, y + 320), name, fill=(255, 215, 0), font=font)
    
    return bg

def create_intro_scene():
    """Create introduction scene"""
    width, height = 1024, 768
    
    # Background with ancient temple
    bg = create_gradient_background(width, height, 
                                  [(25, 25, 25), (75, 50, 25)], 'vertical')
    
    draw = ImageDraw.Draw(bg)
    
    # Temple pillars
    for i in range(5):
        x = 100 + i * 180
        # Pillar
        draw.rectangle([x, height//2, x+40, height-50], fill=(139, 69, 19))
        # Capital
        draw.rectangle([x-10, height//2-20, x+50, height//2], fill=(255, 215, 0))
    
    # Sacred fire in center
    fire_colors = [(255, 69, 0), (255, 140, 0), (255, 215, 0)]
    for i, color in enumerate(fire_colors):
        size = 50 - i * 10
        draw.ellipse([width//2-size, height//2-size, width//2+size, height//2+size], fill=color)
    
    # Introduction text
    intro_text = [
        "In the ancient land of Ayodhya,",
        "where dharma and devotion reign supreme,",
        "begins the epic tale of Lord Rama,",
        "the seventh avatar of Lord Vishnu.",
        "",
        "Join the divine adventure as you",
        "embark on a journey through the",
        "sacred pages of the Ramayana."
    ]
    
    try:
        font = ImageFont.truetype("Arial", 28)
    except:
        font = ImageFont.load_default()
    
    y_start = 100
    for line in intro_text:
        bbox = draw.textbbox((0, 0), line, font=font)
        line_width = bbox[2] - bbox[0]
        x = (width - line_width) // 2
        draw.text((x, y_start), line, fill=(255, 215, 0), font=font)
        y_start += 40
    
    return bg

def main():
    """Generate all artwork"""
    print("🎨 Creating high-resolution anime-style RPG artwork for Ramayana Game...")
    
    # Create output directory
    output_dir = "RamayanaGame/Assets.xcassets/GameArt.imageset"
    create_directory(output_dir)
    
    # Generate artwork
    artworks = [
        ("title_screen", create_title_screen()),
        ("character_select", create_character_select()),
        ("intro_scene", create_intro_scene())
    ]
    
    for name, img in artworks:
        # Save main image
        img_path = f"{output_dir}/{name}.png"
        img.save(img_path, "PNG")
        print(f"✅ Created {name}.png")
        
        # Create @2x version for high-res displays
        img_2x = img.resize((img.width * 2, img.height * 2), Image.Resampling.LANCZOS)
        img_2x_path = f"{output_dir}/{name}@2x.png"
        img_2x.save(img_2x_path, "PNG")
        print(f"✅ Created {name}@2x.png")
    
    # Create Contents.json for the imageset
    contents_json = '''{
  "images" : [
    {
      "filename" : "title_screen.png",
      "idiom" : "universal",
      "scale" : "1x"
    },
    {
      "filename" : "title_screen@2x.png",
      "idiom" : "universal",
      "scale" : "2x"
    },
    {
      "filename" : "character_select.png",
      "idiom" : "universal",
      "scale" : "1x"
    },
    {
      "filename" : "character_select@2x.png",
      "idiom" : "universal",
      "scale" : "2x"
    },
    {
      "filename" : "intro_scene.png",
      "idiom" : "universal",
      "scale" : "1x"
    },
    {
      "filename" : "intro_scene@2x.png",
      "idiom" : "universal",
      "scale" : "2x"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}'''
    
    with open(f"{output_dir}/Contents.json", "w") as f:
        f.write(contents_json)
    
    print("🎨 All artwork created successfully!")
    print("📁 Files saved to: RamayanaGame/Assets.xcassets/GameArt.imageset/")

if __name__ == "__main__":
    main()
