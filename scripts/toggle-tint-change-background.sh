#!/bin/bash

# Path to Kitty configuration file
CONFIG_FILE="$HOME/.config/kitty/kitty.conf"

# Paths to your background images (relative to Kitty config)
DEFAULT_BG="/home/aditya/.config/kitty/images/685095.png"
ULTRAWIDE_BG="/home/aditya/.config/kitty/images/xi4agl8t2mm61.png"
KITTY_CONFIG="/home/aditya/.config/kitty/kitty.conf"

# Temporary file for the modified configuration
TEMP_FILE=$(mktemp)

# Variable to hold the current tint value
CURRENT_TINT=""


# Detect the current screen resolution
resolution=$(xrandr | grep '*' | awk '{print $1}' | head -n 1)

# Read the configuration file line by line to find the current tint value
while IFS= read -r line; do
    if [[ $line == background_tint* ]]; then
        CURRENT_TINT=$(echo $line | awk '{print $2}')
        break
    fi
done < "$CONFIG_FILE"

# Toggle the tint value
if [[ "$CURRENT_TINT" == "1.0" ]]; then
    NEW_TINT="0.95"
else
    NEW_TINT="1.0"
fi

# Update the Kitty configuration with the appropriate background
if [ "$resolution" == "3440x1440" ]; then
    sed -i "s|^background_image.*|background_image $ULTRAWIDE_BG|" "$KITTY_CONFIG"
    # echo "Switched to ultrawide background."
else
    sed -i "s|^background_image.*|background_image $DEFAULT_BG|" "$KITTY_CONFIG"
    # echo "Switched to default background."
fi

# Update the configuration file with the new tint value
sed -i "s/background_tint .*/background_tint $NEW_TINT/" "$CONFIG_FILE"


# # Reload Kitty configuration to apply changes
# kitty @ set-colors -a "$KITTY_CONFIG"

# Restart Kitty
pkill -USR1 -x kitty
