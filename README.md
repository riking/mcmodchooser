## MCModChooser
The original purpose of this project was to facilitate switching between multiple minecraft.jars for Minecraft.

It was written in Batch script.

The result of the project was that I learned to hate Batch.
For example, you can execute a variable - I think I do that at least once.
I'm pretty sure that there are some "security holes" in the sense that the user can run an arbitrary command.
I don't really remember, because it was written like a year ago.

## Features
 - Launch Minecraft immediately after selecting a .jar
 - Installing of mods from the utility using 7-zip and WinRAR Paid (Trial doesn't have command line)
 - Now-broken username spoofing (now requires other Java env vars)
 - Naming your jars & labelling them with the Minecraft version
 - Random build number using `%random%`
 - 9 minecraft.jars to switch between
 - Required to run as administrator in Vista/7 because user-level batch scripts can't edit `%APPDATA%` for some reason
 - First-run setup script
 - Ability to resume interrupted setup

### Folder Structure
 - mcmodchooser.bat - The main file
 - guidedsetup.bat - First-run setup script
 - tutorials.bat - A feeble attempt at a manual for the one-letter commands in this
 - jarmodloader - Example directory, belongs at `.minecraft/jarmodloader`
   - options.txt - settings file, dependent on the line order
   - README.txt - instructions for installing
   - TEMPLATE - Template for the Mod# folders
   - Mod1
     - mod.txt - The name and declared Minecraft version
     - minecraft.jar - The jar to use
   - Mod2 - Same as Mod1

