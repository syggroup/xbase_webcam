@ECHO OFF
CLS
ECHO ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
ECHO ³ FiveWin for xHarbour 19.05 - May. 2019          xHarbour development power ³Ü
ECHO ³ (c) FiveTech 1993-2019 for Microsoft Windows 9X/NT/200X/ME/XP/Vista/7/8/10 ³Û
ECHO ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
ECHO ÿ ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

if A%1 == A GOTO :SINTAX
if NOT EXIST %1.prg GOTO :NOEXIST

ECHO Compiling...

if "%FWDIR%" == "" set FWDIR=d:\devel\fivewin\fwh1905
if "%XHDIR%" == "" set XHDIR=d:\devel\xharbour_bcc7
rem if "%2" == "/b" set GT=gtwin
rem if not "%2" == "/b" set GT=gtgui
set GT=gtgui

set hdir=%XHDIR%
set hdirl=%hdir%\lib
set bcdir=d:\devel\bcc72
set fwh=%FWDIR%

%hdir%\bin\harbour %1 /n /i%fwh%\include;%hdir%\include /w /p %2 %3 > comp.log 2> warnings.log
IF ERRORLEVEL 1 GOTO COMPILEERRORS
@type comp.log
@type warnings.log

echo -O2 -e%1.exe -I%hdir%\include -I%bcdir%\include %1.c > b32.bc
%bcdir%\bin\bcc32 -M -c -v @b32.bc
:ENDCOMPILE

IF EXIST %1.rc %bcdir%\bin\brc32.exe -r -I%bcdir%\include -I%bcdir%\include\windows\sdk %1

echo %bcdir%\lib\c0w32.obj + > b32.bc
echo %1.obj, + >> b32.bc
echo %1.exe, + >> b32.bc
echo %1.map, + >> b32.bc
echo %fwh%\lib\Fivehx.lib %fwh%\lib\FiveHC.lib %fwh%\lib\libmysql.lib + >> b32.bc
echo %fwh%\lib\pgsql.lib %fwh%\lib\libpq.lib + >> b32.bc
echo %hdirl%\rtl.lib + >> b32.bc
echo %hdirl%\vm.lib + >> b32.bc
echo %hdirl%\%GT%.lib + >> b32.bc
echo %hdirl%\lang.lib + >> b32.bc
echo %hdirl%\macro.lib + >> b32.bc
echo %hdirl%\rdd.lib + >> b32.bc
echo %hdirl%\dbfntx.lib + >> b32.bc
echo %hdirl%\dbfcdx.lib + >> b32.bc
echo %hdirl%\dbffpt.lib + >> b32.bc
echo %hdirl%\hbsix.lib + >> b32.bc
echo %hdirl%\debug.lib + >> b32.bc
echo %hdirl%\common.lib + >> b32.bc
echo %hdirl%\codepage.lib + >> b32.bc
echo %hdirl%\pp.lib + >> b32.bc
echo %hdirl%\pcrepos.lib + >> b32.bc
echo %hdirl%\ct.lib + >> b32.bc
echo %hdirl%\zlib.lib + >> b32.bc
echo %hdirl%\hbzip.lib + >> b32.bc
echo %hdirl%\libmisc.lib + >> b32.bc
echo %hdirl%\tip.lib + >> b32.bc
rem echo %hdirl%\hbzebra.lib + >> b32.bc
rem echo %hdirl%\png.lib + >> b32.bc

rem Uncomment these two lines to use Advantage RDD
rem echo %hdir%\lib\rddads.lib + >> b32.bc
rem echo %hdir%\lib\Ace32.lib + >> b32.bc

echo %bcdir%\lib\cw32.lib + >> b32.bc
echo %bcdir%\lib\import32.lib + >> b32.bc
echo %bcdir%\lib\uuid.lib + >> b32.bc
echo %bcdir%\lib\ws2_32.lib + >> b32.bc
echo %bcdir%\lib\psdk\odbc32.lib + >> b32.bc
echo %bcdir%\lib\psdk\rasapi32.lib + >> b32.bc
echo %bcdir%\lib\psdk\nddeapi.lib + >> b32.bc
echo %bcdir%\lib\psdk\msimg32.lib + >> b32.bc
echo %bcdir%\lib\psdk\psapi.lib + >> b32.bc
echo %bcdir%\lib\psdk\gdiplus.lib + >> b32.bc
echo %bcdir%\lib\psdk\iphlpapi.lib + >> b32.bc
echo %bcdir%\lib\psdk\shell32.lib, >> b32.bc

IF EXIST %1.res echo %1.res >> b32.bc

rem uncomment this line to use the debugger and comment the following one
if %GT% == gtwin %bcdir%\bin\ilink32 -Gn -Tpe -s -v @b32.bc
IF ERRORLEVEL 1 GOTO LINKERROR
if %GT% == gtgui %bcdir%\bin\ilink32 -Gn -aa -Tpe -s -v @b32.bc
IF ERRORLEVEL 1 GOTO LINKERROR
ECHO * Application successfully built *
%1
GOTO EXIT
ECHO

rem delete temporary files
@del %1.c

:COMPILEERRORS
@type comp.log
ECHO * Compile errors *
GOTO EXIT

:LINKERROR
ECHO * Linking errors *
GOTO EXIT

:SINTAX
ECHO    SYNTAX: Build [Program]     {-- No especifiques la extensi¢n PRG
ECHO                                {-- Don't specify .PRG extension
GOTO EXIT

:NOEXIST
ECHO The specified PRG %1 does not exist

:EXIT
