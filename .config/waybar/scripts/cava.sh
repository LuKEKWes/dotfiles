#!/bin/bash

bar=" ▂▃▄▅▆▇█"
dict="s/;//g;"

# Create a sed dictionary to replace numbers with bar characters
i=0
while [ $i -lt ${#bar} ]
do
    dict="${dict}s/$i/${bar:$i:1}/g;"
    i=$((i=i+1))
done

# Run cava with the dedicated config and pipe output through sed
cava -p ~/.config/cava/waybar_config | sed -u "$dict" | sed -u 's/^[ ]*$//'
