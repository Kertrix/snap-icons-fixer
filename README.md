<div align="center">
  <a href="https://github.com/Kertrix/snap-icons-fixer">
    <img src="https://res.cloudinary.com/canonical/image/fetch/f_auto,q_auto,fl_sanitize,w_60,h_60/https://dashboard.snapcraft.io/site_media/appmedia/2018/04/Snapcraft-logo-bird.png" alt="Logo" height="80">
  </a>

  <h3 align="center">Snap icons fixer</h3>

  <p align="center">
    A simple bash script that fixes snap icons.
    <br />
    <br />
    <a href="#about-the-project">About</a>
      ·
    <a href="#installation-and-usage">Installation & Usage</a>
  </p>
</div>

## About The Project

If you have an icon theme installed, you probably saw that snap apps doesn't use your icon theme.

### How it works

I noticed that the path to the icons of snaps were directly hardwritten in the .desktop files. Therefore, they don't use your icon theme. So I searched and I found that we could directly use the name of the icon instead of the path. It just loops through all your snaps apps and change the icon.

### Built With

![Bash](https://img.shields.io/badge/bash-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)

## Getting Started

### Installation and Usage

To use this script simply download it and run this following command: ./fix_icons.sh -i (the -i option to install it)

Or you can use this oneliner:

```sh
curl -s https://raw.githubusercontent.com/Kertrix/snap-icons-fixer/master/fix_icons.sh -o fix_icons.sh; chmod +x fix_icons.sh; ./fix_icons.sh -i
```


---

<p align="center">Made with ❤️ by Kertrix</p>