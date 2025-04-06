################# CSC258 Assembly Final Project ###################
# This file contains our implementation of Dr Mario.
#aass
# Student 1: Kevin Hu, 1009005639

#
# We assert that the code submitted here is entirely our own 
# creation, and will indicate otherwise when it is not.
#
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       1
# - Unit height in pixels:      1
# - Display width in pixels:    32
# - Display height in pixels:   32
# - Base Address for Display:   0x10008000 ($gp)
##############################################################################
    .data
offset_link_grid: .space 4096     # 32 × 32 × 4 bytes = 4096 bytes
gravity_speed_up_bool: .word 0
pause_state: .word 0
state_orientation: .word 0 # This holds current orientation of pill
next_capsules: .space 40 # 4 capsules total, 2 pixels each, each pixel is 4 bytes
virus_pairs: .space 12 # 3 viruses each store two 2 byte location x,y 
# dr_mario_16x20_full.asm
# Dr. Mario Sprite Data 
drmario_sprite: .word
    0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x795548, 0x000000,
    0x000000, 0x000000, 0x000000, 0x000000, 0x795548, 0x795548, 0x795548, 0x795548, 0x795548, 0x9E9E9E, 0xFFFFFF, 0x795548, 0x000000,
    0x000000, 0x000000, 0x000000, 0x3F51B5, 0x3F51B5, 0x3F51B5, 0x3F51B5, 0x3F51B5, 0x3F51B5, 0x9E9E9E, 0xFFFFFF, 0x000000, 0x000000,
    0x000000, 0x000000, 0x000000, 0x795548, 0x795548, 0x795548, 0xFFCC80, 0xFFCC80, 0x000000, 0xFFCC80, 0x000000, 0x000000, 0x000000,
    0x000000, 0x000000, 0x795548, 0xFFCC80, 0x795548, 0xFFCC80, 0xFFCC80, 0xFFCC80, 0x000000, 0xFFCC80, 0xFFCC80, 0xFFCC80, 0x000000,
    0x000000, 0x000000, 0x795548, 0xFFCC80, 0x795548, 0x795548, 0xFFCC80, 0xFFCC80, 0xFFCC80, 0x000000, 0xFFCC80, 0xFFCC80, 0x000000,
    0x000000, 0x000000, 0x795548, 0x795548, 0xFFCC80, 0xFFCC80, 0xFFCC80, 0xFFCC80, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000,
    0x000000, 0x000000, 0x000000, 0x000000, 0xFFCC80, 0xFFCC80, 0xFFCC80, 0xFFCC80, 0xFFCC80, 0xFFCC80, 0xFFCC80, 0x000000, 0x000000,
    0x000000, 0x000000, 0x000000, 0xFFFFFF, 0xFFFFFF, 0x607D8B, 0xFFFFFF, 0xF44336, 0xF44336, 0x000000, 0x000000, 0x000000, 0x000000,
    0x000000, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0x607D8B, 0xF44336, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0x000000,
    0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0x607D8B, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF,
    0x607D8B, 0x607D8B, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0x607D8B, 0x607D8B, 0xFFFFFF, 0xFFFFFF, 0x607D8B, 0x607D8B,
    0x9E9E9E, 0x9E9E9E, 0x9E9E9E, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0x9E9E9E, 0x9E9E9E, 0x000000,
    0x9E9E9E, 0x9E9E9E, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0x9E9E9E, 0x000000,
    0x000000, 0x000000, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0x000000, 0x000000,
    0x000000, 0x000000, 0x3F51B5, 0x3F51B5, 0x3F51B5, 0x000000, 0x000000, 0x000000, 0x3F51B5, 0x3F51B5, 0x3F51B5, 0x000000, 0x000000,
    0x000000, 0x795548, 0x795548, 0x795548, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x795548, 0x795548, 0x795548, 0x000000,
    0x795548, 0x795548, 0x795548, 0x795548, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x795548, 0x795548, 0x795548, 0x795548

virus_blocks:
.word 0xFF0000 .word 0xFF0000 .word 0xFF0000 .word 0xFF0000 .word 0xFFFF00 .word 0xFFFF00 .word 0xFFFF00 .word 0xFFFF00 .word 0x0000FF .word 0x0000FF .word 0x0000FF .word 0x0000FF

white_P: .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0xFFFFFF .word 0xFFFFFF .word 0xFFFFFF .word 0xFFFFFF .word 0xFFFFFF .word 0xFFFFFF .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0xFFFFFF .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0xFFFFFF .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0xFFFFFF .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0xFFFFFF .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0xFFFFFF .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0xFFFFFF .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0xFFFFFF .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0xFFFFFF .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0xFFFFFF .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0xFFFFFF .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0xFFFFFF .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0xFFFFFF .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0xFFFFFF .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0xFFFFFF .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0xFFFFFF .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0xFFFFFF .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0xFFFFFF .word 0xFFFFFF .word 0xFFFFFF .word 0xFFFFFF .word 0xFFFFFF .word 0xFFFFFF .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0xFFFFFF .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0xFFFFFF .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0xFFFFFF .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0xFFFFFF .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0xFFFFFF .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0xFFFFFF .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0xFFFFFF .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0xFFFFFF .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0xFFFFFF .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0xFFFFFF .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000 .word 0x000000

board_storage: .space 4096   # 32x32 * 4 bytes per pixel






##############################################################################
# Immutable Data
    displayaddress:     .word       0x10008000
    keyboard_address:   .word       0xffff0000
    red: .word 0xff0000
    yellow: .word 0xffff00
    blue: .word 0x00FFFFa
    white: .word 0xfffffff
    black: .word 0x0
# MacroMacro code 
.macro push(%reg) 
    addi $sp, $sp, -4       # move the stack pointer to the next empty spot
    sw %reg, 0($sp)         # push the register value onto the top of the stack
.end_macro

# The macro for popping a value off the stack.
.macro pop(%reg) 
    lw %reg, 0($sp)         # fetch the top element from the stack    
    addi $sp, $sp, 4        # move the stack pointer to the top element of the stack.
.end_macro
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000

##############################################################################
# Mutable Data
##############################################################################

##############################################################################
# Code
##############################################################################
	.text
	.globl main

    # Run the game.
main:
    # Initialize the game
    lw $t0, displayaddress # $t0 = base address for display

    
    ## Draw medine bottle ##
    # We will use $a0 as line length, t5 as loop counter and a1 as the starting coordinate
    # We will use gray to color the edges
    li $t4, 0x707070 # $t4 = gray
    # Drawing top line
    addi $a0, $zero, 17         # line length
    addi $t5, $zero, 0          # loop counter
    addi $a1, $t0, 772          # 
    jal draw_horizontal

    # Drawing bottom line
    addi $a0, $zero, 17         # line length
    addi $t5, $zero, 0          # loop counter
    addi $a1, $t0, 3332          
    jal draw_horizontal

    # Drawing left vertical line
    addi $a0, $zero, 20         # line length
    addi $t5, $zero, 0          # loop counter
    addi $a1, $t0, 772          
    jal draw_vertical

    # Drawing right vertical line
    addi $a0, $zero, 20         # line length
    addi $t5, $zero, 0          # loop counter
    addi $a1, $t0, 836          
    jal draw_vertical

    # Drawing small left vertical line at opening
    addi $a0, $zero, 3         # line length
    addi $t5, $zero, 0          # loop counter
    addi $a1, $t0, 412          
    jal draw_vertical

    # Drawing small right vertical line at opening
    addi $a0, $zero, 3         # line length
    addi $t5, $zero, 0          # loop counter
    addi $a1, $t0, 428          
    jal draw_vertical

    li $t4, 0x000000
    # Drawing hole by coloring it black
    addi $a0, $zero, 3         # line length
    addi $t5, $zero, 0          # loop counter
    addi $a1, $t0, 800
    jal draw_horizontal

    jal init_offset_link_zero
    li $s7, 0 # initialize gravity counter

    #jal draw_pixel_art
    jal initialize_virus
    jal load_mario
    jal load_virus
    # jal draw_P
    # Initialize the 5 capsules
    jal update_next_capsules
    jal update_next_capsules
    jal update_next_capsules
    jal update_next_capsules
    jal update_next_capsules
    j gen_tile
    main_header:

      j game_loop
    
game_loop:
    # 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (capsules)
	# 3. Draw the screen
	# 4. Sleep

    # 5. Go back to Step 1
    
    # Handling user input
    lw $t5 keyboard_address
    lw $t4 0($t5) # t4 was previously gray now since we dont need gray anymore we can use it as a register
    beq $t4, 1, handle_input # if keyboard address is 1 then this means a new input occured
    jal delay_60fps       # Wait until 1/60 second has passed
    addi $s7, $s7, 1
    li $t0, 120
    bne $t0, $s7, game_loop

    # We only do gravity if game isnt paused. So we check if input_skip_cuz_paused
    jal gravity

    j game_loop           # Repeat the loop indefinitely

    
draw_horizontal:
    sw $t4, 0($a1)          # store color to current pixel
    addi $t5, $t5, 1        # increment loop counter
    addi $a1, $a1, 4        # next pixel (4 bytes per pixel)
    beq $t5, $a0, draw_horizontal_end
    j draw_horizontal
draw_horizontal_end:
    jr $ra  # return to caller

draw_vertical:
    sw $t4, 0($a1)          # store color to current pixel
    addi $t5, $t5, 1        # increment loop counter
    addi $a1, $a1, 128        # next pixel (4 bytes per pixel)
    beq $t5, $a0, draw_vertical_end
    j draw_vertical
draw_vertical_end:
    jr $ra  # return to caller

gen_next_colors:

    # we need to place the output of the colors in v0 and v1

    
    # generate a new 1x2 block with random colors from red, yellow, blue and store first color in $s0 and 2nd color in $s1
    # for mapping we will do 0 -> red, 1 -> yellow, 2 -> blue
    li $v0, 42        # random syscall
    li $a0, 0         # generator id
    li $a1, 3         # max (exclusive) -> 0, 1, 2
    syscall
    move $t0, $a0     # setting rdm number to s0

    li $a0, 0         # generator id
    syscall
    move $t1, $a0     # setting rdm number to s1

    # set first color based on mapping. Going into set_color1 will trigger 2nd color to be assigned
    beq $t0, 0, set_red1
    beq $t0, 1, set_blue1
    beq $t0, 2, set_yellow1
    jr $ra
    
set_red1:
  lw $v0, red
  j set_second_color

set_yellow1:
  lw $v0, yellow
  j set_second_color
  
set_blue1:
  lw $v0, blue
  j set_second_color

  
set_second_color:
  beq $t1, 0, set_red2
  beq $t1, 1, set_yellow2
  beq $t1, 2, set_blue2
  
set_red2:
  lw $v1, red
  jr $ra
  
set_yellow2:
  lw $v1, yellow
  jr $ra
  
set_blue2:
  lw $v1, blue
  jr $ra

gen_tile:
  # Generating colors for pill
  # s0: color1, s1: color2, s2: position1, s3: position2, s4: orientation of current pill. 
  addi $sp, $sp, -4 # make space for temp ra value
  sw $ra, 0($sp) # move current value in ra to sp
  
  # jal gen_next_colors


  lw $ra, 0($sp) # load word from memory (sp) back into ra
  addi $sp, $sp, 4 # add space back to sp
  # gen_next_colors returns color of pixel 0 and 1 in v0 and v1
  # move $s0, $v0
  # move $s1, $v1
  # We will store current pile coordinate tiles in s2 and s3. 
  # addi $s2, $t0, 444
  # addi $s3, $t0, 572
  # Setting initial positions of pill
  li $s2, 10
  li $s3, 3 
  # Set orientation to 0 by default. This value will range from 0 to 3 with the default being 0 
  jal update_next_capsules
  jal update_next_capsules_display
  push ($t0)
  push ($t1)
  la $t0, state_orientation
  li $t1, 0
  sw $t1, 0($t0) # Writes to memory of state
  pop ($t1)
  pop ($t0)
  li, $s4, 1
  # Coloring the two tiles to the assigned colors from s0 and s1.
  jal get_2_tiles
  
  sw $s0, 0($v0)
  sw $s1, 0($v1)



  j game_loop

handle_input:
  lw $t5 4($t5) # load ascii directly into t0 
  # s4 and s5 will hold the previous positions of the pill
  move $s5, $s2
  move $s6, $s3
  beq $t5, 0x70, handle_p     # 'p'
  # Check if current state is paused, if paused we dont do anything
  push ($t0)
  push ($t1)
  la $t0, pause_state
  lw $t1, 0($t0)
  li $t2, 1
  beq $t1, $t2, input_skip_cuz_paused # If current state is pause we dont handle any inputs
  
  beq $t5, 0x77, handle_w     # if $t0 == 'w' (0x77)
  beq $t5, 0x61, handle_a   # if $t0 == 'a'
  beq $t5, 0x73, handle_s   # if $t0 == 's'
  beq $t5, 0x64, handle_d  # if $t0 == 'd'
  beq $t5, 0x71, handle_q  # if $t0 == 'q'
  input_skip_cuz_paused:
  pop ($t1)
  pop ($t0)
  jr $ra

handle_p:
  push ($ra)
  jal toggle_pause_game
  li $s7, 0
  pop ($ra)
  j game_loop
toggle_pause_game:
  push ($ra)
  push ($t0)
  push ($t1)
  la $t1, pause_state # load value of pause state into t1
  lw $t0, 0($t1)
  addi $t0, $t0, 1 # Increment the state by 1
  andi $t0, $t0, 1 # bitwise and t1 and ...0001 so only keep least significant bit 
  sw $t0, 0($t1)
  li $t1, 1
  bne $t0, $t1, load_board
  # Show pause
  show_pause:
    jal save_board
    jal draw_white_P
    j pause_end
  load_board:
    jal restore_board
  pause_end:
  # Logic: if t1 = 1 then pause state. during pause state we sleep infinitely 
  pop ($t1)
  pop ($t0)
  pop ($ra)
  jr $ra
  
handle_w:
# We will store the orientation of the pill in s4. The value will range from 0-3
   push ($v0)
    push ($a0)
    push ($a1)
    push ($a2)
    push ($a3)
    # 模拟声音播放：用 MIDI 音效
    li $v0, 31
    li $a0, 60       # pitch，中音C
    li $a1, 300      # duration，300ms
    li $a2, 124      # instrument
    li $a3, 100      # volume
    syscall
    pop ($a3)
    pop ($a2)
    pop ($a1)
    pop ($a0)
    pop ($v0)

  la $t0, state_orientation          # load address into $t0
  lw $t1, 0($t0)         # load word from address in $t0 into $t1
  addi $t1, $t1, 1
  sw $t1, 0($t0)
  beq $s4, 0, handle_orientation_0
  beq $s4, 1, handle_orientation_1
  beq $s4, 2, handle_orientation_2
  beq $s4, 3, handle_orientation_3

# So the math will be how to go from previous state to next. So eg handle_orientation_1 will be how to go from 0 to 1. The rotation will be clockwise
handle_orientation_0:
  
  
  jal get_2nd_tile # Sets x,y of second tile in v0, v1
  addi $a0, $s2, 1
  addi $a1, $s3, 1
  move $a2, $v0
  move $a3, $v1
  jal check_collision

  beq $v0, 1, game_loop # If collision l returns true, return back to gameloop 

  jal clean_prev


  # Increment orientation state 
  addi $s4, $s4, 1 # add 1 to current orientation state s4
  andi $s4, $s4, 3 # bitwise and 3 = 11 so keep only last 2 bits
  
  addi $s2, $s2, 1
  addi $s3, $s3, 1
  jal paint_tile
  jal check_set_pill # check if theres entity under
  jal gen_tile
handle_orientation_1:
  
  jal get_2nd_tile
  addi $a0, $s2, -1
  addi $a1, $s3, 1
  move $a2, $v0
  move $a3, $v1
  jal check_collision

  beq $v0, 1, game_loop # If collision l returns true, return back to gameloop 

  jal clean_prev
  
  # Increment orientation state 
  addi $s4, $s4, 1 # add 1 to current orientation state s4
  andi $s4, $s4, 3 # bitwise and 3 = 11 so keep only last 2 bits
  
  
  # Check rotation collision 
  addi $s2, $s2, -1
  addi $s3, $s3, 1
  jal paint_tile
  jal check_set_pill # check if theres entity under
  jal gen_tile
handle_orientation_2:

  # Checking tiles to be moved to is valid
  jal get_2nd_tile
  addi $a0, $s2, -1
  addi $a1, $s3, -1
  move $a2, $v0
  move $a3, $v1
  jal check_collision
  beq $v0, 1, game_loop # If collision l returns true, return back to gameloop 

  # Check rotation collision 

  jal clean_prev

  # Increment orientation state 
  addi $s4, $s4, 1 # add 1 to current orientation state s4
  andi $s4, $s4, 3 # bitwise and 3 = 11 so keep only last 2 bits
  
  # Check rotation collision 

  addi $s2, $s2, -1
  addi $s3, $s3, -1
  jal paint_tile
  jal check_set_pill # check if theres entity under
  jal gen_tile

handle_orientation_3:
  jal get_2nd_tile # Sets x,y of second tile in v0, v1
  addi $a0, $s2, 1 # also for rotation need to check corners
  addi $a1, $s3, -1
  move $a2, $v0
  move $a3, $v1
  jal check_collision

  beq $v0, 1, game_loop # If collision l returns true, return back to gameloop 

  jal clean_prev

  # Increment orientation state 
  addi $s4, $s4, 1 # add 1 to current orientation state s4
  andi $s4, $s4, 3 # bitwise and 3 = 11 so keep only last 2 bits
  
  addi $s2, $s2, 1
  addi $s3, $s3, -1
  jal paint_tile
  
  jal check_set_pill # check if hit bottom
  jal gen_tile

handle_a:
  # Move pill to left in memory
  # Check if we hit right way or not. To do so we will call check_hit_long_vertical_wall
  jal get_2nd_tile
  # Set a0 to x_tile1 and a1 to x_tile2 since get_2nd_tile sets v0 and v1 to x_2nd and y_2nd
  addi $a0, $s2, -1
  move $a1, $s3
  addi $a2, $v0, -1
  move $a3, $v1
  jal check_collision
  beq $v0, 1, game_loop # If check_hit_long_vertical_wall returns true, if true return back to gameloop 
  # Painting old coordinates black
   push ($v0)
    push ($a0)
    push ($a1)
    push ($a2)
    push ($a3)
    # 模拟声音播放：用 MIDI 音效
    li $v0, 31
    li $a0, 60       # pitch，中音C
    li $a1, 300      # duration，300ms
    li $a2, 127      # instrument
    li $a3, 100      # volume
    syscall
    pop ($a3)
    pop ($a2)
    pop ($a1)
    pop ($a0)
    pop ($v0)
  jal clean_prev
  addi $s2, $s2, -1
  # Color pills using stored color in s0, s1 to their new locations
  # 模拟声音播放：用 MIDI 音效

  jal paint_tile
  jal check_set_pill # check if theres entity under
  jal gen_tile

handle_s:
  # Move pill down in memory
  jal get_2nd_tile
  # Set a0 to x_tile1 and a1 to x_tile2 since get_2nd_tile sets v0 and v1 to x_2nd and y_2nd
  move $a0, $s2
  addi $a1, $s3, 1
  move $a2, $v0,
  addi $a3, $v1, 1
  jal check_collision

  beq $v0, 1, game_loop # If check_hit_long_vertical_wall returns true, if true return back to gameloop 
  # Painting old coordinates black
  jal clean_prev
  addi $s3, $s3, +1

   # push ($v0)
   #  push ($a0)
   #  push ($a1)
   #  push ($a2)
   #  push ($a3)
   #  # 模拟声音播放：用 MIDI 音效
   #  li $v0, 31
   #  li $a0, 60       # pitch，中音C
   #  li $a1, 300      # duration，300ms
   #  li $a2, 11      # instrument
   #  li $a3, 100      # volume
   #  syscall
   #  pop ($a3)
   #  pop ($a2)
   #  pop ($a1)
   #  pop ($a0)
   #  pop ($v0)
  # Color pills using stored color in s0, s1 to their new locations
  jal  paint_tile
  jal check_set_pill # check if hit bottom
  jal gen_tile


handle_d:
  
  # First check for collision. We will check if the new coordinates of the pill hits any non black color or not.
  jal get_2nd_tile
  # So now v0 holds new_x_2, v1 = new_y_2
  # Set a0 to new_x_1, a1 = new_y_1, a2 = new_x_2, a3 = new_y_2
  addi $a0, $s2, 1
  move $a1, $s3
  addi $a2, $v0, 1
  move $a3, $v1
  jal check_collision
  
  beq $v0, 1, game_loop # If check_hit_long_vertical_wall returns true, if true return back to gameloop 
  # Painting old coordinates black
  jal clean_prev
  # Move pill right in memory
  addi $s2, $s2, +1
  # Color pills using stored color in s0, s1 to their new locations
    push ($v0)
    push ($a0)
    push ($a1)
    push ($a2)
    push ($a3)
    # 模拟声音播放：用 MIDI 音效
    li $v0, 31
    li $a0, 60       # pitch，中音C
    li $a1, 300      # duration，300ms
    li $a2, 127      # instrument
    li $a3, 100      # volume
    syscall
    pop ($a3)
    pop ($a2)
    pop ($a1)
    pop ($a0)
    pop ($v0)
  jal paint_tile
  jal check_set_pill # check if hit bottom. This jumps into main_loop. but this has dependencies
  jal gen_tile

handle_q:
  # Quit
  push ($v0)
  push ($a0)
  push ($a1)
  push ($a2)
  push ($a3)
  # 模拟声音播放：用 MIDI 音效
  li $v0, 31
  li $a0, 60       # pitch，中音C
  li $a1, 300      # duration，300ms
  li $a2, 4      # instrument
  li $a3, 100      # volume
  syscall
  pop ($a3)
  pop ($a2)
  pop ($a1)
  pop ($a0)
  pop ($v0)
  li $v0, 10   # 10 is the exit syscall code
  syscall      # this terminates the program
paint_tile:
  # Set input to get updated address of 2 tiles in v0 and v1 after moving
  
  push ($ra)

  
  move $a0, $s2
  move $a1, $s3
  jal get_2_tiles
  
  
  # paint them based on color
  # So now v0 holds offset of tile 1 in display and v1 holds offset of tile 2 in display

  sw $s0, 0($v0)
  sw $s1, 0($v1)
 
  pop ($ra)
  jr $ra

clean_prev:
  # Removes previous pill on bitmap
  # Calls get_two_tiles to get addresses, and set them to black
  # Set input to get address of 2 tiles in v0 and v1
  move $a0, $s2
  move $a1, $s3
  
  addi $sp, $sp, -4 # make space for temp ra value
  sw $ra, 0($sp) # move current value in ra to sp
  jal get_2_tiles # This sets v0 to tile 1 and v1 to tile 2
  lw $ra, 0($sp) # load word from memory (sp) back into ra
  addi $sp, $sp, 4 # add space back to sp
  # Paint them black
  
  lw $t3, black
  sw, $t3, 0($v0)
  sw, $t3, 0($v1)
  jr $ra

delay_60fps:

    li $t9, 60000   # Set DELAY_COUNT to the number of iterations needed
delay_loop:
    addi $t9, $t9, -1     # Decrement the counter
    bgtz $t9, delay_loop  # If counter > 0, keep looping

    jr $ra                # Return to game_loop

gravity:
  # Takes no inputs, if current capsule causes no collisions move it down

  la $t1, gravity_speed_up_bool
  lw $t2, 0($t1)
  addi $t2, $t2, 1 # add 1 to global time coun ter
  sw $t2, 0($t1) # storing it back in
  push ($t0)
  push ($t1)
  la $t0, pause_state
  lw $t1, 0($t0)
  li $t3, 1
  li $t0, 120
  
  beq $t1, $t3, input_skip_cuz_paused # If current state is pause we dont handle any inputs
  pop ($t1)
  pop ($t0)
  
  bgt $t2, 100, gravity_fast
    li $s7, 0 # reset time counter
    j handle_s
  gravity_fast:
    li $s7, 40 # reset time counter
  j handle_s
  reset_time_counter:
    li $s7, 0

  j game_loop
  
check_collision:
  # This takes in 4 coordinates 1: pixel 1, 2: new pixel. a0 = new x_1, a1 = new y_1, a2 = x_2, a3 = y_2 
  # and returns in v0 whether if new operation hits entity (non black pixel) or not. Set v0 to 1 if hit. 
  # Idea: check first check if address of pixel 1 is black. If black, write. If not black, and if its not previous
  # location of pixel 2, dont write. If it is, check if new address of pixel 2 is black. If black: write. 

  # We also need to check for rotation. Since we always rotate on pixel 2, we also need case when 
  # Check first coord
  lw $t4, black
  # since a0 and a1 are already the first tiles new location, we directly call offset_conversion_disp
  addi $sp, $sp, -4 # make space for temp ra value
  sw $ra, 0($sp) # move current value in ra to sp
  jal offset_conversion_disp
  lw $ra, 0($sp) # load word from memory (sp) back into ra
  addi $sp, $sp, 4 # add space back to sp
  # now address of pixel 1 is in v0
  # move address of pixel 1 in t6
  move $t6, $v0
  # load color of pixel 1 being moved to into t5
  lw $t5, 0($t6)

  # Getting 2nd tile and storing 2nd tile address in t7
  move $a0, $a2
  move $a1, $a3
  
  addi $sp, $sp, -4 # make space for temp ra value
  sw $ra, 0($sp) # move current value in ra to sp
  jal offset_conversion_disp
  lw $ra, 0($sp) # load word from memory (sp) back into ra
  addi $sp, $sp, 4 # add space back to sp

  
  move $t7, $v0 # so offset of pixel that 2nd tile is being moved to 
  # At this point t4: black, t6: address of pixel 1 moving to, t7: address that pixel 2 is moving to

  addi $sp, $sp, -4 # make space for temp ra value
  sw $ra, 0($sp) # move current value in ra to sp
  jal get_2_tiles # so now v0 is tile1 offset and v1 is tile 2 offset
  lw $ra, 0($sp) # load word from memory (sp) back into ra
  addi $sp, $sp, 4 # add space back to sp

  # At this point t4: black, t6: address of pixel 1 moving to, t7: address that pixel 2 is moving to, t8: address current pixel 2 in state, $t3: address of current pixel 1 in state
  move $t3, $v0 # Moving 1st tile in current state to t3
  move $t8, $v1 # Moving 2nd tile in current state to t8

  beq $t4, $t5, check_2nd_coord # check if black = first pixel's color
  # If not black then check if pixel first tile is being moved to (in t6) is the 2nd tile in stored in state.
  
  # Check if tile first tile is moving to is tile 2

  beq $t6, $t8, check_2nd_coord
  j return_true
  # Check if 2nd coord can be moved
  check_2nd_coord:
    lw $t5, 0($t7)  
    lw $t4, black # something wrong with the 2nd tile's collision when going left
    # Set v0 to 0 if tile moving to color is black
    beq $t4, $t5, return_false

    # Check if location pixel 2 is moving to is current pdixel 1 location in state
    # Set v0 to 0 if tile moving to is 1st pixel
    beq $t7, $t3, return_false 

    beq $t7, $t8, return_false # case when we rotate and pixel 2 doesnt move
  j return_true

check_rotation_collision:
  # Check if rotation collides with edge corner or not
  
return_true:
  # v0 will be return value. 0,1 indicate if hit wall or not / 
  li $v0, 1
  jr $ra
return_false:
  li $v0, 0
  jr $ra
offset_conversion_disp:
  # Uses input a0: x coord, a1: y coord, a
  # We want to compute:
  #   address = $t0 + ((a1 * 32 + a0) * 4)
  # set v0 to offset address

  lw $t0, displayaddress
  mul   $v0, $a1, 32    # $t1 = y * 32
  add   $v0, $v0, $a0   # $t1 = y * 32 + x   (this is the pixel index)
  sll   $v0, $v0, 2     # $t1 = (y * 32 + x) * 4 (convert pixel index to byte offset)
  add   $v0, $t0, $v0   # $t1 = display base + computed offset #change
  jr $ra

offset_conversion_link_grid:
  # Uses input a0: x coord, a1: y coord, a
  # We want to compute:
  #   address = $t0 + ((a1 * 32 + a0) * 4)
  # set v0 to offset address

  la $t0, offset_link_grid
  mul   $v0, $a1, 32    # $t1 = y * 32
  add   $v0, $v0, $a0   # $t1 = y * 32 + x   (this is the pixel index)
  sll   $v0, $v0, 2     # $t1 = (y * 32 + x) * 4 (convert pixel index to byte offset)
  add   $v0, $t0, $v0   # $t1 = display base + computed offset #change
  jr $ra
get_2nd_tile:
  # based on current orientation and location of tile, set the x,y coordinates of 2nd tile to v0 and v1. 
  beq $s4, 0, get_orientation_0
  beq $s4, 1, get_orientation_1
  beq $s4, 2, get_orientation_2
  beq $s4, 3, get_orientation_3
get_orientation_0:
  # vertical with tile 1 at top and tile 2 at bot
  move $v0, $s2
  addi $v1, $s3, 1
  jr $ra
  
get_orientation_1:
  # horizontal with tile 1 on left and tile 2 on right
  addi $v0, $s2, -1
  move $v1, $s3
  jr $ra

get_orientation_2:
  # vertical with tile 1 on bot and tile 2 on top
  move $v0, $s2
  addi $v1, $s3, -1
  jr $ra
  
get_orientation_3:
  # horizontal with tile 1 on right and tile 2 on left
  addi $v0, $s2, 1
  move $v1, $s3
  jr $ra

get_2_tiles:
  

  
  # set v0 and v1 to addresses of tile1 and tile2
  push ($ra) # store ra in t1 so we can backtrack laters
  # Store 2nd tile in v0 and v1
  jal get_2nd_tile
  # Set coords of 2nd tile to a0 and a1 to convert them into offset
  move $a0, $v0 # this is wrong
  move $a1, $v1
  jal offset_conversion_disp
  # So now v1 holds address of tile 2. 
  move $v1, $v0
  
  # set inputs to tile 1's x,y, call offset conversion
  move $a0, $s2
  move $a1, $s3
  # at this point a0 and a1 hold the xy coordinates of current pill
  jal offset_conversion_disp
  # So now v0 stores address of tile1
  pop ($ra)
  jr $ra
  
check_set_pill:
  # !!Check: if new operation hits another tile below. If so, we set the block in current place, and generate a new block at the starting location.
  # Input: 1: new pixel 1, 2: new pixel 2. a0 = new x_1, a1 = new y_1, a2 = new x_2, a3 = new y_2 in indexes
  # Logic: check tile below pixel 1 and pixel 2 and see if theres an entity. Find (x_1, y_1 +1) , (x_2, y_2+1) and pass those into check_collision. Since in collision logic we check 
  # for self this includes all cases.
  addi $sp, $sp, -4     # make space
  sw   $ra, 0($sp)      # save return address
  
  # Find (x_1, y_1 +1) , (x_2, y_2+1)
  addi $a1, $a1, 1
  addi $a3, $a3, 1

  # So now we have a0 = x_1, a1 = y_1 +1, a2 = x_2, a3 = y_2+1
  jal check_collision
  beq, $v0, 0, game_loop # If no collision continue game_loop
  # So there was a collision. Now we update offset_link_grid since we placed new tiles 
    
  move $a0, $s2
  move $a1, $s3
  jal offset_conversion_link_grid
  move $t3, $v0 # So t3 holds offset of link grif of coord 1
  jal get_2nd_tile
  move $a0, $v0
  move $a1, $v1
  jal offset_conversion_link_grid
  move $t4, $v0
  # Now: t3 holds offset of link grid of coord 1, t4 holds offset of link grid of coord 2
  # We want to store the link offset of coord 1 in link offset of coord 2 and offset of coord 2 in offset of coord 1 in link grid
  sw $t3, 0($t4)
  sw $t4, 0($t3)
  
  # Check for 4+ in a row, if 4+ in a row or in column, remove them.
  # For all the tiles ABOVE the removed tiles, drop them until check_set_pill returns return_false
  # 
  jal check_match
  jal check_game_end
  lw   $ra, 0($sp)      # restore original return address
  addi $sp, $sp, 4      # clean up stack
  jr   $ra  
  # Else gen_tile

  
check_match:
  # This checks if newly placed pill triggers any chain or not. We will call this form check_set_pill. 
  # We will check the rows and the columns of both pixel 1 and 2 which are currently stored in s2 and s3. 

  
 
  
  addi $sp, $sp, -4     # make space
  sw   $ra, 0($sp)      # save return address

  
  # First check row of pixel 1
  move $a0, $s2
  move $a1, $s3
  li $a2, 0
  move $a3, $s0 # set color of pixel 1 to a3
  jal check_chain

  # 2nd check row of pixel 2

  # Call get_second_tile and store in x in t2, y in t3
  jal get_2nd_tile

  move $a0, $v0
  move $a1, $v1
  li $a2, 0 # set row setting
  move $a3, $s1 # set color of pixel 2 to a3
  jal check_chain

  # 3rd check col of pixel 1

  move $a0, $s2
  move $a1, $s3
  li $a2, 1
  move $a3, $s0 # set color of pixel 1 to a3
  jal check_chain

  # Finally check col of pixel 2
  
  jal get_2nd_tile

  move $a0, $v0
  move $a1, $v1
  
  li $a2, 1 # set row setting
  move $a3, $s1 # set color of pixel 2 to a3
  jal check_chain

  lw   $ra, 0($sp)      # restore original return address
  addi $sp, $sp, 4      # clean up stack
  jr $ra

check_chain:
  # Input: let p = pixel to check a0 = p_x, a1 = p_y, a2: whether we traverse row wise or column wise, a3: what color we check for
  # t1 will hold the length of the chain. We will traverse left or top until left or top is black. The we traverse right or down
  # t2 will hold dx, t3 will hold dy
  # t4 will hold start xcoordinate of chain.
  # t8 will hold start y coord of chain. The coord will either be the left most or the top of the chain
  # t5 will hold color to check for
  # t6 will hold temp address of traversing pixel
  # t7 will hold 4 used for comparison
  addi $sp, $sp, -4     # make space
  sw   $ra, 0($sp)      # save return address
  push ($a1)
  # Set color of checking for to t5
  move $t5, $a3
  bnez $a2, set_col_traversal # Branch if a2 is not equal to 0 
  # So this is row traversal settings we first traverse left then we flip sign to traverse right later
    li $t2, -1
    li $t3 0 # So we move left by 1 each time
    j set_chain_endif
  set_col_traversal:
    li $t2, 0
    li $t3 -1 # So we move up by 1 each time
  set_chain_endif:
  # Now we will traverse directly on a0 and a1.

    traverse_to_start:
    # So we move first then check color. So we will be on the black when this is done
    add $a0, $a0, $t2 # add t2 to a0
    add $a1, $a1, $t3 # Add t3 (dy) to a1
    jal offset_conversion_disp # This sets v0 to the offset address
    lw $t6, 0($v0)
    beq $t6, $t5, traverse_to_start # check of color of current pixel (v0) is black (t5)
  # lw $t7, red # just check, paint red at end
  # sw $t7, 0($v0)

  # Now we store the coordinate address to t4 and t8
  move $t4, $a0
  move $t8, $a1
  
  # Initialize length counter
  li $t1, 0

  # Initilize 4
  li $t7, 4
  # We reverse the operations. Since at each time one of them will be zero we will do it on both
  sub $t2, $zero, $t2
  sub $t3, $zero, $t3

  # For debug

  traverse_to_end:
   # li $t9, 0xffffff
    addi $t1, $t1, 1
    add $a0, $a0, $t2 # add t2 to a0
    add $a1, $a1, $t3 # Add t3 (dy) to a1
    jal offset_conversion_disp # This sets v0 to the offset address
    lw $t6, 0($v0) # sets t6 to color of current block
    #sw $t9, 0($v0) # paint to white for 
    beq $t6, $t5, traverse_to_end # check of color of current pixel (v0) is same color as self (t5)
  # lw $t7, red # just check, paint red at end
  # sw $t7, 0($v0)
  
  # We are reusing t5 since we dont need color anymore to assign T/F to length check

  # Since we are using post condition we need to decrement by 1
  addi $t1, $t1, -1
  slt $t5, $t1, $t7 # Set t5 to 1 if t1 is less than t7 (4)
  # if t1 < t7 so if t5 is less than 7 jump to the end 
  # else create loop to color all pixels in from starting pixel t4, incrementing by dx and dy each time, decrementing counter each time until counter hits 0
  bnez $t5, paint_chain_end # so if nothing to clear go to end 
  move $a0, $t4
  move $a1, $t8
  paint_chain:
    # start at start coordinate of chain
    # keep on traversing the other way 
  
    # we dont need t6 anymore so we will replace it with black
    lw $t6, black # load black into t6
    
    # traverse

    # Moving current coord to paint into input a0, a1 to convert into address by calling offset_conversion_disp


    add $a0, $a0, $t2
    add $a1, $a1, $t3
    jal offset_conversion_disp
    move $t7, $v0 # So now t7 holds the color of the current tile
    # rn a0 holds x, a1 holds y
    push ($t0)
    push ($t1)
    push ($t2)
    jal offset_conversion_link_grid
    # So now v0 holds offset of coord in link grid
    lw $t2, 0($v0)                    # Setting link grid offset of self to zero since its being deleted
    beqz $t2, skip_clear_linked
    sw $zero, 0($t2)                  # setting link grid offset of its other half to 0. since we are deleting current tile
    skip_clear_linked:
    
    sw $zero, 0($v0)                  # Setting link grid offset of self to zero since its being deleted
    
        

    pop ($t2)
    pop ($t1)
    pop ($t0)
    
    # Destroying virus logic: We want to change track when a virus is destroyed
    push ($t0)
    push ($t1)
    push ($t2)
    push ($t7)
    jal is_virus # sets v0 to 1 if its a virus
    li $t5, 1
    pop ($t7)
    bne $v0, $t5, virus_destroy_end
      lw $a0, 0($t7)
      jal virus_destroyed
    virus_destroy_end:
    pop ($t2)
    pop ($t1)
    pop ($t0)
    # End of destroying virus logic
    sw $t6, 0($t7) # paint current tile saved to black
    #
    addi $t1, $t1, -1
    bne $t1, $zero, paint_chain
  jal drop_all_pixels

  # If code reaches here that means a drop occured
  push ($v0)
  push ($a0)
  push ($a1)
  push ($a2)
  push ($a3)
  # 模拟声音播放：用 MIDI 音效
  li $v0, 31
  li $a0, 60       # pitch，中音C
  li $a1, 300      # duration，300ms
  li $a2, 0      # instrument
  li $a3, 100      # volume
  syscall
  pop ($a3)
  pop ($a2)
  pop ($a1)
  pop ($a0)
  pop ($v0)
  paint_chain_end:

  pop ($a1)
  move $a0, $a1
  
  pop ($ra)
  jr   $ra 

virus_destroyed:
  # Inputs: a0: color of the virus
  push ($ra)
  push ($t0)
  push ($t1)
  push ($t2)
  push ($t3)
  # We will load the 3 colors into t1 t2 t3
  lw $t1, red
  lw $t2, yellow
  lw $t3, blue

  beq $a0, $t1, remove_red_virus
  beq $a0, $t2, remove_yellow_virus
  beq $a0, $t3, remove_blue_virus
  move $t0, $a0
  remove_red_virus:
    li $a0, 7
    li $a1, 28
    li $a2, 0x8B0000   
    jal draw_virus
    j remove_virus_end




  remove_yellow_virus:
    li $a0, 12
    li $a1, 28
    li $a2, 0xA0A000
    jal draw_virus
    j remove_virus_end

  

  remove_blue_virus:
    li $a0, 17
    li $a1, 28
    li $a2, 0x008B8B
    jal draw_virus
    j remove_virus_end
  remove_virus_end:
    
  pop ($t3)
  pop ($t2)
  pop ($t1)
  pop ($t0)
  pop ($ra)
  jr $ra
# $a0 = original value
# $a1 = bit index
# result in $v0

set_bit:
    li   $t0, 1
    sllv $t0, $t0, $a1    # t0 = 1 << i
    or   $v0, $a0, $t0
    jr $ra

# $a0 = original value
# $a1 = bit index
# result in $v0

clear_bit:
    li   $t0, 1
    sllv $t0, $t0, $a1    # t0 = 1 << i
    not  $t0, $t0         # t0 = ~(1 << i)
    and  $v0, $a0, $t0
    jr $ra
    
drop_all_pixels:
  push ($ra)
  push ($s7)
  # t8 will be used to indicate whether if a drop occured or not. We check at the end to see if t8 is 0 
  drop_pixel_loop_start:
  li $s7, 0
  loop_bottom_rect:
    ########## loop for main bottle ##########
    li $t0, 3         # x_start
    li $t1, 17       # x_end
    li $t2, 25        # y_bottom
    li $t3, 8         # y_top
    
    loop_bottom_x:
        bgt $t0, $t1, done_bottom_rect
        push ($t0) # a
        push ($t1) # b
        move $t4, $t0                 # current x
        move $t5, $t2                 # current y
    
    loop_bottom_y:
        blt $t5, $t3, next_bottom_x
    
        # ===== do stuff with (x = $t4, y = $t5) =====
        # t4 is current x and t5 is current y
        move $a0, $t4
        move $a1, $t5
        push ($t2) # c
        push ($t3) # d
        push ($t5)
        jal drop 
        pop ($t5)
        pop ($t3) # d
        pop ($t2) # c
        or $s7, $s7, $v1 # logic or to check if something was shifted or not
    
        #lw $t6, yellow
        # you can now read/write pixel using $v0
        #sw $t6, 0($v0)
  
        addi $t5, $t5, -1
        j loop_bottom_y
    
    next_bottom_x:
      pop ($t1)
      pop ($t0)
      addi $t0, $t0, 1
      j loop_bottom_x
    
  done_bottom_rect:

    
  traverse_top_rect:
      ########## loop for small top rectangle ##########
    li $t0, 8        # x_start
    li $t1, 10        # x_end (inclusive)
    li $t2, 7         # y_bottom
    li $t3, 5         # y_top
    loop_top_x:
        bgt $t0, $t1, done_top_rect     # if x > x_end, done
        push ($t0) # Store t0sss
        push ($t1)
        
        move $t4, $t0                 # $t4 = current x
        move $t5, $t2                 # $t5 = current y (start from bottom)
    
    loop_top_y:
        blt $t5, $t3, next_top_x   # if y < y_top, go to next column
    
        # ===== do stuff with (x = $t4, y = $t5) =====
        move $a0, $t4
        move $a1, $t5

        push ($t2)
        push ($t3)
        push ($t4)
        push ($t5)
        jal drop 
        pop ($t5)
        pop ($t4)
        pop ($t3)
        pop ($t2)
        # need to store t8 
        or $s7, $s7, $v1 # logic or to check if something was shifted or not
 
        # you can now read/write pixel using $v0

        # ============================================
    
        addi $t5, $t5, -1             # y -= 1
        j loop_top_y
    
    next_top_x:
        pop ($t1)
        pop ($t0)
        addi $t0, $t0, 1              # x += 1

        j loop_top_x
    
    done_top_rect:
  beq $s7, 1, drop_pixel_loop_start


  pop ($s7)
  pop ($ra) 


  jr $ra
is_pixel_broken:
  # Sets v0 to 1 if pixel doesnt have other half, else set to 0
  # Inputs: a0 = x, a1 = y
  push ($ra)
  push ($t0)
  jal offset_conversion_link_grid
  lw $t0, 0($v0) # t0 holds the offset that current pixel's partner is or 0
  beqz $t0, pixel_is_broken
    li $v0, 0
    j pixel_broken_if_end
  pixel_is_broken:
    li $v0, 1
    j pixel_broken_if_end
  pixel_broken_if_end:
  pop ($t0)
  pop ($ra)
  jr $ra
drop:
  # Keep on looping until no further drops to continuously drop
  
  # Input: a0 = x coord, a1 = y coord
  # Action: if x,y is black and top of x,y is not black then drop
  # Output: set v1 to 1 if there was drop, 0 if no drop
  push ($t4)
  push ($ra)
  # t7 will store if there was a drop or not
  # ## lw $t8, white
  # Set v1 to 0


  li $v1, 0
  drop_loop:
    jal offset_conversion_disp # so now v0 holds offset of current pixel
    move $t3, $v0 # move offset of pixel into t3

    lw $t0, black
    lw $t2, 0($t3) # Move color of v0 into t2

    bne $t0, $t2, drop_end # If current pixel is not black then drop_end
    # Check if current pixel is broken 
    # lw $t1, white
    # sw $t1, 0($t3)
    
    addi $a1, $a1, -1 # get the pixel above
    jal is_virus # this sets v1 to 1 if its virus
    li $t6, 1 
    beq $v0, $t6, virus_so_no_drop
    jal offset_conversion_disp # so now v0 holds offset of pixel on top 
    # We check if the top pixel is broken. If it's not then we dont drop
   
    move $t5, $t4 # We store the previous color in t5 so we can check again laters
    lw $t4, 0($v0) # load color of top pixel into t4
    lw $t0, black
    beq $t4, $t0, drop_end # if top is black we do nothing
    # So now top is not black, we want to check if its a broken capsule. We only drop if its a broken capsule 
    #
    jal offset_conversion_disp
    # lw $t1, white
    # sw $t1, 0($v0)
    #
    push ($v0)
    jal is_pixel_broken # 
    li $t1, 1
    move $t7, $v0
    pop ($v0)
    bne $t7, $t1, drop_end # If is_pixel_broken not equal to 1 (pixel is not broken then we jump to then end (we dont drop))

    # We want to still drop if capsule is not broken but both of the pixels can be dropped
    drop_start: 
    lw $t0, black
    sw $t4, 0($t3) # paint the bottom pixel the color of the top pixel
    sw $t0, 0($v0)
    # 
    push ($v0)
    push ($a0)
    push ($a1)
    push ($a2)
    push ($a3)
    # 模拟声音播放：用 MIDI 音效
    li $v0, 31
    li $a0, 60       # pitch，中音C
    li $a1, 300      # duration，300ms
    li $a2, 120      # instrument
    li $a3, 100      # volume
    syscall
    pop ($a3)
    pop ($a2)
    pop ($a1)
    pop ($a0)
    pop ($v0)
    li $v1, 1
  drop_end:
  # now a0, and a1 still have correct coords
  li $a2, 0
  move $a3, $t5 # We want to check for new color
  jal check_chain
  li $a2, 1
  jal check_chain
  
  virus_end:
  pop ($ra)
  pop ($t4)
  jr $ra
  virus_so_no_drop:
    li $v0, 0
    j virus_end
  pixel_not_broken:
    # Precondition: top pixel can be dropped
    # If top pixel is not broken, we still want to drop if entire capsule can be dropped.
    # So top if pixel is not broken, check if other half of top pixel can be dropped. We check if the offset of its other half's below is empty
    # Rn a0, a1 holds the position of the pixel above. v0 holds offset of tile above. 
    push ($v0)
    push ($t0)
    push ($t1)
    jal offset_conversion_link_grid
    lw $t0, 0($v0) # So now t0 holds linkoffset of the top pixels other half
    # Now, we check if this block can be dropped. It can be dropped if the tile below it is original top pixel, or that its black
    lw $t1, 32($t0) # this gets the color of y-- of the top pixels other half

    # bne 
    pixel_not_broken_drop_end:
    pop ($t1)
    pop ($t0)
    pop ($v0)
    
    j drop_end

init_offset_link_zero:
  la $t0, offset_link_grid
  li $t1, 1024        # 32 × 32 = 1024 entries
  
  li $t2, 0           # the zero value
  zero_loop:
      beqz $t1, done_zero
      sw $t2, 0($t0)
      addi $t0, $t0, 4
      addi $t1, $t1, -1
      j zero_loop
  
  done_zero:
  jr $ra

check_game_end:
  # Input: a0 holds y coordinate of pixel just placed.
  blt $a0, 5, set_game_end # branch if less than 8, else go back
  jr $ra
  set_game_end:
    j handle_q

# Capsule display:
# We will store the color of the next 4 capsules in next_capsules. With the 1st 8 bytes being color of pixel 1 and 2nd 8 bytes being color of pixel 2
# The colors of the current pixels are stored in s0 and s1

  
update_next_capsules:
  # Shift all capsules over by 2, store the most recent 8 bytes, color1 and color2 in v0 and v1
  # $t0 = base of next_capsules
  # Shift then generate new one
  push ($ra)
    la $t0, next_capsules      # $t0 = base of capsule array

    # step 1: load left-most 2 words (capsule[0])
    lw $s0, 0($t0)             # color1
    lw $s1, 4($t0)             # color2

    # step 2: shift remaining capsules left by 8 bytes
    li $t1, 0                  # start at offset 8 (capsule[1])
    li $t2, 32                 # end at offset 32 (capsule[4])
shift_loop:
    lw  $t3, 8($t0)            # load word from current read position
    sw  $t3, 0($t0)           # store to position 8 bytes earlier
    addi $t0, $t0, 4           # move forward 1 word
    addi $t1, $t1, 4
    blt $t1, $t2, shift_loop

    jal initialize_next_capsules
    pop ($ra)

    
    jr $ra

initialize_next_capsules:
  push ($ra)
  la $t5, keyboard_address
  jal gen_next_colors
  pop ($ra)
    la $t0, next_capsules
    addi $t0, $t0, 32    # 4 capsules × 8 bytes
    sw $v0, 0($t0)
    sw $v1, 4($t0)

  jr $ra

update_next_capsules_display:
  push ($ra)
  push ($a1)
    # Start coordinates (x = 20, y = 3)
    li $a0, 13       # x = 20
    li $a1, 3        # y = 3
    li $t2, 5        # Number of tiles = 5

    # Base address for the framebuffer (assuming 32x32 display)
    la $t0, next_capsules   # next_capsules contains colors for the tiles

loop_tiles:
    # Load the colors of the current tile
    lw $t3, 0($t0)          # First color
    lw $t4, 4($t0)          # Second color
    
    li $a1, 3               # Reset y = 3 each timedaa
    # Calculate pixel position for the current tile
    # Place the tile at (x, y), with a 1-pixel gap downwards

    # inputs a0 and a1 have already been set
    push ($t0)
    jal offset_conversion_disp
    sw $t3, 0($v0)
    addi $a1, $a1, 1
    jal offset_conversion_disp
    sw $t4, 0($v0)
    pop ($t0)
    # Move to the next tile, increment x by 2 and y by 1 (gap)
    addi $a0, $a0, 2        # Increase x by 2 (next tile's position)

    # Move to the next tile (advance the pointer for next capsule)
    addi $t0, $t0, 8        # Move to next capsule (2 words = 8 bytes)

    # Repeat for all 5 tiles
    subi $t2, $t2, 1        # Decrease tile counter
    bgtz $t2, loop_tiles    # Loop until we reach the last tile
  pop ($a1)
  pop ($ra)
  jr $ra                   # Return after finishing


generate_xy_coord:
  # Takes no inputs, save x,y coordinates in v0 and v1
  # generate x in [3, 17]
  li $a0, 0
  li $a1, 14          # 18 - 4 + 1 = 15
  li $v0, 42
  syscall
  add $t5, $a0, 3     # x = rand + 4
  
  # generate y in [8, 25]
  li $a0, 0
  li $a1, 13         # 25 - 8 + 1 = 18
  li $v0, 42
  syscall
  add $t6, $a0, 11     # y = rand + 11
  move $v0, $t5
  move $v1, $t6
  jr $ra


initialize_virus:
  # Initialize viruses. Store them in virus pair label. 1st two is red, 2nd two is yellow, 3rd two is blue
  push ($ra)
  la $t0, virus_pairs        # load base address into $s0
  
  jal generate_xy_coord
  sb $v0, 0($t0)       # 1st value
  sb $v1, 1($t0)       # 2nd value

  # paint them onto display
  move $a0, $v0
  move $a1, $v1
  jal offset_conversion_disp
  lw $t2, red
  sw $t2, 0($v0)

  
  jal generate_xy_coord
  la $t0, virus_pairs        # load base address into $s0
  sb $v0, 2($t0)       # 3rd value
  sb $v1, 3($t0)       # 4th value

  move $a0, $v0
  move $a1, $v1
  jal offset_conversion_disp
  lw $t2, yellow
  sw $t2, 0($v0)
  
  jal generate_xy_coord
  la $t0, virus_pairs        # load base address into $s0
  sb $v0, 4($t0)       # 5th value
  sb $v1, 5($t0)      # 6th value
  # Paint them
  move $a0, $v0
  move $a1, $v1
  jal offset_conversion_disp
  lw $t2, blue
  sw $t2, 0($v0)
  jal draw_virus_display
  pop ($ra)
  jr $ra

draw_virus_display:
  
get_red_virus:
  # store coordinates of x,y of red virus in v0, v1
  la $t0, virus_pairs
  lb $v0, 0($t0)    # virus1 x
  lb $v1, 1($t0)    # virus1 y
  jr $ra

get_yellow_virus:
  la $t0, virus_pairs
  lb $v0, 2($t0)    # virus1 x
  lb $v1, 3($t0)    # virus1 y
  jr $ra

get_blue_virus:
  # get blue virus x,y 
  la $t0, virus_pairs
  lb $v0, 0($t0)    # virus1 x
  lb $v1, 1($t0)    # virus1 y
  jr $ra

is_virus:
  # Input: a0 = x, a1 = y coord to check
  # Output: set v0 to 0 if tile is not virus , set v0 to 1 if it is virus
  push ($ra)
  la $t0, virus_pairs    # base addr

  # check red virus
  lb $t1, 0($t0)         # red x
  lb $t2, 1($t0)         # red y
  beq $t1, $a0, check_red_y
  j check_yellow

  check_red_y:
      beq $t2, $a1, found_virus
      # else fall through
  
  check_yellow:
      lb $t1, 2($t0)         # yellow x
      lb $t2, 3($t0)         # yellow y
      beq $t1, $a0, check_yellow_y
      j check_blue
  
  check_yellow_y:
      beq $t2, $a1, found_virus
      # else fall through
  
  check_blue:
      lb $t1, 4($t0)         # blue x
      lb $t2, 5($t0)         # blue y
      beq $t1, $a0, check_blue_y
      j not_virus
  
  check_blue_y:
      beq $t2, $a1, found_virus
      j not_virus
  
  found_virus:
      li $v0, 1
      pop ($ra)
      jr $ra
  
  not_virus:
      li $v0, 0
      pop ($ra)
      jr $ra

load_mario:
    push ($ra)
    la $t6, drmario_sprite       # base address of sprite_data

    li $t0, 18          # x_start
    li $t1, 31          # x_end (inclusive, x spans 13 columns)
    li $t2, 23          # y_bottom
    li $t3, 6           # y_top


loop_bottom_x1:
    bgt $t0, $t1, done_bottom_rect1
    push ($t0)
    push ($t1)

    move $t4, $t0       # current x
    move $t5, $t2       # current y

loop_bottom_y1:
    blt $t5, $t3, next_bottom_x1

    # compute sprite index = (y - 6) * 13 + (x - 19)
    sub $t9, $t5, 6        # row = y - y_top
    sub $t7, $t4, 19       # col = x - x_start
    li  $t8, 13
    mul $t9, $t9, $t8      # row * 13
    add $t9, $t9, $t7      # index = row * 13 + col

    # load color from sprite
    sll $t9, $t9, 2        # index * 4
    add $t9, $t6, $t9
    lw  $t7, 0($t9)

    # draw pixel
    move $a0, $t4
    move $a1, $t5
    jal offset_conversion_disp
    sw $t7, 0($v0)

    addi $t5, $t5, -1      # y--
    j loop_bottom_y1

next_bottom_x1:
    pop ($t1)
    pop ($t0)
    addi $t0, $t0, 1
    j loop_bottom_x1

done_bottom_rect1:
    pop ($ra)
    jr $ra

load_virus:
  
    push ($ra)

    li $a0, 7
    li $a1, 28
    lw $a2, red
    jal draw_virus


    li $a0, 12
    li $a1, 28
    lw $a2, yellow
    jal draw_virus


    li $a0, 17
    li $a1, 28
    lw $a2, blue
    jal draw_virus
    pop ($ra)
    jr $ra
    


draw_virus:
  # Input: a0 : starting x, a1: starting y, a2 = color label
  # Action: draw a 2x2 square with top left corner being (a0, a1)
    push ($ra)
    move $t3, $a2
    jal offset_conversion_disp
    
    sw $t3, 0($v0)
    addi $a1, $a1, 1
    jal offset_conversion_disp

    sw $t3, 0($v0)
    addi $a0, $a0, 1
    jal offset_conversion_disp

    sw $t3, 0($v0)
    addi $a1, $a1, -1
    jal offset_conversion_disp

    sw $t3, 0($v0)
    pop ($ra)
    jr $ra

draw_white_P:
    push ($ra)
    la $t0, white_P   # base address of sprite
    li $t1, 0                # index = 0

    li $t2, 0                # y = 0
draw_y:
    li $t3, 32
    bge $t2, $t3, done_draw

    li $t4, 0                # x = 0
draw_x:
    bge $t4, $t3, next_row

    # load color
    sll $t5, $t1, 2          # offset = index * 4
    add $t6, $t0, $t5
    lw $t7, 0($t6)           # color

    move $a0, $t4            # x
    move $a1, $t2            # y
    push ($t0)
    jal offset_conversion_disp
    pop ($t0)
    #lw $t7, white
    sw $t7, 0($v0)           # paint pixel

    addi $t1, $t1, 1         # index++
    addi $t4, $t4, 1         # x++
    j draw_x

next_row:
    addi $t2, $t2, 1         # y++
    j draw_y

done_draw:
    pop ($ra)
    jr $ra

save_board:
    push ($ra)
    lw $t0, displayaddress     # base of display
    la $t1, board_storage       # base of backup
    li $t2, 0                  # index

    save_loop:
        li $t3, 1024               # total words = 32x32
        bge $t2, $t3, save_done
    
        sll $t4, $t2, 2            # offset = index * 4
        add $t5, $t0, $t4
        lw  $t6, 0($t5)            # load from display
    
        add $t7, $t1, $t4
        sw  $t6, 0($t7)            # store to backup
    
        addi $t2, $t2, 1
        j save_loop
    
    save_done:
        pop ($ra)
        jr $ra

restore_board:
    push ($ra)
    lw $t0, displayaddress     # base of display
    la $t1, board_storage       # base of backup
    li $t2, 0

restore_loop:
    li $t3, 1024               # total words
    bge $t2, $t3, restore_done

    sll $t4, $t2, 2
    add $t5, $t1, $t4
    lw  $t6, 0($t5)            # load from backup

    add $t7, $t0, $t4
    sw  $t6, 0($t7)            # store to display

    addi $t2, $t2, 1
    j restore_loop

restore_done:
    pop ($ra)
    jr $ra
