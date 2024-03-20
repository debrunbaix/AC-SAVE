# Assassin's Creed Unity and Syndicate Save Management

This project provides a PowerShell script to automate save management for Assassin's Creed Unity and Assassin's Creed Syndicate games. The script offers functionalities such as backing up, restoring, creating, and deleting save files, as well as launching the games.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Initial Setup](#initial-setup)
   - [config.json File](#configjson-file)
   - [load-saves.json File](#load-savesjson-file)
3. [Script Features](#script-features)
4. [Usage](#usage)
5. [Contribution](#contribution)
6. [License](#license)

## Prerequisites

- PowerShell 5.1 or higher
- Assassin's Creed Unity and Assassin's Creed Syndicate games installed on your machine
- Initial setup of the `config.json` and `load-saves.json` files

## Initial Setup

Before using the script, you need to set up the paths to the game saves and executables in the `config.json` and `load-saves.json` files.

### `config.json` File

This file contains paths to the save folders and game executables. You need to replace the default values with the paths corresponding to your installation.

```json
{
    "ACU_SAVE": "<path_to_ACU_saves>",
    "ACS_SAVE": "<path_to_ACS_saves>",
    "ACU_EXE": "<path_to_ACU_executable>",
    "ACS_EXE": "<path_to_ACS_executable>",
    "LOADED_SAVE": "<path_to_currently_loaded_save>"
}
```

### `load-saves.json` File

This file keeps track of the currently loaded saves for each game. Initially empty, it will be updated by the script as you use it.

```json
{
    "ACU": "",
    "ACS": ""
}
```

## Script Features

The script offers several options:

1. **See loaded saves**: Displays the names of the save files currently used by the games.
2. **Change save**: Allows you to choose and load a different save.
3. **Create new save**: Creates a new save folder and updates the `load-saves.json` file.
4. **Delete save**: Deletes a specific save folder.
5. **Launch games**: Enables you to start Assassin's Creed Unity or Syndicate directly from the script.
6. **Exit**: Backs up currently loaded files to their respective folders and exits the script.

## Usage

1. Open a PowerShell window.
2. `git clone https://github.com/debrunbaix/AC-SAVE.git`
3. `cd AC-SAVE`
4. Execute the script by typing: `.\main.ps1`
5. Follow the instructions displayed in the terminal to use the different functionalities.

## Contribution

Contributions to this project are welcome. Feel free to fork the project, make your changes, and submit a pull request.

## License

This project is free to use. It is provided as is, without warranty. You are responsible for the use and modifications made to the script.