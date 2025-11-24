# lazer-tweaks

osu!lazer installer for Linux, with additional tweaks!

<img width="1531" height="799" alt="image" src="https://github.com/user-attachments/assets/342cc30c-e139-479d-9ba5-d08b70af37a9" />

## Features
- Installs the latest AppImage (with automatic updates support) and provides a .desktop launcher
- Automatically sets some PipeWire environmental variables for low-latency audio
- Includes fixes for osu!lazer not showing when streaming single applications on Discord, as both window or audio source
- Provides a list of useful environmental variables (SDL, PipeWire..) for the game in the configuration file
  - Can be opened with `lazertweaks --config`

## Installation

```
git clone https://github.com/NelloKudo/lazer-tweaks.git
cd lazer-tweaks
./installer.sh

# or ./installer.sh --tachyon
```

WARNING: You might need to relaunch terminal for `lazertweaks` to work.

## Usage

```
lazertweaks: Launches osu!lazer.
lazertweaks --config: Opens the configuration files for useful env. variables.
lazertweaks --remove: Uninstalls the script provided files.
```
