<h1 align="center"> Snap icons fixer </h1>

### A simple bash script that fixes snap icons.

# DISCLAIMER: If your icon theme is installed via snap, you can use [this command](https://gist.github.com/Kertrix/78fc2652a3309b1d88d24926b493e39b) to fix the icons (the original post from the [Ubuntu France Forum](https://forum.ubuntu-fr.org/viewtopic.php?id=2053913))

If you have an icon theme installed, you probably saw that snap apps doesn't use your icon theme.

# How to use
To use this script simply download it and run this following command: `./fix_icons.sh -i` (the -i option to install it)

Or you can use this oneliner:

`curl -s https://raw.githubusercontent.com/Kertrix/snap-icons-fixer/master/fix_icons.sh -o fix_icons.sh; chmod +x fix_icons.sh; ./fix_icons.sh -i`

# How it works
I noticed that the path to the icons of snaps were directly hardwritten in the .desktop files. Therefore, they don't use your icon theme. So I searched and I found that we could directly use the name of the icon instead of the path. 

