@echo off
TITLE CONG CU BAO TRI HE THONG SOL

:: KIEM TRA QUYEN ADMIN
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    CLS
    ECHO [31m[LOI]: VUI LONG CHAY CHUONG TRINH VOI QUYEN ADMIN![0m
    ECHO.
    PAUSE
    EXIT /B
)

:MENU
CLS
ECHO V1.00
ECHO [37m===========================================================[0m
echo [37m^|[0m                [31mCONG TY TNHH SOL[0m                              
echo [37m^|[0m            [32mCONG CU BAO TRI HE THONG SOL[0m                      
echo [37m^|[0m                   [32mLAM QUOC THO[0m                      
ECHO [37m===========================================================[0m
ECHO.
ECHO [37m[ LUA CHON CHUC NANG ][0m
ECHO [31m1.[0m Xem dia chi IP KAS
ECHO [31m2.[0m Xoa lenh may in bill 
ECHO [31m3.[0m In test may in
ECHO [31m4.[0m Don dep RAM
ECHO [31m5.[0m Xoa file rac (Windows, Google, Zalo)
ECHO [31m6.[0m Kiem tra dung luong o cung
ECHO [31m7.[0m Kiem tra va sua loi mang
ECHO [31m8.[0m Cap nhat ung dung
ECHO [31m9.[0m Thoat
echo.
ECHO [37m                                                           [0m                                                       
echo [32m                     HUONG DAN SU DUNG                     [0m
echo =============================================================
echo Phim 1     : Xem dia chi dang nhap cua KAS
echo Phim 2,3   : Sua loi may in khong ra bill
echo Phim 4,5,6 : Sua PC bi treo, lag, day o cung
echo Phim 7     : Kiem tra, sua loi mang, ket noi yeu
echo ============================================================
echo.
SET /P CHOICE=[37mNHAP LUA CHON [1-8]: [0m
IF "%CHOICE%"=="1" GOTO IP
IF "%CHOICE%"=="2" GOTO PRINT
IF "%CHOICE%"=="3" GOTO PRINTTEST
IF "%CHOICE%"=="4" GOTO RAM
IF "%CHOICE%"=="5" GOTO CLEAN
IF "%CHOICE%"=="6" GOTO CHECKDISK
IF "%CHOICE%"=="7" GOTO FIXNETWORK
IF "%CHOICE%"=="8" GOTO UPDATE
IF "%CHOICE%"=="9" EXIT

ECHO [31m[LOI]: LUA CHON KHONG HOP LE! VUI LONG NHAP LAI.[0m
PAUSE
GOTO MENU

:IP
CLS
for /f "tokens=2 delims=:" %%A in ('ipconfig ^| findstr /c:"IPv4"') do (
    set ip=%%A
)
set ip=%ip:~1%
ECHO [37m===========================================================[0m
ECHO [37m^|[0m            [32mCONG TY TNHH SOL[0m               [37m^[0m
ECHO [37m^|[0m      DIA CHI IP DANG NHAP CUA KAS                  [37m^[0m
ECHO [37m^|[0m         [31m%ip%/KR[0m                           [37m^[0m
ECHO [37m^|[0m      DIA CHI DANG NHAP WEB CUA KAS                  [37m^[0m
ECHO [37m^|[0m         [31m SOL.KAS.ASIA [0m                    [37m^[0m
ECHO [37m===========================================================[0m
ECHO.
PAUSE
GOTO MENU

:RAM
CLS
Enable ANSI color support (Windows 10+)
for /f "tokens=3" %%a in ('reg query "HKCU\Console" /v VirtualTerminalLevel 2^>nul') do set "VTL=%%a"
if not defined VTL (
    reg add "HKCU\Console" /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul
)
:MAIN
cls
echo [37m===========================================================[0m
echo [37m^|           [32mDANG DON DEP RAM...[0m              [37m^|[0m
echo [37m===========================================================[0m
echo.

:: List of processes to terminate
set "processes=OneDrive.exe RuntimeBroker.exe YourPhone.exe SearchIndexer.exe"
set "success=0"
set "failed=0"

for %%p in (%processes%) do (
    tasklist | find /i "%%p" >nul
    if !errorlevel! equ 0 (
        taskkill /f /im "%%p" /t >nul 2>&1
        if !errorlevel! equ 0 (
            echo [32mTerminated %%p successfully.[0m
            set /a success+=1
        ) else (
            echo [31mFailed to terminate %%p.[0m
            set /a failed+=1
        )
    ) else (
        echo [33m%%p is not running.[0m
    )
)

echo.
echo [37m===========================================================[0m
echo [37m^|[0m         [32mDON DEP RAM HOAN TAT![0m             [37m^|[0m
echo [37mSummary: %success% succeeded, %failed% failed.[0m
echo [37m===========================================================[0m
PAUSE
GOTO MENU

:PRINT
CLS
ECHO [37m===========================================================[0m
ECHO [37m^|[0m      [32mDANG XOA LENH IN TRONG HANG DOI...[0m     [37m^|[0m
ECHO [37m===========================================================[0m
NET STOP SPOOLER
DEL /Q /F %SYSTEMROOT%\SYSTEM32\SPOOL\PRINTERS\*.*
NET START SPOOLER
ECHO.
ECHO [37m===========================================================[0m
ECHO [37m^|[0m        [32mXOA HANG DOI IN HOAN TAT![0m          [37m^|[0m
ECHO [37m===========================================================[0m
PAUSE
GOTO MENU

:PRINTTEST
CLS
setlocal enabledelayedexpansion
set "printerListFile=%temp%\printers.txt"
del "%printerListFile%" >nul 2>&1
ECHO [37m===========================================================[0m
ECHO [37m^|[0m           [32mLAY DANH SACH MAY IN...[0m          [37m^|[0m
ECHO [37m===========================================================[0m
powershell -Command "Get-Printer | Select-Object -ExpandProperty Name" > "%printerListFile%"
ECHO.
ECHO [37m==== DANH SACH MAY IN ====[0m
set /a counter=0
for /f "usebackq delims=" %%a in ("%printerListFile%") do (
    set /a counter+=1
    set "printer[!counter!]=%%a"
    echo [31m!counter!.[0m %%a
)
ECHO [37m==========================[0m
set /p selection=[37mNhap so thu tu may in [1-%counter%]: [0m
set "chosenPrinter=!printer[%selection%]!"
if not defined chosenPrinter (
    ECHO.
    ECHO [31m[LOI]: LUA CHON KHONG HOP LE![0m
    PAUSE
    GOTO MENU
)
ECHO.
ECHO [37m===========================================================[0m
ECHO [37m^|[0m      [32mDANG IN TEST PAGE CHO: %chosenPrinter%[0m     [37m^|[0m
ECHO [37m===========================================================[0m
powershell -Command "Start-Process -FilePath 'rundll32.exe' -ArgumentList 'printui.dll,PrintUIEntry /k /n \"!chosenPrinter!\"' -Verb runAs"
ECHO.
ECHO [31mLENH IN DA DUOC GUI, KIEM TRA MAY IN CO RA BILL?[0m
ECHO.
ECHO [37m-----------------------------------------------------------[0m
ECHO [32m- BILL RA, PHAN MEN KAS KHONG RA, BAO KAS DE XU LY.[0m
ECHO [32m- BILL KHONG RA, KIEM TRA DAY MANG, NEU KHONG DUOC BAO IT.[0m
ECHO [37m-----------------------------------------------------------[0m
PAUSE
GOTO MENU

:CLEAN
CLS
ECHO [37m===========================================================[0m
ECHO [37m^|[0m           [32mDANG XOA FILE RAC...[0m             [37m^|[0m
ECHO [37m===========================================================[0m
DEL /S /F /Q %TEMP%\*.*
FOR /D %%D IN ("%TEMP%\*") DO RD /S /Q "%%D"
DEL /S /F /Q C:\Windows\Temp\*.*
DEL /S /F /Q C:\Windows\Prefetch\*.*
DEL /S /F /Q %LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache\*.*
IF EXIST "%APPDATA%\ZaloPC" RD /S /Q "%APPDATA%\ZaloPC"
IF EXIST "%LOCALAPPDATA%\ZaloPC" RD /S /Q "%LOCALAPPDATA%\ZaloPC"
RD /S /Q "%SystemDrive%\$Recycle.Bin"
ECHO.
ECHO [37m===========================================================[0m
ECHO [37m^|[0m          [32mXOA FILE RAC HOAN TAT![0m            [37m^|[0m
ECHO [37m===========================================================[0m
PAUSE
GOTO MENU



:CHECKDISK
CLS
TITLE Disk Check and Optimization Utility

:CHECKDISK
ECHO KIEM TRA DUNG LUONG O CUNG...
ECHO.

:: Get free disk space
FOR /F "tokens=3" %%A IN ('DIR %SystemDrive%\ ^| FIND "bytes free"') DO SET FreeSpaceBytes=%%A
SET FreeSpaceBytes=%FreeSpaceBytes:,=%

:: Convert to GB and MB
SET /A FreeSpaceGB=%FreeSpaceBytes:~0,-9%
IF %FreeSpaceGB% GEQ 1 (
    ECHO --- DUNG LUONG TRONG: %FreeSpaceGB% GB
) ELSE (
    SET /A FreeSpaceMB=%FreeSpaceBytes:~0,-6%
    ECHO --- DUNG LUONG TRONG: %FreeSpaceMB% MB (NHO HON 1 GB)
)

:: Check disk health
WMIC DISKDRIVE GET STATUS | FIND "OK" >nul 2>&1
IF %ERRORLEVEL%==0 (
    ECHO.
    ECHO ======================================================
    ECHO [32m --- O CUNG VAN DANG HOAT DONG TOT! [0m
    ECHO ======================================================
) ELSE (
    ECHO.
    ECHO ======================================================
    ECHO [31m--- CANH BAO: O CUNG CO VAN DE! CAN KIEM TRA NGAY.[0m
    ECHO ======================================================
)

:: Disk Optimization Section
ECHO.
ECHO ======================================================
ECHO ---BAT DAU TOI UU HOA O CUNG...
ECHO ======================================================
ECHO.

:: Run disk defragmentation
ECHO Dang phan tich o dia %SystemDrive%...
defrag %SystemDrive% /A >nul 2>&1
IF %ERRORLEVEL%==0 (
    ECHO Phan tich hoan tat. Bat dau toi uu hoa...
    defrag %SystemDrive% /O /V >nul 2>&1
    IF %ERRORLEVEL%==0 (
        ECHO.
        ECHO ======================================================
        ECHO [32m --- TOI UU HOA O CUNG HOAN TAT THANH CONG! [0m
        ECHO ======================================================
    ) ELSE (
        ECHO.
        ECHO ======================================================
        ECHO [31m --- LOI: KHONG THE TOI UU HOA O CUNG! [0m
        ECHO Vui long kiem tra quyen quan tri vien.
        ECHO ======================================================
    )
) ELSE (
    ECHO.
    ECHO ======================================================
    ECHO [31m --- LOI: KHONG THE PHAN TICH O CUNG! [0m
    ECHO Vui long kiem tra quyen quan tri vien.
    ECHO ======================================================
)

:: Final message
ECHO.
ECHO ======================================================
ECHO [32m---KIEM TRA VA TOI UU HOA O CUNG HOAN TAT![0m
ECHO ======================================================
ECHO.

:: Return to menu or pause
PAUSE
GOTO MENU




:FIXNETWORK
CLS
ECHO [37m===========================================================[0m
ECHO [37m^|[0m         [32mKIEM TRA KET NOI MANG...[0m           [37m^|[0m
ECHO [37m===========================================================[0m
PING 8.8.8.8 -n 1 >nul 2>&1
SET NET_STATUS=%ERRORLEVEL%
IF %NET_STATUS% NEQ 0 (
    ECHO.
    ECHO [31mMAT KET NOI MANG! DANG SUA LOI...[0m
    ECHO [37m- Dat lai IP...[0m
    ipconfig /release >nul 2>&1
    ipconfig /renew >nul 2>&1
    ECHO [37m- Xoa cache DNS...[0m
    ipconfig /flushdns >nul 2>&1
    ECHO [37m- Dat lai Winsock...[0m
    netsh winsock reset >nul 2>&1
    netsh int ip reset >nul 2>&1
    ECHO [37m- Kiem tra lai mang...[0m
    PING 8.8.8.8 -n 1 >nul 2>&1
    SET NET_STATUS=%ERRORLEVEL%
    IF %NET_STATUS% NEQ 0 (
        ECHO.
        ECHO [37m===========================================================[0m
        ECHO [37m^|[0m   [31mVAN KHONG CO INTERNET! KIEM TRA DAY MANG![0m   [37m^|[0m
        ECHO [37m===========================================================[0m
        PAUSE
        GOTO MENU
    ) ELSE (
        ECHO.
        ECHO [37m===========================================================[0m
        ECHO [37m^|[0m       [32mKET NOI MANG DA KHOI PHUC![0m         [37m^|[0m
        ECHO [37m===========================================================[0m
    )
) ELSE (
    ECHO.
    ECHO [37m===========================================================[0m
    ECHO [37m^|[0m         [32mKET NOI MANG ON DINH![0m             [37m^|[0m
    ECHO [37m===========================================================[0m
)
ECHO.
ECHO [37m- Do toc do mang...[0m
where speedtest >nul 2>nul
IF ERRORLEVEL 1 (
    ECHO [37m- Chua cai Speedtest CLI. Dang tai...[0m
    powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-win64.zip' -OutFile 'speedtest.zip'}"
    powershell -Command "Expand-Archive -Path speedtest.zip -DestinationPath . -Force"
    move speedtest\speedtest.exe . >nul
    del speedtest.zip
    rmdir /s /q speedtest
)
speedtest --accept-license >nul 2>&1
PING 8.8.8.8 -n 2 >nul
IF ERRORLEVEL 1 (
    ECHO.
    ECHO [37m===========================================================[0m
    ECHO [37m^|[0m   [31mKHONG THE DO TOC DO MANG! KIEM TRA KET NOI.[0m  [37m^|[0m
    ECHO [37m===========================================================[0m
    PAUSE
    GOTO MENU
)
speedtest --progress=no --format=json > speedtest_result.json
for /f "delims=" %%i in ('powershell -Command "(Get-Content speedtest_result.json | ConvertFrom-Json).download.bandwidth / 125000"') do set DOWNLOAD=%%i
for /f "delims=" %%i in ('powershell -Command "(Get-Content speedtest_result.json | ConvertFrom-Json).upload.bandwidth / 125000"') do set UPLOAD=%%i
ECHO.
ECHO [37m===========================================================[0m
ECHO [37m^|[0m Toc do tai xuong: [32m%DOWNLOAD% Mbps[0m                   [37m^|[0m
ECHO [37m^|[0m Toc do tai len: [32m%UPLOAD% Mbps[0m                     [37m^|[0m
ECHO [37m===========================================================[0m
IF %DOWNLOAD%==0 (
    ECHO [31mKHONG THE DO TOC DO MANG! KIEM TRA LAI KET NOI.[0m
) ELSE IF %DOWNLOAD% LEQ 50 (
    ECHO [31mMANG INTERNET YEU![0m
) ELSE (
    ECHO [32mMANG INTERNET MANH![0m
)
DEL speedtest_result.json
PAUSE
GOTO MENU

:UPDATE
@echo off
setlocal

:: ======== THIET LAP ========
set "URL=https://raw.githubusercontent.com/Tholam94/Sol-tool/refs/heads/main/updater.bat"
set "TMPFILE=%TEMP%\tool_new.bat"
set "APPFILE=%~f0"
set "UPDATER=%TEMP%\updater.bat"

echo [INFO] Dang tai ban cap nhat moi...
powershell -Command "Invoke-WebRequest -Uri '%URL%' -OutFile '%TMPFILE%'"

if not exist "%TMPFILE%" (
    echo [ERROR] Khong the tai ban cap nhat moi.
    pause
    goto MENU
)

echo [INFO] Dang cap nhat...
> "%UPDATER%" (
    echo @echo off
    echo timeout /t 2 ^>nul
    echo copy /Y "%TMPFILE%" "%APPFILE%" ^>nul
    echo start "" "%APPFILE%"
    echo del "%%~f0"
)

start "" "%UPDATER%"
exit
