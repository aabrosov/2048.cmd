@echo off
setlocal enabledelayedexpansion
title 2048 for cmd
if not exist score_2048.txt echo 0>score_2048.txt
for /f %%a in (score_2048.txt) do set bests=%%a
set /a tests=bests*2
if !bests! neq !tests! set /a bests=tests/2
:init
set score=0
for %%i in (1 2 3 4) do (
	for %%j in (1 2 3 4) do (
		set a%%i%%j=f
	)
)
:main
call :drop
call :drop
cls
if !score! gtr !bests! set bests=!score!
for %%i in (1 2 3 4) do (
	set line=
	for %%j in (1 2 3 4) do (
		set tmp=0x!a%%i%%j!
		set /a tmp="2 << tmp"
		if !tmp! equ 65536 set tmp=0
		set tmp=    !tmp!
		set line=!line!³!tmp:~-5!³
	)
	echo ÚÄÄÄÄÄ¿ÚÄÄÄÄÄ¿ÚÄÄÄÄÄ¿ÚÄÄÄÄÄ¿
	echo !line!
	echo ÀÄÄÄÄÄÙÀÄÄÄÄÄÙÀÄÄÄÄÄÙÀÄÄÄÄÄÙ
)
echo score = !score!
echo bests = !bests!
echo.
choice /c xwasdr /n /m " [w]  [a]  [s]  [d] or e[x]it or [r]eset"
if errorlevel 6 goto :init
if errorlevel 5 (
	for %%i in (1 2 3 4) do call :calc a%%i1 a%%i2 a%%i3 a%%i4
	goto :main
)
if errorlevel 4 (
	for %%i in (1 2 3 4) do call :calc a1%%i a2%%i a3%%i a4%%i
	goto :main
)
if errorlevel 3 (
	for %%i in (1 2 3 4) do call :calc a%%i4 a%%i3 a%%i2 a%%i1
	goto :main
)
if errorlevel 2 (
	for %%i in (1 2 3 4) do call :calc a4%%i a3%%i a2%%i a1%%i
	goto :main
)
if !score! gtr !bests! set bests=!score!
echo !bests!>score_2048.txt
goto :eof
:calc
set inl=
if !%4! neq f set inl=!inl! !%4!
if !%3! neq f set inl=!inl! !%3!
if !%2! neq f set inl=!inl! !%2!
if !%1! neq f set inl=!inl! !%1!
set out=
set buf=
for %%a in (!inl!) do (
	if "%%a" equ "!buf!" (
		if %%a equ e (echo "wtf you already won"&pause&exit)
		if %%a equ d (set buf=e&set /a score+=32768)
		if %%a equ c (set buf=d&set /a score+=16384)
		if %%a equ b (set buf=c&set /a score+=8192)
		if %%a equ a (set buf=b&set /a score+=4096)
		if %%a equ 9 (set buf=a&set /a score+=2048)
		if %%a equ 8 (set buf=9&set /a "score+=2<<buf")
		if %%a equ 7 (set buf=8&set /a "score+=2<<buf")
		if %%a equ 6 (set buf=7&set /a "score+=2<<buf")
		if %%a equ 5 (set buf=6&set /a "score+=2<<buf")
		if %%a equ 4 (set buf=5&set /a "score+=2<<buf")
		if %%a equ 3 (set buf=4&set /a "score+=2<<buf")
		if %%a equ 2 (set buf=3&set /a "score+=2<<buf")
		if %%a equ 1 (set buf=2&set /a "score+=2<<buf")
		if %%a equ 0 (set buf=1&set /a "score+=2<<buf")
		set out=!buf!!out!
		set buf=
	) else (
		set out=!buf!!out!
		set buf=%%a
	)
)
set out=ffff!buf!!out!
set out=!out:~-4!
set %1=!out:~0,1!
set %2=!out:~1,1!
set %3=!out:~2,1!
set %4=!out:~3,1!
goto :eof
:drop
set fcount=0
set fline=
for %%i in (1 2 3 4) do (
	for %%j in (1 2 3 4) do (
		if !a%%i%%j! equ f (
			set /a fcount=fcount+1
			set fline=!fline! a%%i%%j
		)
	)
)
if !fcount! lss 1 goto :eof
set cell=0
if !random! geq 29500 set cell=1
set /a rand="!random!*!fcount!/32768+1"
for %%k in (!fline!) do (
	set /a rand=rand-1
	if !rand! equ 0 set %%k=!cell!
)
goto :eof
