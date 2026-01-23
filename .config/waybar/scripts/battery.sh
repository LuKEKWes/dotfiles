#!/usr/bin/env bash

capacity=$(cat /sys/class/power_supply/BAT*/capacity)
status=$(cat /sys/class/power_supply/BAT*/status)

# Generate visual bar
blocks=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)
filled=$((capacity / 12))
bar=""
for ((i = 0; i < 8; i++)); do
  if [ $i -le $filled ]; then
    bar+="█"
  else
    bar+="░"
  fi
done

# Status symbols
charging_icon=""
if [[ "$status" == "Charging" ]]; then
  charging_icon="⚡"
fi

echo "{\"text\": \"$charging_icon $bar $capacity%\", \"class\": \"battery\", \"tooltip\": \"Battery: $capacity% ($status)\"}"
