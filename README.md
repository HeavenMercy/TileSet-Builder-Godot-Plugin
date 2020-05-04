# TileSet Builder (Godot 3.x Plugin)

for the version for Godot 2.x: [Click here](https://github.com/HeavenMercy/TileSet-Builder-Godot-Plugin/tree/godot_2)

A Godot plugin that builds a *.tscn (scene before tileset) or *.tres (tileset directly). You have to input those informations: **Spritesheet Path**, **Tile Size**, **Offset** (mpadding of the spritesheet), **Spacing** between tiles, **Destination** of the generated tileset.

## Installation
To install the plugin, follow those steps:
1. In the repository **code** page, click the **Clone or download** button
2. In the menu, click the **Download ZIP** button
3. **Unzip** the downloaded file in an empty folder (recommended for any archive)
4. **Move** the folder inside into the **GODOT_PROJECT_FOLDER/addons/**
5. **Open** the **GODOT_PROJECT_FOLDER** and do **Scene > Project Settings**
6. In the **Plugins** tab, set the plugin status to **Active**
7. WELL DONE !!! The plugin is installed

## Usage
To use the plugin, follow those steps:
1. Open the **2D** view
2. Click the **Build Tileset** button on the _editor toolbar_
3. In the dialog, **fill** all the required informations _in_ and click the **OK** button
4. WELL DONE !!! You will find the generated scene/tileset in the specified destination

_NB: If you check **Generate intermediate scene**, a scene (\*.tscn) will be generated instead of a tileset (\*.tres)_

## Uninstallation
To uninstall the plugin, follow those steps:
1. **Open** the Godot project _which has the plugin_ and do **Scene > Project Settings** _(optional)_
2. In the **Plugins** tab, set the plugin status to **Inactive** _(optional)_
3. Delete the related folder from **PROJECT_FOLDER/addons/**
7. WELL DONE !!! ~~You are free~~... Hum... The plugin is uninstalled

PS: Can @reduz, @Calinou, @akien-mga or any one else look at this repository and show it to others ? I really need feedbacks !
