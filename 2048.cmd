@echo off
setlocal enabledelayedexpansion
title 2048 for cmd
for /f %%a in (score_2048.txt) do set /a bests=0+%%a

:init
set try=
set changed=
set score=0
for %%i in (1 2 3 4) do for %%j in (1 2 3 4) do set a%%i%%j=0

call :drop

:main

if not defined freecell goto :exit

if not defined try call :drop


call :draw

set changed=
:getkey
if !try! gtr 10 goto :badtry
set key=
for /f "delims=" %%a in ('xcopy /w "%~f0" "%~f0" 2^>nul') do if not defined key set key=%%a
set "key=%key:~-1%"
set "quot=%key:"=%"
if not defined quot goto :getkey
if /i "%key%"=="r" goto :init
if /i "%key%"=="d" goto :right
if /i "%key%"=="l" goto :right
if /i "%key%"=="6" goto :right
if /i "%key%"=="s" goto :down
if /i "%key%"=="k" goto :down
if /i "%key%"=="2" goto :down
if /i "%key%"=="a" goto :left
if /i "%key%"=="j" goto :left
if /i "%key%"=="4" goto :left
if /i "%key%"=="w" goto :up
if /i "%key%"=="i" goto :up
if /i "%key%"=="8" goto :up
if /i "%key%"=="x" goto :exit
if /i "%key%"=="q" goto :exit
goto :getkey

:up
for %%i in (1 2 3 4) do call :calc a4%%i a3%%i a2%%i a1%%i
if not defined changed (
	set /a try+=1
	goto :getkey
) else (
	set try=
	goto :main
)


:down
for %%i in (1 2 3 4) do call :calc a1%%i a2%%i a3%%i a4%%i
if not defined changed (
	set /a try+=1
	goto :getkey
) else (
	set try=
	goto :main
)

:left
for %%i in (1 2 3 4) do call :calc a%%i4 a%%i3 a%%i2 a%%i1
if not defined changed (
	set /a try+=1
	goto :getkey
) else (
	set try=
	goto :main
)

:right
for %%i in (1 2 3 4) do call :calc a%%i1 a%%i2 a%%i3 a%%i4
if not defined changed (
	set /a try+=1
	goto :getkey
) else (
	set try=
	goto :main
)

:badtry
echo.so many bad tries
set try=
:exit
echo.are you want to exit? [y/n]
set key=
for /f "delims=" %%a in ('xcopy /w "%~f0" "%~f0" 2^>nul') do if not defined key set key=%%a
set "key=%key:~-1%"
if /i "%key%" neq "y" goto :main
if !score! gtr !bests! set bests=!score!
echo !bests!>score_2048.txt
exit
goto :eof

:calc
set before=!%1!,!%2!,!%3!,!%4!
set inl=
if !%4! neq 0 set inl=!inl! !%4!
if !%3! neq 0 set inl=!inl! !%3!
if !%2! neq 0 set inl=!inl! !%2!
if !%1! neq 0 set inl=!inl! !%1!
set out=
set buf=
for %%a in (!inl!) do (
	set cur=%%a
	if "!cur!" equ "!buf!" (
		if !cur! equ 65536 (echo.triumph&pause&exit)
		set /a buf*=2
		set /a score+=buf
		set cur=
	)
	set out=!out! !buf!
	set buf=!cur!
)
set out=!out! !buf! 0 0 0 0
for /f "tokens=1,2,3,4" %%b in ("!out!") do (
	set %4=%%b
	set %3=%%c
	set %2=%%d
	set %1=%%e
	set after=%%e,%%d,%%c,%%b
)
rem echo "!before!"=="!after!"
if not "!before!"=="!after!" set changed=yes
goto :eof

:drop
set freecell=
set freelist=
for %%i in (1 2 3 4) do (
	for %%j in (1 2 3 4) do (
		if !a%%i%%j! equ 0 (
			set /a freecell+=1
			set freelist=!freelist! a%%i%%j
		)
	)
)
if defined freelist (
	set cell=2
	if !random! geq 29500 set cell=4
	set /a rand=!random!*!freecell!/32768+1
	for %%k in (!freelist!) do (
		set /a rand-=1
		if !rand! equ 0 set %%k=!cell!
	)
)
goto :eof

:draw
cls
if !score! gtr !bests! set bests=!score!
for %%i in (1 2 3 4) do (
	set line=
	for %%j in (1 2 3 4) do (
		set tmp=    !a%%i%%j!
		if !tmp! equ 0 set "tmp=     "
		set line=!line!³!tmp:~-5!³
	)
	echo ÚÄÄÄÄÄ¿ÚÄÄÄÄÄ¿ÚÄÄÄÄÄ¿ÚÄÄÄÄÄ¿
	echo !line!
	echo ÀÄÄÄÄÄÙÀÄÄÄÄÄÙÀÄÄÄÄÄÙÀÄÄÄÄÄÙ
)
echo score = !score!
echo bests = !bests!
echo.
rem choice /c xwasdr /n /m " [w]  [a]  [s]  [d] or e[x]it or [r]eset"
echo. control:  [w^|i^|8]  [a^|j^|4]  [s^|k^|2]  [d^|l^|6]
echo.          or e[x]it or [q]uit or [r]eset
goto :eof

