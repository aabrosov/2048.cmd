@echo off
setlocal enabledelayedexpansion
title 2048 for cmd
for /f %%a in (score_2048.txt) do set /a bests=0+%%a
:init
set score=0
for %%i in (1 2 3 4) do (
	for %%j in (1 2 3 4) do (
		set a%%i%%j=0
	)
)
call :drop
:main
call :drop
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
echo. [w]  [a]  [s]  [d] or e[x]it or [r]eset
set key=
for /f "delims=" %%a in ('xcopy /w "%~f0" "%~f0" 2^>nul') do if not defined key set key=%%a
set "key=%key:~-1%"
if /i "%key%"=="r" goto :init
if /i "%key%"=="d" (
	for %%i in (1 2 3 4) do call :calc a%%i1 a%%i2 a%%i3 a%%i4
	goto :main
)
if /i "%key%"=="s" (
	for %%i in (1 2 3 4) do call :calc a1%%i a2%%i a3%%i a4%%i
	goto :main
)
if /i "%key%"=="a" (
	for %%i in (1 2 3 4) do call :calc a%%i4 a%%i3 a%%i2 a%%i1
	goto :main
)
if /i "%key%"=="w" (
	for %%i in (1 2 3 4) do call :calc a4%%i a3%%i a2%%i a1%%i
	goto :main
)
if !score! gtr !bests! set bests=!score!
echo !bests!>score_2048.txt
goto :eof

:calc
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
)
goto :eof

:drop
set fcount=0
set fline=
for %%i in (1 2 3 4) do (
	for %%j in (1 2 3 4) do (
		if !a%%i%%j! equ 0 (
			set /a fcount+=1
			set fline=!fline! a%%i%%j
		)
	)
)
if !fcount! lss 1 goto :eof
set cell=2
if !random! geq 29500 set cell=4
set /a rand="!random!*!fcount!/32768+1"
for %%k in (!fline!) do (
	set /a rand-=1
	if !rand! equ 0 set %%k=!cell!
)
goto :eof
