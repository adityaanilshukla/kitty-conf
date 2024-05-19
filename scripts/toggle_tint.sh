# Path to Kitty configuration file
CONFIG_FILE="$HOME/.config/kitty/kitty.conf"

# Temporary file for the modified configuration
TEMP_FILE=$(mktemp)

# Variable to hold the current tint value
CURRENT_TINT=""

# Read the configuration file line by line to find the current tint value
while IFS= read -r line; do
    if [[ $line == background_tint* ]]; then
        CURRENT_TINT=$(echo $line | awk '{print $2}')
        break
    fi
done < "$CONFIG_FILE"

# Toggle the tint value
if [[ "$CURRENT_TINT" == "1.0" ]]; then
    NEW_TINT="0.98"
else
    NEW_TINT="1.0"
fi

# Update the configuration file with the new tint value
sed -i "s/background_tint .*/background_tint $NEW_TINT/" "$CONFIG_FILE"

# Restart Kitty
pkill -USR1 -x kitty
