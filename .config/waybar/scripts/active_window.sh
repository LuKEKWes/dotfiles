#!/usr/bin/env bash

declare -A ICONS=(
  ["firefox"]=""
  ["opera"]=""
  ["mpv"]=""
  ["kitty"]="󰄛"
  ["alacritty"]=""
  ["Gimp"]=""
  ["discord"]=""
  ["spotify"]=""
  ["thunderbird"]=""
  ["nvim"]=""
  ["vim"]=""
  ["nautilus"]=""
  ["pcmanfm"]=""
  ["ghostty"]="󰊠"
)

#fallback
FALLBACK_ICON=""

pick_icon() {
  local key="$1"
  key="${key,,}"
  key="${key// /}"
  for k in "${!ICONS[@]}"; do
    if [[ "$key" == *"${k}"* ]]; then
      printf "%s" "${ICONS[$k]}"
      return 0
    fi
  done
  printf "%s" "$FALLBACK_ICON"
  return 0
}

get_sway_info() {
  if ! command -v swaymsg >/dev/null 2>&1; then
    return 1
  fi
  title=$(swaymsg -t get_tree \
    | jq -r '.. | objects | select(.focused==true) | (.name // "")' 2>/dev/null | head -n1)
  app_id=$(swaymsg -t get_tree \
    | jq -r '.. | objects | select(.focused==true) | (.app_id // .window_properties.class // "")' 2>/dev/null | head -n1)
  echo "$title" "$app_id"
  return 0
}

get_hypr_info() {
  if ! command -v hyprctl >/dev/null 2>&1; then
    return 1
  fi

  if hyprctl activewindow -j >/dev/null 2>&1; then
    title=$(hyprctl activewindow -j | jq -r '.title // ""' 2>/dev/null)
    app_id=$(hyprctl activewindow -j | jq -r '.class // ""' 2>/dev/null)
    echo "$title" "$app_id"
    return 0
  fi

  out=$(hyprctl activewindow 2>/dev/null)
  if [[ -n "$out" ]]; then
    # attempt to find Title: and Class: lines (format may vary)
    title=$(printf "%s" "$out" | sed -n 's/^.*Title:[[:space:]]*//p' | head -n1)
    app_id=$(printf "%s" "$out" | sed -n 's/^.*Class:[[:space:]]*//p' | head -n1)
    echo "$title" "$app_id"
    return 0
  fi

  return 1
}

# match name with icon (hyprctl/sway)
if get_hypr_info >/dev/null 2>&1; then
  read -r title app_id <<< "$(get_hypr_info)"
elif get_sway_info >/dev/null 2>&1; then
  read -r title app_id <<< "$(get_sway_info)"
else
  title=""
  app_id=""
fi

if [[ -z "$title" && -z "$app_id" ]]; then
  printf ""
  exit 0
fi

icon=$(pick_icon "${app_id:-$title}")

maxlen=60
if [[ -n "$title" && ${#title} -gt $maxlen ]]; then
  title="${title:0:$((maxlen-3))}..."
fi

printf '%s %s' "$icon" "${title:-$app_id}"
