@echo off

rem =====
rem For more information on ScriptTiger and more ScriptTiger scripts visit the following URL:
rem https://scripttiger.github.io/
rem Or visit the following URL for the latest information on this ScriptTiger script:
rem https://github.com/ScriptTiger/LuaJIT-For-Windows
rem =====

rem Write lj4w.config if does not exist
if not exist "%APPDATA%\LJ4W" md "%APPDATA%\LJ4W"
if not exist "%APPDATA%\LJ4W\lj4w.txt" (
	(
		echo default.all.interpreter=lj4w
		echo default.lua.interpreter=lua
		echo default.luajit.interpreter=lj4w
		echo lj4w.interpreter=^"%~0^"
	) > "%APPDATA%\LJ4W\lj4w.txt"
)

rem If the LJ4W_INTERPRETER_PATH environmental variable is already set, launch directly
if not "%LJ4W_INTERPRETER_PATH%" =="" goto launch

rem If the LJ4W_INTERPRETER environmental variable is already set, find interpreter path and launch
if not "%LJ4W_INTERPRETER%" =="" goto launch_comment_header

rem If no arguments/file given, open lj4w command prompt
if "%1"=="" goto lj4w

rem If argument given is not a file, pass to default interpreter
if not exist "%~1" goto default.all.interpreter

rem Read file header
set /p LJ4W_INTERPRETER=<%1

:bytecode_headers
if not "%LJ4W_INTERPRETER:~,1%"=="" (
	goto comment_headers
)
if "%LJ4W_INTERPRETER:~,3%"=="LJ" (
	goto default.luajit.interpreter
)
if "%LJ4W_INTERPRETER:~,4%"=="Lua" (
	goto default.lua.interpreter
)

:comment_headers
rem If header is not a comment, launch default interpreter
if /i not "%LJ4W_INTERPRETER:~,2%"=="--" (
	set LJ4W_INTERPRETER=
	goto default.all.interpreter
)
rem If header comment is not interpreter parameter, launcher default interpreter
if /i not "%LJ4W_INTERPRETER:~,15%"=="--interpreter: " (
	set LJ4W_INTERPRETER=
	goto default.all.interpreter
)
rem Clean up interpreter name
set LJ4W_INTERPRETER=%LJ4W_INTERPRETER:~15%
:launch_comment_header
rem Check if the header is valid, report error and exit if not
findstr /b /i %LJ4W_INTERPRETER%.interpreter "%APPDATA%\LJ4W\lj4w.txt" > nul || (
	echo No "%LJ4W_INTERPRETER%" interpreter configured!
	exit /b
)
rem Look up path for requested interpreter
for /f "tokens=2 delims==" %%0 in ('findstr /b /i %LJ4W_INTERPRETER%.interpreter "%APPDATA%\LJ4W\lj4w.txt"') do (
	set LJ4W_INTERPRETER_PATH=%%~0
	goto launch
)

:default.all.interpreter
rem Look up path for default interpreter and launch
for /f "tokens=2 delims==" %%0 in ('findstr /b /i default.all.interpreter "%APPDATA%\LJ4W\lj4w.txt"') do (
	findstr /b /i %%0.interpreter "%APPDATA%\LJ4W\lj4w.txt" > nul || (
		echo The "default.all.interpreter" is misconfigured!
		exit /b
	)
	for /f "tokens=2 delims==" %%a in ('findstr /b /i %%0.interpreter "%APPDATA%\LJ4W\lj4w.txt"') do (
		set LJ4W_INTERPRETER=%%0
		set LJ4W_INTERPRETER_PATH=%%~a
		goto launch
	)
)

:default.luajit.interpreter
rem Look up path for default LuaJIT interpreter and launch
for /f "tokens=2 delims==" %%0 in ('findstr /b /i default.luajit.interpreter "%APPDATA%\LJ4W\lj4w.txt"') do (
	findstr /b /i %%0.interpreter "%APPDATA%\LJ4W\lj4w.txt" > nul || (
		echo The "default.luajit.interpreter" is misconfigured!
		exit /b
	)
	for /f "tokens=2 delims==" %%a in ('findstr /b /i %%0.interpreter "%APPDATA%\LJ4W\lj4w.txt"') do (
		set LJ4W_INTERPRETER=%%0
		set LJ4W_INTERPRETER_PATH=%%~a
		goto launch
	)
)

:default.lua.interpreter
rem Look up path for default Lua interpreter and launch
for /f "tokens=2 delims==" %%0 in ('findstr /b /i default.lua.interpreter "%APPDATA%\LJ4W\lj4w.txt"') do (
	findstr /b /i %%0.interpreter "%APPDATA%\LJ4W\lj4w.txt" > nul || (
		echo The "default.lua.interpreter" is misconfigured!
		exit /b
	)
	for /f "tokens=2 delims==" %%a in ('findstr /b /i %%0.interpreter "%APPDATA%\LJ4W\lj4w.txt"') do (
		set LJ4W_INTERPRETER=%%0
		set LJ4W_INTERPRETER_PATH=%%~a
		goto launch
	)
)

:launch
rem Launch appropriate lua implementation
if exist "%LJ4W_INTERPRETER_PATH%" (
	if /i "%LJ4W_MIXED%"=="true" call :clean_mixed
	if /i "%LJ4W_INTERPRETER_PATH%"=="%~0" goto lj4w
	title %LJ4W_INTERPRETER_PATH%
	call "%LJ4W_INTERPRETER_PATH%" %*
	exit /b
)
rem Report error if requested lua implementation is not configured properly
echo "%LJ4W_INTERPRETER%" cannot be found at "%LJ4W_INTERPRETER_PATH%"!
if /i "%LJ4W_MIXED%"=="true" call :clean_mixed
exit /b

:clean_mixed
set LJ4W_INTERPRETER=
set LJ4W_INTERPRETER_PATH=
exit /b

:lj4w
rem Set window title
title LuaJIT For Windows

rem Set base LuaJIT directory (LUADIR)
set LUADIR=%~dp0
set LUADIR=%LUADIR:~,-1%

rem Set paths
set PATH=%LUADIR%\tools\cmd;%LUADIR%\tools\PortableGit\mingw64\bin;%LUADIR%\tools\PortableGit\usr\bin;%LUADIR%\tools\mingw\bin;%LUADIR%\lib;%LUADIR%\bin;%APPDATA%\LJ4W\LuaRocks\bin;%PATH%
set LUA_PATH=%LUADIR%\lua\?.lua;%LUADIR%\lua\?\init.lua;%APPDATA%\LJ4W\LuaRocks\share\lua\5.1\?.lua;%APPDATA%\LJ4W\LuaRocks\share\lua\5.1\?\init.lua;%LUA_PATH%
set LUA_CPATH=%APPDATA%\LJ4W\LuaRocks\lib\lua\5.1\?.dll;%LUA_CPATH%

rem If arguments are being sent, pass to LuaJIT and exit
if not "%1"=="" (
	call "%LUADIR%\bin\luajit.exe" %*
	exit /b
)

rem Prepare command prompt environment
set APPDATA=%APPDATA%\LJ4W
if not exist "%APPDATA%\LuaRocks" md "%APPDATA%\LuaRocks"
if not exist "%APPDATA%\LuaRocks\default-lua-version.lua" echo return "5.1">"%APPDATA%\LuaRocks\default-lua-version.lua"
if not exist "%APPDATA%\LuaRocks\config-5.1.lua" call luarocks config > "%APPDATA%\LuaRocks\config-5.1.lua"

rem Command prompt
echo ***** LuaJIT For Windows *****
for /f "tokens=*" %%0 in ('call luajit -v^&call luarocks --version ^| grep -v main^&call gcc --version ^| grep clang') do echo %%0
echo.
cmd /k