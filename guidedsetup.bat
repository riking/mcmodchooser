cls
@echo off
color 1e
cd %appdata%\.minecraft
echo Welcome to Guided Setup.
if "%1"=="" goto start
echo Resuming...
cd jarmodloader
goto %1
:start
echo This program will guide you through the setup of Minecraft Mod Chooser.
echo In order for the program to work properly, you must follow all directions.
echo.
echo.
echo.
echo IF YOU HAVE A MODDED minecraft.jar, HIT CTRL+C NOW.
echo MOD CHOOSER WILL NOT BE SET UP PROPERLY IF YOU HAVE A MODDED minecraft.jar.
echo Refer to forum post for details.
echo.
echo.
echo.
echo The Guided Setup is released under the same license as Minecraft Mod Chooser.
echo.
pause
echo.
echo.
echo.
echo.
echo.
echo Creating directories and failsafe...
cd %appdata%\.minecraft
md jarmodloader
cd jarmodloader
echo start>setup.lck
rem This is in case guidedsetup.bat gets closed midway.
md Mod1
cd Mod1
echo ...done
echo Copying minecraft.jar...
cd %appdata%\.minecraft
xcopy bin\minecraft.jar jarmodloader\Mod1 /Q /Y
echo.
cd jarmodloader
echo getversion>setup.lck
pause
cls
:getversion
echo What is the current version of Minecraft?
set curvers=
set /p curvers=Minecraft Beta v
if '%curvers%'=='' (
  echo.
  goto getversion
)
cd Mod1
echo #This is the name displayed when you start the program. Beginning of line to the pound symbol MUST be 22 characters.>mod.txt
echo Vanilla               >>mod.txt
echo #Minecraft version>>mod.txt
echo Beta v%curvers%>>mod.txt
cd ..
echo.
echo.
echo.
echo.
echo getlocation/exe>setup.lck
set locext=
:getlocation/exe
set isjar=2
set ej=exe
echo Where is Minecraft.exe? (The folder containing it)
echo  __________________________________________
echo [Common Locations:                         ]
echo [ d) Desktop       D) Desktop\....         ]
echo [ m) My Documents  M) My Documents\....    ]
echo [ O) Other         J) I have Minecraft.jar ]
echo [__________________________________________]
echo (Case-sensitive)
echo.
set choice=
set /P choice=Select one [dmDMOJ]:
if '%choice%'=='J' (
  goto getlocation/jar
)
set return=getlocation/exe
goto getlocation/test
:getlocation/jar
set isjar=1
set ej=jar
echo Where is Minecraft.jar? (The folder containing it)
echo  __________________________________________
echo [Common Locations:                         ]
echo [ d) Desktop       D) Desktop\....         ]
echo [ m) My Documents  M) My Documents\....    ]
echo [ O) Other         E) I have Minecraft.exe ]
echo [__________________________________________]
echo (Case-sensitive)
echo.
set choice=
set /P choice=Select one [dmDMOE]:
if '%choice%'=='E' (
  goto getlocation/exe
)
set return=getlocation/jar
:getlocation/test
if '%choice%'=='O' goto getlocation/promptpath
if '%choice%'=='M' (
  set location=%userprofile%\My Documents\
  goto getlocation/promptpath
)
if '%choice%'=='m' (
  set location=%userprofile%\My Documents
  goto getlocation/savepath
)
if '%choice%'=='D' (
  set location=%userprofile%\Desktop\
  goto getlocation/promptpath
)
if '%choice%'=='d' (
  set location=%userprofile%\Desktop
  goto getlocation/savepath
)
echo %choice% is not valid
echo.
goto %return%
:getlocation/promptpath
echo.
echo Enter full path to folder containing Minecraft.%ej%. DO NOT leave a backslash (\) at the end.
echo.
echo If you need to go back, type the following sans quotes: "CANCELCANCELCANCEL".
echo CANCEL is case-sensitive.
echo.
set /P locext=%location%
if '%locext%'=='CANCELCANCELCANCEL' goto getlocation
:getlocation/savepath
set return=
echo #Minecraft.exe (2) or .jar? (1)>options.txt
echo %ej%>>options.txt

echo #Location of Minecraft.exe/jar; do not put quotes and cannot contain #>>options.txt
echo %location%%locext%>>options.txt
echo.
echo Settings saved.
echo.
echo modlocation>setup.lck
pause
cls
:modlocation
set mlocext=
set mlocation=
echo You must specify a location to put mods ready to install.
echo.
echo Please input the location of the folder. If it does not exist, it will be created.
echo This is the folder you extract the .class files (and other "jar stuff") to.
echo  _____________________________________________________
echo [Common Locations:                                    ]
echo [ d) Desktop\modinstall       D) Desktop\....         ]
echo [ m) My Documents\modinstall  M) My Documents\....    ]
echo [ n) My Documents\minecraft\modinstall                ]
echo [ O) Other                                            ]
echo [_____________________________________________________]
echo (Case-sensitive)
echo.
set choice=
set /P choice=Choose [dmnDMO]:
if '%choice%'=='O' goto modlocation/promptpath
if '%choice%'=='D' (
  set mlocation=%userprofile%\Desktop
  goto modlocation/promptpath
)
if '%choice%'=='M' (
  set mlocation=%userprofile%\My Documents
  goto modlocation/promptpath
)
if '%choice%'=='d' (
  set mlocation=%userprofile%\Desktop\modinstall
  goto modlocation/savepath
)
if '%choice%'=='m' (
  set mlocation=%userprofile%\My Documents\modinstall
  goto modlocation/savepath
)
if '%choice%'=='n' (
 set mlocation=%userprofile%\My Documents\minecraft\modinstall
 goto modlocation/savepath
)
echo %choice% is not valid
echo.
goto modlocation
:modlocation/promptpath
echo.
echo Enter the full path to the folder you want to put mods in to install, starting with the drive name. Do not leave a trailing backslash.
echo.
echo If you need to go back and pick something else, type the following sans quotes:"CANCELCANCELCANCEL".
echo.
set /P mlocext=%mlocation%
if '%mlocext%'=='CANCELCANCELCANCEL' goto modlocation
:modlocation/savepath
md "%mlocation%%mlocext%"
md "%mlocation%%mlocext%\..\ModArchive\Mod1"
echo #Location of ready mods (cannot contain # and, as always, no trailing backslash)>>options.txt
echo %mlocation%%mlocext%>>options.txt
echo.
echo Settings saved.
echo.
echo archiver>setup.lck
pause
cls
:archiver
echo Please select one of the following archive managers.
echo.
echo  _____________________
echo [W) WinRAR Registered ]
echo [V) WinRAR Trial      ]
echo [7) 7-Zip             ]
echo [_____________________]
echo.
set choice=
set /P choice=Choose [WV7O]:
if '%choice%'=='V' goto exit/wtrial
if '%choice%'=='W' goto archiver/wrdir
if '%choice%'=='7' goto archiver/7z
echo %choice% is invalid.
echo.
goto archiver
:archiver/wrdir
echo Assuming installation directory is %programfiles%\WinRAR.
set inp=
set /P inp=Is this correct? (Y/N)_
if '%inp%'=='N' goto archiver/wdirprmpt
if '%inp%'=='Y' (
  set archinstall=%programfiles%\Winrar\winrar.exe
  echo #Archival program directory; no trailing backslash>>options.txt
  echo %programfiles%\Winrar>>options.txt
  echo #Archival program name (Only allowed is "WinRAR"; "7Zip">>options.txt
  echo WinRAR>>options.txt
  goto archiver/save
)
goto archiver/wrdirprmpt
:archiver/7z
echo Assuming installation directory is %programfiles%\7-zip.
set inp=
set /P inp=Is this correct? (Y/N)_
if '%inp%'=='N' goto archiver/7dirprmpt
if '%inp%'=='Y' (
  set archinstall=%programfiles%\7-zip\7z.exe
  echo #Archival program directory; no trailing backslash>>options.txt
  echo %programfiles%\7-zip>>options.txt
  echo #Archival program name (Only allowed is "WinRAR"; "7Zip">>options.txt
  echo 7Zip>>options.txt
  goto archiver/save
)
goto archiver/7z
:archiver/wdirprmpt
echo Please input the FULL path to WinRAR installation. (No retries)
set choice=
set /P choice=
if '%choice%'=='' goto archiver/wdirprmpt
set archinstall=%choice%\winrar.exe
echo #Archival program directory; no trailing backslash>>options.txt
echo %choice%>>options.txt
echo #Archival program name (Only allowed is "WinRAR"; "7Zip">>options.txt
echo WinRAR>>options.txt
goto archiver/save
:archiver/7dirprmpt
echo Please input the FULL path to 7-Zip installation. (No retries)
set choice=
set /P choice=
if '%choice%'=='' goto archiver/7dirprmpt
set archinstall=%choice%\7z.exe
echo #Archival program directory; no trailing backslash>>options.txt
echo %choice%>>options.txt
echo #Archival program name (Only allowed is "WinRAR"; "7Zip">>options.txt
echo 7Zip>>options.txt
goto archiver/save
:archiver/save
echo.
echo.
echo Save complete.
echo confirm>setup.lck
pause
cls
:confirm
echo Please confirm that the following settings are correct:
echo.
echo  _____________________________________________________________________________
echo [Minecraft.exe (2) or Minecraft.jar (1)?
echo [   %isjar%
echo [
echo [Minecraft.exe/jar is located at:
echo [   %location%%locext%\Minecraft.%ej%
echo [
echo [All .class files for mods to be installed will be placed in:
echo [   %mlocation%%mlocext%\*.class
echo [
echo [Archival program:
echo [   %archinstall%
echo [_____________________________________________________________________________
echo.
echo.
echo Are ALL of these correct?
set choice=
set /P choice=(Y/N) 
if '%choice%'=='Y' goto exitsuccessful
if '%choice%'=='N' goto exitrestart
echo OH COME ON.
echo YOU'VE MADE IT THIS FAR.
echo DON'T GIVE OUT ON ME NOW^!^!^!^!1^!11^!^!1ONE^!^!ONEONE111^!
pause
goto confirm
:exitsuccessful
echo.&echo.
echo Congratulations! MC Mod Chooser has been successfully set up.
echo.&echo.
echo If anything looking like an error occured during this, then something's probably wrong (duh). Refer to the help.txt that came with this for common mistakes. If it isn't there, either attempt troubleshooting it yourself, or PM me (riking) on the minecraft forums.
del setup.lck
pause
exit /B 205
:exitrestart
echo Okay, Guided Setup will now restart.
echo Restarting Guided Setup.
echo start>setup.lck
pause
exit /B 206
:exit/wtrial
echo Sorry, but WinRAR Trial version is not supported by MC Mod Chooser.
echo.
echo Either get 7-zip (Reccommended) or pay for WinRAR Full.
echo.
echo.
echo Guided Setup will now terminate.
echo.&echo.&echo.&echo.
pause
exit /B 200