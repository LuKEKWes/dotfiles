# My Arch Linux / Hyprland dotfiles

Use at your own risk, any damage to your own hardware is not on me but on you because you were too lazy to write your own dotfiles :) .

## Using stow

This is just information for me so that i wont forget how to add/remove dofiles.

### Adding dotfile
1. Move files into /dotfiles
2. stow .

### Removing dotfile
1. Unstow first: stow -D .
2. Remove the file
3. Restow: stow .

### Big changes
Use stow -R . to fix links. (The shouldnt be broken but better safe than sorry :) )

## Some notes:
### Waybar config
The waybar config uses css for its styling. But ive been using scss for more cleaner look so you will need a compile into css,
so that waybar can be styled. 
Im using sass. Look it up idk.
