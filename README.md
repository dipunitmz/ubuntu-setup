# Ubuntu Setup Scripts

I created this repository so everyone can contribute and help build quick setup files for installing applications and useful tools in Ubuntu.  
The goal is to make setting up a fresh Ubuntu system faster and easier for everyone.

Current files included:
- **setup_screenshot_shortcuts.sh** → sets up custom screenshot shortcuts  
  - **Super + Shift + S**: saves screenshot with notification  
  - **Ctrl + Alt + S**: copies screenshot to clipboard only  
- **ubuntu-setup.sh** → updates your system, installs Google Chrome, Visual Studio Code, and Terminator,  
  and sets Terminator as the default terminal emulator.

You can run these files from the terminal to quickly configure your Ubuntu system.  
All `.deb` packages are downloaded temporarily in the `/tmp` folder, which is automatically cleared after a system restart.

Feel free to add more setup scripts or improve the existing ones to make Ubuntu setup even smoother.
