@echo off
color 0a
SETLOCAL ENABLEEXTENSIONS
if errorlevel 1 echo this shouldnt happen
SETLOCAL ENABLEDELAYEDEXPANSION
if errorlevel 1 echo this shouldnt happen
set execdir=%0
::you have to change more than the two numbers below to change number of mod slots
set modmin=1
set modmax=9
echo temp > C:\uactest.txt
if errorlevel 1 (
	echo It appears you aren't running this as an administrator.
	echo Please run this with elevated privlidges.
	exit /B 2
)
del C:\uactest.txt
if exist %1 goto fastmodinstall
	:start
cd "%appdata%\.minecraft"
echo ============Welcome to Minecraft Mod Chooser============
echo.
echo Version 1.4 UNSTABLE
echo build number %random%
echo.
echo.
echo Bug reports go to riking28@gmail.com
echo.
echo.
echo.
echo This program is released under a Creative Commons "CC0" License.
echo.
echo.
pause
if not exist jarmodloader (
	echo.
	echo.
	echo.
	echo It appears this is your first time running the program.
	set section=
	echo Starting Guided Setup.
	goto firstrun
)
cd jarmodloader
if exist setup.lck (
	echo.
	echo.
	echo.
	echo It appears that Guided Setup was cancelled last time you ran it.
	echo MC Mod chooser will now resume Guided Setup.
	for /F "delims=" %%i in (setup.lck) do set section=%%i
	goto firstrun
)  
goto loadsettings
	:firstrun
cd "%execdir%"
pause
call guidedsetup.bat %section%
::guidedsetup.bat, on a successful run, sets errorlevel to 205.
::on error 206, you wanted to restart it.
::on error 200, you have winrar trial. shame.
if %errorlevel% EQU 205 (
	cls
	color 0a
	::restore color
	echo Success! Guided Setup has executed correctly. You can now use the program.
	cd "%appdata%\.minecraft\jarmodloader"
	goto loadsettings
) else (
	::restart
	if %errorlevel% EQU 206 (
		cls
		color 0a
		echo Guided Setup has indicated that it requires a restart.
		set section=start
		goto firstrun
	)
	if %errorlevel% EQU 200 exit /B 200
	::
	if errorlevel 1 (
		color 0a
		echo.
		echo It appears Guided Setup had an abnormal exit.
		echo Please see above for any details available, and possibly file a bug report.
		echo.
		echo If the problem persists, try deleting the %appdata%\.minecraft\jarmodloader folder and retrying.
		echo.
		set inp=
		set /P inp=An alternative is Manual Setup. To view instructions for this, type 1 and hit enter. If you want to try Guided Setup again, just hit enter.
		if '%inp%'=='1' goto tutorials/c2
		echo.
		echo To rerun Guided Setup, run MCModChooser.bat again.
		echo Thank you for using this program, and we are sorry you are having problems.
		echo.
		echo.
		echo MC Mod Chooser will now terminate.
		echo.
		pause
		exit /B 2
)
	:loadsettings
echo loading settings...
cd "%appdata%\.minecraft\jarmodloader"
set num=0
for /F "eol=# delims=" %%i in (options.txt) do (
	set /A num=!num!+1
	set s!num!=%%i
)
set ej=%s1%
set mcpath=%s2%
set modpath=%s3%
set arcpath=%s4%
set arcname=%s5%
set uspoof=%s6%
if '%arcname%'=='WinRAR' (
	set arcmd=rar
)
if '%arcname%'=='7Zip' (
	set arcmd=7z
)
if '%uspoof%'=='' set uspoof=OFF
echo settings loaded.
	:loadnames
echo loading mods...
::set Mod#Name=
::set Mod#Vers=
for /L %%n in (%modmin%,1,%modmax%) do (
	if exist Mod%%n (
		cd Mod%%n
		set switch=y
		for /F "eol=# delims=" %%i in (mod.txt) do (
			if '!switch!'=='y' (
				set Mod%%nName=%%i
			) else (
				set Mod%%nVers=%%i
			)
			set switch=n
		)
		cd ..
		echo Mod%%n loaded.
	) else (
		echo Mod%%n does not exist.
		set Mod%%nName=NONEXISTENT
		set Mod%%nVers=
	)
)
echo names loaded
	:input
echo.
set return=
::NAME LENGTH: 22
echo (User spoof is: %uspoof%)
echo  ________________________________
echo [  Select a number %modmin%-%modmax% to load.  ]
echo [1  %Mod1Name%       ] %Mod1Vers%
echo [2  %Mod2Name%       ] %Mod2Vers%
echo [3  %Mod3Name%       ] %Mod3Vers%
echo [4  %Mod4Name%       ] %Mod4Vers%
echo [5  %Mod5Name%       ] %Mod5Vers%
echo [6  %Mod6Name%       ] %Mod6Vers%
echo [7  %Mod7Name%       ] %Mod7Vers%
echo [8  %Mod8Name%       ] %Mod8Vers%
echo [9  %Mod9Name%       ] %Mod9Vers%
echo [                                ]
echo [        Other Tasks             ]
echo [R  Refresh mods                 ]
echo [F  Open Mod folder              ]
echo [C  Change mods; Tutorials       ]
echo [U  Spoof username               ]
echo [E  Exit                         ]
echo [________________________________]
echo.
set minp=
set /P minp=Select one:
if '%minp%'=='R' goto loadsettings
echo %minp%|findstr /r /c:"^[%modmin%-%modmax%,E,C,F,M,U]$" >nul
::takes input, looks for (start of string) (number) (end of string). if not, causes errorlevel 1.
if errorlevel 1 (
	echo That is an invalid input. (You put '%minp%'^)
	pause
	goto input
)
if '%minp%'=='E' ( exit /B 0 )
if '%minp%'=='C' ( goto input2 )
if '%minp%'=='F' (
	start explorer.exe %appdata%\.minecraft\jarmodloader
	goto input
)
if '%minp%'=='U' (
	goto spoofuser
)
goto loadworld
::input must be a number 1-9 by now
	:input2
echo.
echo  _________________________________________
echo [          Changing Your Mods             ]
echo [Pick either number OR letter.            ]
echo [                                         ]
echo [1T  Tutorials                            ]
echo [2A  Add new files to an existing mod     ]
echo [3I  Delete the META-INF folder           ]
echo [4R  Rename an existing mod               ]
echo [5M  Move an existing mod to a new slot   ]
echo [     or into/out of storage              ]
echo [6C  Copy an existing mod                 ]
echo [7D  Delete a mod                         ]
echo [8V  View all mods (inc. storage)         ]
echo [9U  Updater Tool                         ]
echo [0E  Return to Main Menu                  ]
echo [_________________________________________]
echo.
set inp=
set /P inp=Select one:
echo %inp%|findstr /r /c:"^[0-9,A,C-E,M,R,T-V,a,c,e,m,r,t,v]$" >nul
if errorlevel 1 (
	echo Invalid input.
	pause
	goto input2
)
echo.
goto input2/%inp%
:input2/0
:input2/E
goto loadsettings
:input2/1
:input2/T
echo This feature is under development.
pause
goto input2
::goto input3
:input2/2
:input2/A
echo This feature has been disabled due to it not working.
pause
goto input2
::goto addmods
:input2/3
:input2/I
echo This feature has been disabled due to it not working.
pause
goto input2
::goto metainf
:input2/4
:input2/R
echo This feature has been disabled due to it not working.
pause
goto input2
::goto renamer
:input2/5
:input2/M
goto mover
:input2/6
:input2/C
goto copy
:input2/7
:input2/D
goto delete
:input2/8
:input2/V
goto viewer
:input2/9
:input2/U
echo This feature has been disabled due to it not working.
pause
goto input2

	:loadworld
echo Loading Mod%minp%...
cd ..
xcopy /y jarmodloader\Mod%minp%\minecraft.jar bin\minecraft.jar
cd jarmodloader
echo Done.
echo.
set return=loadworld/return
goto runMC
:loadworld/return
exit
	:spoofuser
echo Please pick a username to use as the spoof.
set inp=
set /P inp=Username:
if '%inp%'=='' (
	echo Operation cancelled.
	goto input
)
set uspoof=%inp%
goto input
	:copy
echo Please enter the ID of the mod you want to copy from. (Mod# or a storage location)
set from=
set /P from=
echo.
if '%from%'=='' (
	echo Operation cancelled.
	goto input
)
if not exist "%from%" (
	echo That is an invalid entry.
	echo.
	goto copy
)
:copy/inp2
echo Enter the ID of the mod you want to copy to. (Mod# or a storage location)
set dest=
set /P dest=
echo.
if '%dest%'=='' (
	echo Operation cancelled.
	goto input
)
if exist "%dest%" (
	echo That already exists!
	goto copy/inp2
)
xcopy "%from%" "%dest%" /I /Y
cd %modpath%\..\ModArchive
xcopy "%from%" "%dest%" /I /Y

cd %appdata%\.minecraft\jarmodloader
echo.
echo Task completed.
echo.
set dest=
set from=
goto input2
	:mover
echo Please enter the ID of the mod you want to move. (Mod# or a storage location)
set from=
set /P from=
echo.
if '%from%'=='' (
	echo Operation cancelled.
	goto input
)
if not exist "%from%" (
	echo That is an invalid entry.
	echo.
	goto mover
)
:mover/inp2
echo Enter the new ID of the mod.
set dest=
set /P dest=
echo.
if '%dest%'=='' (
	echo Operation cancelled.
	goto input
)
if exist "%dest%" (
	echo That already exists!
	goto mover/inp2
)
move "%from%" "%dest%"
cd %modpath%\..\ModArchive
move "%from%" "%dest%">tmp.tmp
erase tmp.tmp
cd %appdata%\.minecraft\jarmodloader
echo.
echo Task completed.
echo.
set dest=
set from=
goto input2
	:delete
echo Please enter the ID of the mod or storage location you would like to delete. You will also get a confirmation prompt.
set inp=
set /P inp=
echo.
if '%inp%'=='' (
	echo Operation cancelled.
	goto input
)
if not exist "%inp%" goto delete
erase /F %inp%
rd %inp%
cd %modpath%\..\ModArchive
erase /F %inp%\*
rd %inp%
cd %appdata%\.minecraft\jarmodloader
echo.
echo Task completed.
echo.
goto input2
	:renamer
echo Enter the ID of the mod you want to rename.
set inp=
set /P inp=
echo.
if '%inp%'=='' (
	echo Operation cancelled.
	goto input
)
if not exist "%inp%" (
	echo That mod does not exist.
	goto renamer
)
cd %inp%
start mod.txt
cd ..
pause
goto input2
	:viewer
dir /A:D /B /O:N /P
pause
echo.
echo Task completed.
echo.
goto input2
	:addmods
set inp=
set /P inp=(Y/N) Are the mod files prepared?
echo.
if '%inp%'=='Y' goto addmods/cont
if '%inp%'=='' (
	echo Operation cancelled.
	goto input
)
echo Press any key when the mod files are prepared in the %modpath% folder.
pause
goto addmods
:addmods/cont
echo.
echo Enter the mod ID of the mod to install to.
set dest=
set /P dest=
echo.
if '%dest%'=='' (
	echo Operation cancelled.
	goto input
)
if not exist "%dest%" (
	echo That mod does not exist!
	goto addmods/cont
)
set return=input2
:addmods/install
cd %arcpath%
start /WAIT %arcmd%.exe a -tzip "%appdata%\jarmodloader\%dest%\minecraft.jar" "%modpath%\*"
if errorlevel 1 (
	echo Errors occurred. Please report this incident.
	pause
	goto input2
)
cd %modpath%
copy * ..\ModArchive\%dest%
echo.
goto input
	:metainf
echo.
echo Enter the mod ID of the mod to delete the META-INF folder of.
set inp=
set /P inp=
echo.
if '%inp%'=='' (
	echo Operation cancelled.
	goto input
)
if not exist "%inp%" (
	echo That mod does not exist!
	goto addmods/cont
)
echo on
start "" /B /D"%arcpath%" /HIGH /WAIT %arcmd% d -tzip "%cd%\%inp%\minecraft.jar" META-INF
echo off
if errorlevel 1 (
	echo Errors occurred. Please report this incident.
	pause
)
goto input2
	:fastmodinstall
echo.
echo.
echo You have reached Fast Mod Install.
echo.
echo If you dragged the archive file onto MC Mod Chooser, it is possible that it will not work.
echo Be prepared to restore from a backup if you are not sure.
echo.
echo TO CONTINUE PRESS ENTER. To run MC Mod Chooser normally, type anything and hit enter.
set inp=
set /P inp=
if '%inp%'=='' goto fastmodinstall/cont1
goto start
:fastmodinstall/cont1
cd %appdata%\.minecraft\jarmodloader
:fastmodinstall/cont
echo.
echo Please enter the ID of the mod in which to install the mod.
set inp=
set /P inp=
echo.
if '%inp%'=='' (
	goto fastmodinstall/cont
)
if not exist %inp% (
	echo That mod does not exist!
	goto fastmodinstall/cont
)
set dest=%inp%
:fastmodinstall/loop
copy %1 %modloc%
echo File %1 processed.
shift
if not defined %1 (
	set return=start
	goto addmods/install
)
goto fastmodinstall/loop
	:runMC
echo Starting Minecraft...
if '%uspoof%'=='OFF' (
	echo.
) else (
	goto runMC/spoof
)
if %ej% EQU 2 (
	start "" /MAX /D"%mcpath%" Minecraft.exe
) else (
	cmd /K "start /D:"%mcpath%" C:\WINDOWS\system32\java.exe -Xmx1024M -Xms256M -cp "%mcpath%\Minecraft.jar" net.minecraft.LauncherFrame && pause"
)
exit
	:runMC/spoof
color 08
cls
java -Xincgc -Xmx1024m -cp "%APPDATA%\.minecraft\bin\minecraft.jar;%APPDATA%\.minecraft\bin\lwjgl.jar;%APPDATA%\.minecraft\bin\lwjgl_util.jar;%APPDATA%\.minecraft\bin\jinput.jar" -Djava.library.path="%APPDATA%\.minecraft\bin\natives" net.minecraft.client.Minecraft %uspoof% 123455
exit
	:update
echo Please enter the new version number below.
set newvers=
set /P newvers=Minecraft Beta v
set newvers=v%newvers%
echo.
if '%inp%'=='' (
	echo Operation cancelled.
	goto input
)
echo.
:update/inp2
echo Attempting to retrieve new minecraft.jar.
cd %execdir%
URL2File "http://s3.amazonaws.com/MinecraftDownload/minecraft.jar" minecraft.jar
if errorlevel 1 (
	echo An error occured retrieving the file; terminating update.
	pause
	goto input
)
move minecraft.jar C:\minecraft.jar
	:eof
echo Exiting.
pause