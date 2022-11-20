# totkeks' dotfiles

These are my personal dotfiles used on my computers. Feel free to use them as an inspiration for your own setup.

Additionally this repository also includes useful scripts and other files to setup a new computer.

## Usage

The installation is very simple. Just run the `Install-Dotfiles` script and it will copy everything from `dotfiles` to your home directory (`~` or `$HOME`), keeping the directory structure.

When a file already exists, you have to confirm overwriting it.

In some files there are variables denoted by `<<VARNAME>>`, which you will be prompted for when the install script runs the first time. It then stores the values you provided in `~/.config/dotfiles.json` and reuses them the next time you update your dotfiles by running the install script again.

## Computer setup

To make setting up a new windows machine easier and faster, there are various files in the `setup/windows` directory.

### Add-WindowsTerminalQuakeModeShortcut

Puts a shortcut in `shell:startup` to automatically start a minimized Windows Terminal in quake mode on login.

### Install-NerdFont

Installs a [nerd font](https://www.nerdfonts.com) of your choosing in your current user's scope. Can of course be used multiple times to install more fonts.

### Volumes, folders and filenames

The registry file `enable-longpaths.reg` enables [NTFS long paths support](https://learn.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation?tabs=registry#enable-long-paths-in-windows-10-version-1607-and-later).

The script `Set-VolumeLabels` gives drives better semantic names.

The script `Set-FolderJunctions` should be used together with the `unattend-change-folder-locations.xml`. The latter moves the user home directory (`Users`) and program data (`ProgramData`) from the system drive to another drive. The script then adds junctions on the system drive for bad programs that have those paths hardcoded.
