#!/bin/bash

ICON_THEME_NAME=$(gsettings get org.gnome.desktop.interface icon-theme | sed "s/'//g")

help () {
    echo "Syntax: $0 [-i|-b|-h]"
    echo "-i, --install     Fix the icons for snap apps"
    echo "-b, --backup      Restore the backup of the original .desktop files"
    echo "-h, --help        Show this message"
}

show_title () {
    echo " 
     ____                      _                        __ _               
    / ___| _ __   __ _ _ __   (_) ___ ___  _ __  ___   / _(_)_  _____ _ __ 
    \___ \|  _ \ / _  |  _ \  | |/ __/ _ \|  _ \/ __| | |_| \ \/ / _ \  __|
     ___) | | | | (_| | |_) | | | (_| (_) | | | \__ \ |  _| |>  <  __/ |   
    |____/|_| |_|\__,_| .__/  |_|\___\___/|_| |_|___/ |_| |_/_/\_\___|_|   
                      |_| 
    "

}

change_icons () {
    show_title
    for path in "/home/$USER/.local/share/icons/$ICON_THEME_NAME" "/home/$USER/.icons/$ICON_THEME_NAME" "/usr/share/icons/$ICON_THEME_NAME"; do
        # check if icon theme is installed
        if [ -d $path ]; then
            # list through all snap desktop applications
            for i in $(ls /var/lib/snapd/desktop/applications/*.desktop | cut -d '_' -f 2 | cut -d '.' -f 1); do
                # check if app icon exists in icon theme
                if [ -s "$path/apps/scalable/$i.svg" ]; then
                # if backup does not exist
                    if [ ! -s "/home/$USER/.local/share/applications/$i"_"$i.desktop.bck" ] then;
                        # make a backup file
                        cp "/var/lib/snapd/desktop/applications/$i"_"$i.desktop" "/home/$USER/.local/share/applications/$i"_"$i.desktop.bck"
                    fi
                    # check if backup was successfully created
                    if [ $? -eq 0 ]; then
                        # copy the desktop file to the user's home directory
                        cp "/var/lib/snapd/desktop/applications/$i"_"$i.desktop" "/home/$USER/.local/share/applications/$i"_"$i.desktop"
                        # replace line with icon by app name
                        sed -i "/Icon/c\Icon=$i" "/home/$USER/.local/share/applications/$i"_"$i.desktop"
                        echo "Successfully changed the icon for app $i"
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
