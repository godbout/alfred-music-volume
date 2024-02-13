local APP_NAME=Music

autoload is-at-least
if ! is-at-least 10.15 $(sw_vers -productVersion); then
    APP_NAME=iTunes
fi

local new_volume volume=$(osascript -e "tell application \"$APP_NAME\" to get sound volume")
if [[ $# -eq 0 ]]; then
    echo "Current volume is ${volume}."
    return 0
fi
case $1 in
    up|u) new_volume=$((volume + 10 < 100 ? volume + 10 : 100)) ;;
    down|d) new_volume=$((volume - 10 > 0 ? volume - 10 : 0)) ;;
    <0-100>) new_volume=$1 ;;
    *) echo "'$1' is not valid. Expected <0-100>, up/u or down/d."
       return 1 ;;
esac
opt="set sound volume to ${new_volume}"

osascript -e "tell application \"$APP_NAME\" to $opt"
