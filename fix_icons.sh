#!/bin/bash

ICON_THEME_NAME=$(gsettings get org.gnome.desktop.interface icon-theme | sed "s/'//g")
LOCAL_PATH="/home/$USER/.local/share/applications/"
SNAP_PATH="/var/lib/snapd/desktop/applications/"

help () {
    echo "Syntax: $0 [-i|-b|-h|-e]"
    echo "-i, --install     Fix the icons for snap apps"
    echo "-b, --backup      Restore the backup of the original .desktop files"
    echo "-e, --eject       Delete all modified .desktop files and revert changes"
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
    for theme_path in "/home/$USER/.local/share/icons/$ICON_THEME_NAME" "/home/$USER/.icons/$ICON_THEME_NAME" "/usr/share/icons/$ICON_THEME_NAME"; do
        # check if icon theme is installed
        if [ -d $theme_path ]; then
            # list through all snap desktop applications
            for i in $(ls $1/*.desktop | cut -d '_' -f 2 | cut -d '.' -f 1); do
                # check if app icon exists in icon theme
                if [ -s "$theme_path/apps/scalable/$i.svg" ]; then
                # if backup does not exist
                    if [ ! -s "$LOCAL_PATH/$i"_"$i.desktop.bck" ]; then
                        # make a backup file
                        cp "$LOCAL_PATH/$i"_"$i.desktop" "$LOCAL_PATH/$i"_"$i.desktop.bck"
                    fi
                    # check if backup was successfully created
                    if [ $? -eq 0 ]; then
                        # copy the desktop file to the user's home directory
                        cp "$1/$i"_"$i.desktop" "$LOCAL_PATH/$i"_"$i.desktop"
                        # replace line with icon by app name
                        sed -i "/Icon/c\Icon=$i" "$LOCAL_PATH/$i"_"$i.desktop"
                        echo "Successfully changed the icon for app $i"
                    fi
                fi
            done
        fi  
    done
}

restore_backup () {
    for backup_file in $(ls $LOCAL_PATH/*.desktop.bck); do
        cp $backup_file "${backup_file%.*}"
    done
}

delete_backup () {
    for backup_file in $(ls $LOCAL_PATH/*.desktop.bck); do
        rm $backup_file
    done
}

eject () {
    delete_backup
    for file in $(ls $LOCAL_PATH/*.desktop); do
        rm $file
    done
}

if [ -z "$1" ]; then
    help
fi

while [ -n "$1" ]; do
    case "$1" in
        -h|--help) help ;;
        -f|--fix)             
            if [[ $2 == "snap" ]]; then
                change_icons "$SNAP_PATH"
            else
                if [[ -n "$2" ]]; then
                    if [ -d $2 ]; then
                        change_icons "$2"
                    else 
                        echo "The path must exist!"
                    fi
                else 
                    echo "The input must not be empty!"
                fi
            fi
            shift ;;
        -b|--backup) restore_backup ;;
        -e|--eject) eject ;;
        *) echo "Option $1 not recognized"
        help ;;
    esac
    shift
done
