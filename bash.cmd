@ECHO OFF
::网址: nat.ee
::QQ群: 6281379
::TG群: https://t.me/nat_ee
::批处理: 荣耀&制作 QQ:1800619
::国内仓库: https://yyingc.coding.net/public/i/bash/git/files
::国外仓库: https://github.com/yyingc/bash
setlocal enabledelayedexpansion
REG QUERY "HKU\S-1-5-19" 1>NUL 2>NUL
IF %ERRORLEVEL% GTR 0 ((
ECHO SET UAC = CreateObject^("Shell.Application"^)
ECHO UAC.ShellExecute "%~f0", "%1", "", "runas", 1
)>"%TEMP%\GetAdmin.vbs"
ECHO 以管理员身份运行
CSCRIPT //Nologo "%TEMP%\GetAdmin.vbs"
DEL /F /Q "%TEMP%\GetAdmin.vbs" 1>NUL 2>NUL
EXIT /B)
IF NOT EXIST "%SystemRoot%\System32\certutil.exe" (
title 错误
ECHO 错误: 
ECHO 系统不存在 certutil.exe 文件
ECHO 无法下载批处理增强功能环境……
ECHO.
ECHO 按任意键退出……
PAUSE >NUL
EXIT
)
pushd "%~dp0"
IF /i "%PROCESSOR_ARCHITECTURE%" == "AMD64" (SET ar=amd64) ELSE (SET ar=x86)
IF NOT EXIST "%~dp0\bin\%ar%\*" (MD "%~dp0\bin\%ar%")

SET "down=https://raw.githubusercontent.com/yyingc/bash/master/"
SET "url_busybox=%ar%/busybox/busybox.exe"
SET "url_aria2=%ar%/aria2/aria2c.exe"
SET "url_curl=%ar%/curl/curl.zip"
SET "buybox=%~dp0\bin\%ar%\busybox.exe"

:down_busybox
IF NOT EXIST "%buybox%" (
ECHO BusyBox 正在下载
certutil -urlcache -split -f "%down%%url_busybox%" delete 1>NUL 2>NUL
certutil -urlcache -split -f "%down%%url_busybox%" "%buybox%" 1>NUL 2>NUL
certutil -urlcache -split -f "%down%%url_busybox%" delete 1>NUL 2>NUL
IF EXIST "%buybox%" (
ECHO BusyBox 下载成功
) ELSE (
ECHO BusyBox 下载失败
)
)

:down_aria2
IF EXIST "%buybox%" (
IF NOT EXIST "%~dp0\bin\%ar%\aria2c.exe" (
ECHO.
ECHO Aria2 正在下载 
%buybox% wget -q --no-check-certificate "%down%%url_aria2%" -O "%~dp0\bin\%ar%\aria2c.exe"
IF EXIST "%~dp0\bin\%ar%\aria2c.exe" (
ECHO Aria2 下载成功
) ELSE (
ECHO Aria2 下载失败
)
)
)

:down_curl
IF EXIST "%buybox%" (
IF NOT EXIST "%~dp0\bin\%ar%\curl.exe" (
ECHO.
ECHO Curl 正在下载 
%buybox% wget -q --no-check-certificate "%down%%url_curl%" -O "%~dp0\bin\%ar%\curl.zip"
IF EXIST "%~dp0\bin\%ar%\curl.zip" (
ECHO Curl 下载成功
ECHO Curl 文件解压
%buybox% unzip -oq "%~dp0\bin\%ar%\curl.zip" -d "%~dp0\bin\%ar%"
IF EXIST "%~dp0\bin\%ar%\curl.exe" (
ECHO Curl 解压成功
) ELSE (
ECHO Curl 解压失败
)
DEL /f /q /a "%~dp0\bin\%ar%\curl.zip" 1>NUL 2>NUL
) ELSE (
ECHO Curl 下载失败
)
)
)

ECHO.
%buybox%

ECHO.
%~dp0\bin\%ar%\aria2c.exe -h

ECHO.
%~dp0\bin\%ar%\curl.exe -h

PAUSE 
EXIT 
