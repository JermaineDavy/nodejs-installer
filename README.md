# NodeJS-Installer

This script makes installing nodejs a bit easier on linux as it does every for you by placing the nodejs application along your other applications and adding nodejs to your path through symlinks

## How to use

1) Either clone or download this repo.

2) cd into the cloned directory.

3) Run  `chmod +x install.sh` to make this script executable.

4) Run `./install.sh`

The script will now begin running. Follow the prompts to install. If you're unsure which version to install, select the LTS version. You may be asked to provide your sudo password during installation. Enter your password and it will continue running.

Once the script has completed running, you can test your installation by running:

```
node --version
```

## Notes

When prompted to delete temporary files, if you enter `yes` or `y`, this script will delete itself and the folder it's in which is the cloned repo. Press enter without adding any input to not do this.