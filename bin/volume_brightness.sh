#!/bin/bash

# See README.md for usage instructions
volume_step=5
brightness_step=5
max_volume=1.0
notification_timeout=1000

# Uses regex to get volume from pactl
function get_volume {
    volume=$(wpctl get-volume $AUDIO_DEV | grep -oP '\d\.\d+')
    printf "%.0f" $(echo "$volume * 100" | bc)
}

# Uses regex to get mute status from pactl
function get_mute {
    [[ $(wpctl get-volume $AUDIO_DEV) =~ \[MUTED\]$ ]] && echo "yes" || echo "no"
}

# Uses regex to get brightness from xbacklight
function get_brightness {
    brightnessctl | grep -oP '(\d+)%' | awk -F'%' '{print $1}'
}

# Returns a mute icon, a volume-low icon, or a volume-high icon, depending on the volume
function get_volume_icon {
    volume=$(get_volume)
    mute=$(get_mute)
    if [ "$mute" == "yes" ]; then
        volume_icon="󰖁"
    elif [ "$volume" -eq 0 ]; then
        volume_icon=""
    elif [ "$volume" -lt 50 ]; then
        volume_icon=""
    else
        volume_icon=""
    fi
}

function get_mic_icon ()
{
    mute=$(get_mute)
    if [ "$mute" == "yes" ]; then
        mic_icon="󰍭"
    else
        mic_icon="󰍬"
    fi
}

# Always returns the same icon - I couldn't get the brightness-low icon to work with fontawesome
function get_brightness_icon {
    brightness_icon="󰃞"
}

# Displays a volume notification
function volume_notification {
    volume=$(get_volume)
    get_volume_icon
    dunstify -r 111 -t $notification_timeout -h int:value:$volume "$volume_icon $volume%"
}

function mic_notification {
    volume=$(get_volume)
    get_mic_icon
    dunstify -r 222 -t $notification_timeout -h int:value:$volume "$mic_icon $volume%"
}

# Displays a brightness notification using dunstify
function brightness_notification {
    brightness=$(get_brightness)
    get_brightness_icon
    dunstify -r 333 -t $notification_timeout -h int:value:$brightness "$brightness_icon $brightness%"
}

# Main function - Takes user input, "volume_up", "volume_down", "brightness_up", or "brightness_down"
case $1 in
    volume_up)
    # Unmutes and increases volume, then displays the notification
    AUDIO_DEV="@DEFAULT_AUDIO_SINK@"
    wpctl set-mute $AUDIO_DEV 0
    wpctl set-volume $AUDIO_DEV -l $max_volume $volume_step%+
    volume_notification
    ;;

    volume_down)
    # Unmutes and decreases volume, then displays the notification
    AUDIO_DEV="@DEFAULT_AUDIO_SINK@"
    wpctl set-mute $AUDIO_DEV 0
    wpctl set-volume $AUDIO_DEV -l $max_volume $volume_step%-
    volume_notification
    ;;

    volume_mute)
    # Toggles mute and displays the notification
    AUDIO_DEV="@DEFAULT_AUDIO_SINK@"
    wpctl set-mute $AUDIO_DEV toggle
    volume_notification
    ;;

    mic_mute)
    # Toggles mute and displays the notification
    AUDIO_DEV="@DEFAULT_AUDIO_SOURCE@"
    wpctl set-mute $AUDIO_DEV toggle
    mic_notification
    ;;

    brightness_up)
    # Increases brightness and displays the notification
    brightnessctl set +2% -n 1 -q
    brightness_notification
    ;;

    brightness_down)
    # Decreases brightness and displays the notification
    brightnessctl set 2%- -n 1 -q
    brightness_notification
    ;;
esac
