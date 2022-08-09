#!/bin/bash

ICON_THEME_NAME=$(gsettings get org.gnome.desktop.interface icon-theme | sed "s/'//g")

help () {
    echo "Syntax: $0 [-i|-b|-h]"
    echo "-i, --install     Fix the icons for snap apps"
    echo "-b, --backup      Restore the backup of the original .desktop files"
    echo "-h, --help        Show this message"
}

change_icons () {
    for path in "/home/$USER/.local/share/icons/$ICON_THEME_NAME" "/home/$USER/.icons/$ICON_THEME_NAME" "/usr/share/icons/$ICON_THEME_NAME"; do
        # check if icon theme is installed
        if [ -d $path ]; then
            # list through all snap desktop applications
            for i in $(ls /var/lib/snapd/desktop/applications/*.desktop | cut -d '_' -f 2 | cut -d '.' -f 1); do
                # check if app icon exists in icon theme
                if [ -s "$path/apps/scalable/$i.svg" ]; then
                    # make a backup file
                    sudo cp "/var/lib/snapd/desktop/applications/$i"_"$i.desktop" "/var/lib/snapd/desktop/applications/$i"_"$i.desktop.bck"
                    # check if backup was successfully created
                    if [ $? -eq 0 ]; then
                        # replace line with icon by app name
                        sudo sed -i "/Icon/c\Icon=$i" /var/lib/snapd/desktop/applications/$i"_"$i.desktop
                    fi
                fi
            done
        fi
    done
}

restore_backup () {
    for backup_file in $(ls /var/lib/snapd/desktop/applications/*.desktop.bck); do
        sudo cp $backup_file "${backup_file%.*}"
    done
}

delete_backup () {
    for backup_file in $(ls /var/lib/snapd/desktop/applications/*.desktop.bck); do
        sudo rm $backup_file
    done
}

while [ -n "$1" ]; do
    case "$1" in
        -h|--help) help ;;
        -i|--install) change_icons ;;
        -b|--backup) restore_backup ;;
        *) echo "Option $1 not recognized"
        help ;;
    esac
    shift
done
