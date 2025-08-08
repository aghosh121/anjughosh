#!/usr/bin/env python3
"""
Create high-resolution anime-style RPG sprites for Ramayana Game
Based on the reference style with blue-skinned Rama and red-skinned demons
"""

from PIL import Image, ImageDraw, ImageFont
import os
import math

def create_directory(path):
    """Create directory if it doesn't exist"""
    if not os.path.exists(path):
        os.makedirs(path)

def create_rama_sprite(width, height):
    """Create Lord Rama sprite based on the reference style"""
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Body proportions
    head_radius = width // 6
    body_width = width // 3
    body_height = height // 2
    
    # Blue skin color (like reference)
    skin_color = (135, 206, 235)  # Light blue
    hair_color = (25, 25, 112)    # Dark blue
    clothing_color = (255, 165, 0) # Orange sash
    bow_color = (139, 69, 19)     # Brown bow
    
    # Head
    head_x = width // 2
    head_y = height // 4
    draw.ellipse([head_x - head_radius, head_y - head_radius, 
                   head_x + head_radius, head_y + head_radius], 
                  fill=skin_color, outline=(0, 0, 0), width=2)
    
    # Hair (flowing style like reference)
    hair_points = [
        (head_x - head_radius, head_y - head_radius),
        (head_x - head_radius - 10, head_y - head_radius - 15),
        (head_x - head_radius - 5, head_y - head_radius - 25),
        (head_x + head_radius + 5, head_y - head_radius - 20),
        (head_x + head_radius + 10, head_y - head_radius - 10),
        (head_x + head_radius, head_y - head_radius)
    ]
    draw.polygon(hair_points, fill=hair_color)
    
    # Eyes
    eye_radius = head_radius // 4
    draw.ellipse([head_x - head_radius//2 - eye_radius, head_y - eye_radius//2,
                   head_x - head_radius//2 + eye_radius, head_y + eye_radius//2], 
                  fill=(255, 255, 255), outline=(0, 0, 0))
    draw.ellipse([head_x + head_radius//2 - eye_radius, head_y - eye_radius//2,
                   head_x + head_radius//2 + eye_radius, head_y + eye_radius//2], 
                  fill=(255, 255, 255), outline=(0, 0, 0))
    
    # Pupils
    pupil_radius = eye_radius // 2
    draw.ellipse([head_x - head_radius//2 - pupil_radius, head_y - pupil_radius//2,
                   head_x - head_radius//2 + pupil_radius, head_y + pupil_radius//2], 
                  fill=(0, 0, 0))
    draw.ellipse([head_x + head_radius//2 - pupil_radius, head_y - pupil_radius//2,
                   head_x + head_radius//2 + pupil_radius, head_y + pupil_radius//2], 
                  fill=(0, 0, 0))
    
    # Body (torso)
    body_x = width // 2
    body_y = head_y + head_radius + body_height//2
    draw.rectangle([body_x - body_width//2, body_y - body_height//2,
                    body_x + body_width//2, body_y + body_height//2], 
                   fill=skin_color, outline=(0, 0, 0), width=2)
    
    # Orange sash (like reference)
    sash_width = body_width + 10
    sash_height = body_height // 3
    draw.rectangle([body_x - sash_width//2, body_y - sash_height//2,
                    body_x + sash_width//2, body_y + sash_height//2], 
                   fill=clothing_color, outline=(0, 0, 0), width=1)
    
    # Arms
    arm_width = body_width // 4
    arm_height = body_height // 2
    
    # Left arm (holding bow)
    left_arm_x = body_x - body_width//2 - arm_width//2
    left_arm_y = body_y
    draw.rectangle([left_arm_x - arm_width//2, left_arm_y - arm_height//2,
                    left_arm_x + arm_width//2, left_arm_y + arm_height//2], 
                   fill=skin_color, outline=(0, 0, 0), width=1)
    
    # Right arm (drawing bow)
    right_arm_x = body_x + body_width//2 + arm_width//2
    right_arm_y = body_y - arm_height//4
    draw.rectangle([right_arm_x - arm_width//2, right_arm_y - arm_height//2,
                    right_arm_x + arm_width//2, right_arm_y + arm_height//2], 
                   fill=skin_color, outline=(0, 0, 0), width=1)
    
    # Bow (recurve style like reference)
    bow_center_x = left_arm_x
    bow_center_y = left_arm_y + arm_height//2
    bow_width = width // 2
    bow_height = height // 3
    
    # Bow curve
    bow_points = [
        (bow_center_x - bow_width//2, bow_center_y),
        (bow_center_x - bow_width//3, bow_center_y - bow_height//2),
        (bow_center_x, bow_center_y - bow_height//3),
        (bow_center_x + bow_width//3, bow_center_y - bow_height//2),
        (bow_center_x + bow_width//2, bow_center_y)
    ]
    draw.line(bow_points, fill=bow_color, width=8)
    
    # Bowstring
    draw.line([(bow_center_x - bow_width//2, bow_center_y), 
               (bow_center_x + bow_width//2, bow_center_y)], 
              fill=(255, 255, 255), width=2)
    
    # Arrow
    arrow_length = bow_width // 2
    draw.line([(bow_center_x - arrow_length//2, bow_center_y),
               (bow_center_x + arrow_length//2, bow_center_y)], 
              fill=(139, 69, 19), width=3)
    
    # Legs
    leg_width = body_width // 3
    leg_height = body_height // 2
    
    # Left leg
    left_leg_x = body_x - leg_width
    left_leg_y = body_y + body_height//2 + leg_height//2
    draw.rectangle([left_leg_x - leg_width//2, left_leg_y - leg_height//2,
                    left_leg_x + leg_width//2, left_leg_y + leg_height//2], 
                   fill=skin_color, outline=(0, 0, 0), width=1)
    
    # Right leg
    right_leg_x = body_x + leg_width
    right_leg_y = body_y + body_height//2 + leg_height//2
    draw.rectangle([right_leg_x - leg_width//2, right_leg_y - leg_height//2,
                    right_leg_x + leg_width//2, right_leg_y + leg_height//2], 
                   fill=skin_color, outline=(0, 0, 0), width=1)
    
    return img

def create_demon_sprite(width, height):
    """Create demon sprite based on the reference style"""
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Body proportions
    head_radius = width // 5
    body_width = width // 2.5
    body_height = height // 1.8
    
    # Red skin color (like reference)
    skin_color = (220, 20, 60)    # Crimson red
    hair_color = (139, 0, 0)      # Dark red
    clothing_color = (101, 67, 33) # Brown loincloth
    weapon_color = (139, 69, 19)   # Brown weapon
    
    # Head (larger and more muscular)
    head_x = width // 2
    head_y = height // 3
    draw.ellipse([head_x - head_radius, head_y - head_radius, 
                   head_x + head_radius, head_y + head_radius], 
                  fill=skin_color, outline=(0, 0, 0), width=3)
    
    # Horns
    horn_points = [
        (head_x - head_radius//2, head_y - head_radius),
        (head_x - head_radius//2 - 10, head_y - head_radius - 20),
        (head_x - head_radius//2 - 5, head_y - head_radius - 30)
    ]
    draw.polygon(horn_points, fill=(139, 69, 19))
    
    horn_points2 = [
        (head_x + head_radius//2, head_y - head_radius),
        (head_x + head_radius//2 + 10, head_y - head_radius - 20),
        (head_x + head_radius//2 + 5, head_y - head_radius - 30)
    ]
    draw.polygon(horn_points2, fill=(139, 69, 19))
    
    # Hair (spiky demon style)
    for i in range(5):
        spike_x = head_x - head_radius + i * head_radius//2
        spike_y = head_y - head_radius - 10
        spike_points = [
            (spike_x, spike_y),
            (spike_x - 5, spike_y - 15),
            (spike_x + 5, spike_y - 15)
        ]
        draw.polygon(spike_points, fill=hair_color)
    
    # Eyes (angry red)
    eye_radius = head_radius // 3
    draw.ellipse([head_x - head_radius//2 - eye_radius, head_y - eye_radius//2,
                   head_x - head_radius//2 + eye_radius, head_y + eye_radius//2], 
                  fill=(255, 0, 0), outline=(0, 0, 0), width=2)
    draw.ellipse([head_x + head_radius//2 - eye_radius, head_y - eye_radius//2,
                   head_x + head_radius//2 + eye_radius, head_y + eye_radius//2], 
                  fill=(255, 0, 0), outline=(0, 0, 0), width=2)
    
    # Pupils (white for demonic look)
    pupil_radius = eye_radius // 2
    draw.ellipse([head_x - head_radius//2 - pupil_radius, head_y - pupil_radius//2,
                   head_x - head_radius//2 + pupil_radius, head_y + pupil_radius//2], 
                  fill=(255, 255, 255))
    draw.ellipse([head_x + head_radius//2 - pupil_radius, head_y - pupil_radius//2,
                   head_x + head_radius//2 + pupil_radius, head_y + pupil_radius//2], 
                  fill=(255, 255, 255))
    
    # Fangs
    fang_width = 8
    fang_height = 15
    draw.polygon([(head_x - 10, head_y + head_radius//2),
                  (head_x - 10 - fang_width//2, head_y + head_radius//2 + fang_height),
                  (head_x - 10 + fang_width//2, head_y + head_radius//2 + fang_height)], 
                 fill=(255, 255, 255))
    draw.polygon([(head_x + 10, head_y + head_radius//2),
                  (head_x + 10 - fang_width//2, head_y + head_radius//2 + fang_height),
                  (head_x + 10 + fang_width//2, head_y + head_radius//2 + fang_height)], 
                 fill=(255, 255, 255))
    
    # Body (muscular)
    body_x = width // 2
    body_y = head_y + head_radius + body_height//2
    draw.rectangle([body_x - body_width//2, body_y - body_height//2,
                    body_x + body_width//2, body_y + body_height//2], 
                   fill=skin_color, outline=(0, 0, 0), width=3)
    
    # Brown loincloth
    cloth_width = body_width + 10
    cloth_height = body_height // 4
    draw.rectangle([body_x - cloth_width//2, body_y + body_height//2 - cloth_height,
                    body_x + cloth_width//2, body_y + body_height//2], 
                   fill=clothing_color, outline=(0, 0, 0), width=2)
    
    # Arms (muscular)
    arm_width = body_width // 3
    arm_height = body_height // 1.5
    
    # Left arm
    left_arm_x = body_x - body_width//2 - arm_width//2
    left_arm_y = body_y
    draw.rectangle([left_arm_x - arm_width//2, left_arm_y - arm_height//2,
                    left_arm_x + arm_width//2, left_arm_y + arm_height//2], 
                   fill=skin_color, outline=(0, 0, 0), width=2)
    
    # Right arm (clenched fist)
    right_arm_x = body_x + body_width//2 + arm_width//2
    right_arm_y = body_y
    draw.rectangle([right_arm_x - arm_width//2, right_arm_y - arm_height//2,
                    right_arm_x + arm_width//2, right_arm_y + arm_height//2], 
                   fill=skin_color, outline=(0, 0, 0), width=2)
    
    # Clenched fist
    fist_radius = arm_width // 2
    draw.ellipse([right_arm_x - fist_radius, right_arm_y + arm_height//2 - fist_radius,
                   right_arm_x + fist_radius, right_arm_y + arm_height//2 + fist_radius], 
                  fill=skin_color, outline=(0, 0, 0), width=2)
    
    # Legs (thick and muscular)
    leg_width = body_width // 2.5
    leg_height = body_height // 1.2
    
    # Left leg
    left_leg_x = body_x - leg_width//2
    left_leg_y = body_y + body_height//2 + leg_height//2
    draw.rectangle([left_leg_x - leg_width//2, left_leg_y - leg_height//2,
                    left_leg_x + leg_width//2, left_leg_y + leg_height//2], 
                   fill=skin_color, outline=(0, 0, 0), width=2)
    
    # Right leg
    right_leg_x = body_x + leg_width//2
    right_leg_y = body_y + body_height//2 + leg_height//2
    draw.rectangle([right_leg_x - leg_width//2, right_leg_y - leg_height//2,
                    right_leg_x + leg_width//2, right_leg_y + leg_height//2], 
                   fill=skin_color, outline=(0, 0, 0), width=2)
    
    return img

def create_sita_sprite(width, height):
    """Create Goddess Sita sprite"""
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Body proportions
    head_radius = width // 6
    body_width = width // 3
    body_height = height // 2
    
    # Golden skin color
    skin_color = (255, 228, 196)  # Golden skin
    hair_color = (139, 69, 19)    # Brown hair
    sari_color = (220, 20, 60)    # Red sari
    jewelry_color = (255, 215, 0) # Gold jewelry
    
    # Head
    head_x = width // 2
    head_y = height // 4
    draw.ellipse([head_x - head_radius, head_y - head_radius, 
                   head_x + head_radius, head_y + head_radius], 
                  fill=skin_color, outline=(0, 0, 0), width=2)
    
    # Hair (long and flowing)
    hair_points = [
        (head_x - head_radius, head_y - head_radius),
        (head_x - head_radius - 15, head_y - head_radius - 20),
        (head_x - head_radius - 10, head_y - head_radius - 40),
        (head_x + head_radius + 10, head_y - head_radius - 35),
        (head_x + head_radius + 15, head_y - head_radius - 15),
        (head_x + head_radius, head_y - head_radius)
    ]
    draw.polygon(hair_points, fill=hair_color)
    
    # Eyes
    eye_radius = head_radius // 4
    draw.ellipse([head_x - head_radius//2 - eye_radius, head_y - eye_radius//2,
                   head_x - head_radius//2 + eye_radius, head_y + eye_radius//2], 
                  fill=(255, 255, 255), outline=(0, 0, 0))
    draw.ellipse([head_x + head_radius//2 - eye_radius, head_y - eye_radius//2,
                   head_x + head_radius//2 + eye_radius, head_y + eye_radius//2], 
                  fill=(255, 255, 255), outline=(0, 0, 0))
    
    # Pupils
    pupil_radius = eye_radius // 2
    draw.ellipse([head_x - head_radius//2 - pupil_radius, head_y - pupil_radius//2,
                   head_x - head_radius//2 + pupil_radius, head_y + pupil_radius//2], 
                  fill=(0, 0, 0))
    draw.ellipse([head_x + head_radius//2 - pupil_radius, head_y - pupil_radius//2,
                   head_x + head_radius//2 + pupil_radius, head_y + pupil_radius//2], 
                  fill=(0, 0, 0))
    
    # Body
    body_x = width // 2
    body_y = head_y + head_radius + body_height//2
    draw.rectangle([body_x - body_width//2, body_y - body_height//2,
                    body_x + body_width//2, body_y + body_height//2], 
                   fill=skin_color, outline=(0, 0, 0), width=2)
    
    # Red sari
    sari_width = body_width + 15
    sari_height = body_height
    draw.rectangle([body_x - sari_width//2, body_y - sari_height//2,
                    body_x + sari_width//2, body_y + sari_height//2], 
                   fill=sari_color, outline=(0, 0, 0), width=1)
    
    # Gold jewelry
    jewelry_radius = head_radius // 3
    draw.ellipse([head_x - jewelry_radius, head_y - jewelry_radius,
                   head_x + jewelry_radius, head_y + jewelry_radius], 
                  fill=jewelry_color, outline=(0, 0, 0), width=1)
    
    # Arms
    arm_width = body_width // 4
    arm_height = body_height // 2
    
    # Left arm
    left_arm_x = body_x - body_width//2 - arm_width//2
    left_arm_y = body_y
    draw.rectangle([left_arm_x - arm_width//2, left_arm_y - arm_height//2,
                    left_arm_x + arm_width//2, left_arm_y + arm_height//2], 
                   fill=skin_color, outline=(0, 0, 0), width=1)
    
    # Right arm
    right_arm_x = body_x + body_width//2 + arm_width//2
    right_arm_y = body_y
    draw.rectangle([right_arm_x - arm_width//2, right_arm_y - arm_height//2,
                    right_arm_x + arm_width//2, right_arm_y + arm_height//2], 
                   fill=skin_color, outline=(0, 0, 0), width=1)
    
    # Lotus flower in hand
    lotus_center_x = right_arm_x
    lotus_center_y = right_arm_y + arm_height//2
    lotus_radius = 15
    
    # Lotus petals
    for i in range(8):
        angle = i * 45
        petal_x = lotus_center_x + int(lotus_radius * math.cos(math.radians(angle)))
        petal_y = lotus_center_y + int(lotus_radius * math.sin(math.radians(angle)))
        draw.ellipse([petal_x - 8, petal_y - 8, petal_x + 8, petal_y + 8], 
                     fill=(255, 182, 193))
    
    # Legs
    leg_width = body_width // 3
    leg_height = body_height // 2
    
    # Left leg
    left_leg_x = body_x - leg_width
    left_leg_y = body_y + body_height//2 + leg_height//2
    draw.rectangle([left_leg_x - leg_width//2, left_leg_y - leg_height//2,
                    left_leg_x + leg_width//2, left_leg_y + leg_height//2], 
                   fill=skin_color, outline=(0, 0, 0), width=1)
    
    # Right leg
    right_leg_x = body_x + leg_width
    right_leg_y = body_y + body_height//2 + leg_height//2
    draw.rectangle([right_leg_x - leg_width//2, right_leg_y - leg_height//2,
                    right_leg_x + leg_width//2, right_leg_y + leg_height//2], 
                   fill=skin_color, outline=(0, 0, 0), width=1)
    
    return img

def create_hanuman_sprite(width, height):
    """Create Lord Hanuman sprite"""
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Body proportions
    head_radius = width // 6
    body_width = width // 3
    body_height = height // 2
    
    # Orange skin color
    skin_color = (255, 165, 0)    # Orange
    hair_color = (139, 69, 19)    # Brown hair
    clothing_color = (255, 215, 0) # Gold clothing
    weapon_color = (139, 69, 19)   # Brown mace
    
    # Head (monkey style)
    head_x = width // 2
    head_y = height // 4
    draw.ellipse([head_x - head_radius, head_y - head_radius, 
                   head_x + head_radius, head_y + head_radius], 
                  fill=skin_color, outline=(0, 0, 0), width=2)
    
    # Ears (monkey style)
    ear_radius = head_radius // 2
    draw.ellipse([head_x - head_radius - ear_radius, head_y - ear_radius,
                   head_x - head_radius + ear_radius, head_y + ear_radius], 
                  fill=skin_color, outline=(0, 0, 0), width=1)
    draw.ellipse([head_x + head_radius - ear_radius, head_y - ear_radius,
                   head_x + head_radius + ear_radius, head_y + ear_radius], 
                  fill=skin_color, outline=(0, 0, 0), width=1)
    
    # Eyes
    eye_radius = head_radius // 4
    draw.ellipse([head_x - head_radius//2 - eye_radius, head_y - eye_radius//2,
                   head_x - head_radius//2 + eye_radius, head_y + eye_radius//2], 
                  fill=(255, 255, 255), outline=(0, 0, 0))
    draw.ellipse([head_x + head_radius//2 - eye_radius, head_y - eye_radius//2,
                   head_x + head_radius//2 + eye_radius, head_y + eye_radius//2], 
                  fill=(255, 255, 255), outline=(0, 0, 0))
    
    # Pupils
    pupil_radius = eye_radius // 2
    draw.ellipse([head_x - head_radius//2 - pupil_radius, head_y - pupil_radius//2,
                   head_x - head_radius//2 + pupil_radius, head_y + pupil_radius//2], 
                  fill=(0, 0, 0))
    draw.ellipse([head_x + head_radius//2 - pupil_radius, head_y - pupil_radius//2,
                   head_x + head_radius//2 + pupil_radius, head_y + pupil_radius//2], 
                  fill=(0, 0, 0))
    
    # Body
    body_x = width // 2
    body_y = head_y + head_radius + body_height//2
    draw.rectangle([body_x - body_width//2, body_y - body_height//2,
                    body_x + body_width//2, body_y + body_height//2], 
                   fill=skin_color, outline=(0, 0, 0), width=2)
    
    # Gold clothing
    cloth_width = body_width + 10
    cloth_height = body_height // 3
    draw.rectangle([body_x - cloth_width//2, body_y - cloth_height//2,
                    body_x + cloth_width//2, body_y + cloth_height//2], 
                   fill=clothing_color, outline=(0, 0, 0), width=1)
    
    # Arms
    arm_width = body_width // 4
    arm_height = body_height // 2
    
    # Left arm
    left_arm_x = body_x - body_width//2 - arm_width//2
    left_arm_y = body_y
    draw.rectangle([left_arm_x - arm_width//2, left_arm_y - arm_height//2,
                    left_arm_x + arm_width//2, left_arm_y + arm_height//2], 
                   fill=skin_color, outline=(0, 0, 0), width=1)
    
    # Right arm (holding mace)
    right_arm_x = body_x + body_width//2 + arm_width//2
    right_arm_y = body_y
    draw.rectangle([right_arm_x - arm_width//2, right_arm_y - arm_height//2,
                    right_arm_x + arm_width//2, right_arm_y + arm_height//2], 
                   fill=skin_color, outline=(0, 0, 0), width=1)
    
    # Mace
    mace_x = right_arm_x
    mace_y = right_arm_y + arm_height//2
    mace_width = 20
    mace_height = height // 3
    
    # Mace handle
    draw.rectangle([mace_x - mace_width//2, mace_y,
                    mace_x + mace_width//2, mace_y + mace_height], 
                   fill=weapon_color, outline=(0, 0, 0), width=2)
    
    # Mace head
    mace_head_radius = mace_width * 2
    draw.ellipse([mace_x - mace_head_radius, mace_y - mace_head_radius,
                   mace_x + mace_head_radius, mace_y + mace_head_radius], 
                  fill=clothing_color, outline=(0, 0, 0), width=2)
    
    # Legs
    leg_width = body_width // 3
    leg_height = body_height // 2
    
    # Left leg
    left_leg_x = body_x - leg_width
    left_leg_y = body_y + body_height//2 + leg_height//2
    draw.rectangle([left_leg_x - leg_width//2, left_leg_y - leg_height//2,
                    left_leg_x + leg_width//2, left_leg_y + leg_height//2], 
                   fill=skin_color, outline=(0, 0, 0), width=1)
    
    # Right leg
    right_leg_x = body_x + leg_width
    right_leg_y = body_y + body_height//2 + leg_height//2
    draw.rectangle([right_leg_x - leg_width//2, right_leg_y - leg_height//2,
                    right_leg_x + leg_width//2, right_leg_y + leg_height//2], 
                   fill=skin_color, outline=(0, 0, 0), width=1)
    
    return img

def create_background_sprite(width, height):
    """Create forest background sprite like the reference"""
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Sky gradient (sunset like reference)
    for y in range(height):
        ratio = y / height
        r = int(255 * (1 - ratio) + 255 * ratio)
        g = int(140 * (1 - ratio) + 69 * ratio)
        b = int(0 * (1 - ratio) + 0 * ratio)
        draw.line([(0, y), (width, y)], fill=(r, g, b))
    
    # Sun
    sun_radius = width // 8
    sun_x = width * 0.8
    sun_y = height * 0.2
    draw.ellipse([sun_x - sun_radius, sun_y - sun_radius,
                   sun_x + sun_radius, sun_y + sun_radius], 
                  fill=(255, 215, 0), outline=(255, 165, 0), width=3)
    
    # Forest trees
    tree_color = (34, 139, 34)  # Forest green
    for i in range(8):
        tree_x = width * (0.1 + i * 0.1)
        tree_y = height * 0.7
        
        # Tree trunk
        trunk_width = 20
        trunk_height = height * 0.3
        draw.rectangle([tree_x - trunk_width//2, tree_y,
                        tree_x + trunk_width//2, tree_y + trunk_height], 
                       fill=(139, 69, 19), outline=(0, 0, 0), width=2)
        
        # Tree foliage
        foliage_radius = 40
        draw.ellipse([tree_x - foliage_radius, tree_y - foliage_radius,
                       tree_x + foliage_radius, tree_y + foliage_radius], 
                      fill=tree_color, outline=(0, 0, 0), width=1)
    
    # Ground
    ground_y = height * 0.8
    draw.rectangle([0, ground_y, width, height], 
                   fill=(139, 69, 19), outline=(0, 0, 0), width=2)
    
    return img

def main():
    """Generate all game sprites"""
    print("🎨 Creating high-resolution anime-style RPG sprites for Ramayana Game...")
    
    # Create output directory
    output_dir = "RamayanaGame/Assets.xcassets/GameSprites.imageset"
    create_directory(output_dir)
    
    # Generate sprites
    sprites = [
        ("rama", create_rama_sprite(200, 300)),
        ("sita", create_sita_sprite(200, 300)),
        ("hanuman", create_hanuman_sprite(200, 300)),
        ("demon", create_demon_sprite(200, 300)),
        ("background", create_background_sprite(400, 300))
    ]
    
    for name, img in sprites:
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
      "filename" : "rama.png",
      "idiom" : "universal",
      "scale" : "1x"
    },
    {
      "filename" : "rama@2x.png",
      "idiom" : "universal",
      "scale" : "2x"
    },
    {
      "filename" : "sita.png",
      "idiom" : "universal",
      "scale" : "1x"
    },
    {
      "filename" : "sita@2x.png",
      "idiom" : "universal",
      "scale" : "2x"
    },
    {
      "filename" : "hanuman.png",
      "idiom" : "universal",
      "scale" : "1x"
    },
    {
      "filename" : "hanuman@2x.png",
      "idiom" : "universal",
      "scale" : "2x"
    },
    {
      "filename" : "demon.png",
      "idiom" : "universal",
      "scale" : "1x"
    },
    {
      "filename" : "demon@2x.png",
      "idiom" : "universal",
      "scale" : "2x"
    },
    {
      "filename" : "background.png",
      "idiom" : "universal",
      "scale" : "1x"
    },
    {
      "filename" : "background@2x.png",
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
    
    print("🎨 All game sprites created successfully!")
    print("📁 Files saved to: RamayanaGame/Assets.xcassets/GameSprites.imageset/")

if __name__ == "__main__":
    main()
