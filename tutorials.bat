echo.
echo Please note that this menu is being worked on. Non-functional items are not marked.
echo  ______________________________________________________________
echo [                      T U T O R I A L S                       ]
echo [                                                              ]
echo [ A) Using MC Mod Chooser       N) Version-specific notes      ]
echo [ B) Installing mods            O) Manual mod installation     ]
echo [ C) Manual Setup instructions  P) Manual Setup: Part 2        ]
echo [ D) What're storage/mod IDs?   Q) Using the updater tool      ]
echo [ E) Installing mods            R) Using Fast Mod Install(nc) ]
echo [ BACK) Return to mod menu      MAIN) Return to main menu      ]
echo [     More tutorials will be added as the need arises.         ]
echo [______________________________________________________________]
echo.
set inp=
set /P inp=Pick one (Case sensitive):
if '%inp%'=='BACK' goto input2
if '%inp%'=='MAIN' goto input
echo %inp%|findstr /r /c:"^[A-D,N-P]$" >nul
if errorlevel 1 (
	echo That is not a defined tutorial.
	goto input3
)
goto tutorials/%inp%
:tutorials/A
echo This is "Using MC Mod Chooser" tutorial.
echo.
echo TUTORIAL NOT MADE
pause
goto input3
:tutorials/N
echo This is "Version-specific notes" tutorial.
echo.
echo TUTORIAL NOT MADE
pause
goto input3
:tutorials/B
echo This is "Installing mods" tutorial.
echo.
echo TUTORIAL NOT MADE
pause
goto input3
:tutorials/O
echo This is "Manual mod installation" tutorial.
echo.
echo TUTORIAL NOT MADE
pause
goto input3
:tutorials/C
echo This is "Manual Setup instructions" tutorial.
echo It is important that you follow ALL instructions in this.
echo.
pause
echo.
echo Step 1) Make a folder in ^%appdata^%\.minecraft called "jarmodloader".
echo.
echo Press a key when you have done that.
pause
echo.
echo Step 2) Make another new folder and name it "Mod1".
echo Step 3) If you have a modded minecraft.jar, copy it to a temporary directory and delete the "version" file in ".minecraft\bin".
echo Step 4) Copy the vanilla (unmodded) minecraft.jar from your bin folder (^%appdata^%\.minecraft\bin) into the Mod1 folder.
echo.
echo Press a key when you have completed those two steps.
pause
echo.
echo Step 5) Make a new text (.txt) document in the Mod1 folder. Open it in Notepad or another text editor.
echo Step 6) On the first line, enter "Vanilla               " (22 characters).
echo Step 7) On the second line, enter "#" (indicates comment) followed by a note saying that the first line must be 22 characters.
echo Step 8) On the third line, enter the Minecraft version. (Ex: Alpha v1.2.6 or Beta v1.1_01)
echo Step 9) On the fourth line, enter "#Minecraft version".
echo Step 10) Save the file.
echo.
pause
echo Step 11) Make a new text document named options.txt in the jarmodloader folder.
echo Step 12) Format:
echo 
echo.
echo MC Mod Chooser is NOT set up.
echo If you performed step 3, select the Manual Setup: Part 2 tutorial.
echo 
goto input3
:tutorials/P
echo This is "Manual Setup Part 2" tutorial.
goto input3
:tutorials/D
echo This is "What is storage/mod IDs?" tutorial.
goto input3
:tutorials/Q
echo This is "Using the updater tool" tutorial.
goto input3
:tutorials/E
echo This is "Installing mods" tutorial.
goto input3
:tutorials/R
echo This is "Fast Mod Install" tutorial.
goto input3