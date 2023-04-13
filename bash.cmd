@ECHO OFF
::网址: nat.ee
::QQ群: 6281379
::TG群: https://t.me/nat_ee
::批处理: 荣耀&制作 QQ:1800619
::国内仓库: https://jihulab.com/winbash/cmd
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
SET "url_md5=%ar%/md5.txt"
SET "url_busybox=%ar%/busybox.exe"
SET "url_aria2c=%ar%/aria2c.exe"
SET "url_curl=%ar%/curl.zip"
SET "url_nssm=%ar%/nssm.exe"
SET "md5=%~dp0bin\%ar%\md5.txt"
SET "busybox=%~dp0bin\%ar%\busybox.exe"
SET "aria2c=%~dp0bin\%ar%\aria2c.exe"
SET "curl=%~dp0bin\%ar%\curl.exe"
SET "nssm=%~dp0bin\%ar%\nssm.exe"

:down_md5
IF NOT EXIST "%md5%" (
ECHO 校验信息 正在下载 
certutil -f -split -urlcache "%down%%url_md5%" delete 1>NUL 2>NUL
certutil -f -split -urlcache "%down%%url_md5%" "%md5%" 1>NUL 2>NUL
certutil -f -split -urlcache "%down%%url_md5%" delete 1>NUL 2>NUL
IF EXIST "%md5%" (
ECHO MD5.txt 下载成功
for %%t in (%md5%) do (
if "%%~zt" equ "0" (
ECHO MD5.txt 信息错误
DEL /f /q /a "%md5%" 1>NUL 2>NUL
)
)
) ELSE (
ECHO MD5.txt 下载失败
)
)

:down_busybox
IF NOT EXIST "%busybox%" (
ECHO.
ECHO BusyBox 正在下载
certutil -f -split -urlcache "%down%%url_busybox%" delete 1>NUL 2>NUL
certutil -f -split -urlcache "%down%%url_busybox%" "%busybox%" 1>NUL 2>NUL
certutil -f -split -urlcache "%down%%url_busybox%" delete 1>NUL 2>NUL
IF EXIST "%busybox%" (
ECHO BusyBox 下载成功
IF EXIST "%md5%" (
for /f "delims=" %%s in ('certutil -hashfile "%busybox%" MD5 2^>nul^|find /v ":" 2^>nul') do (SET md5_busybox=%%s)
for /f "delims=" %%m in ('findstr /i "busybox_md5" "%md5%" 2^>nul') do (SET %%m)
IF /i "!md5_busybox!" == "!busybox_md5!" (
ECHO BusyBox 校验成功
) ELSE (
ECHO BusyBox 校验失败
DEL /f /q /a "%busybox%" 1>NUL 2>NUL
)
)
) ELSE (
ECHO BusyBox 下载失败
)
)

:down_aria2
IF EXIST "%busybox%" (
IF NOT EXIST "%aria2c%" (
ECHO.
ECHO Aria2 正在下载
%busybox% wget -q --no-check-certificate "%down%%url_aria2c%" -O "%aria2c%"
IF EXIST "%aria2c%" (
ECHO Aria2 下载成功
IF EXIST "%md5%" (
for /f "delims=" %%s in ('certutil -hashfile "%aria2c%" MD5 2^>nul^|find /v ":" 2^>nul') do (SET md5_aria2c=%%s)
for /f "delims=" %%m in ('findstr /i "aria2c_md5" "%md5%" 2^>nul') do (SET %%m)
IF /i "!md5_aria2c!" == "!aria2c_md5!" (
ECHO Aria2 校验成功
) ELSE (
ECHO Aria2 校验失败
DEL /f /q /a "%aria2c%" 1>NUL 2>NUL
)
)
) ELSE (
ECHO Aria2 下载失败
)
)
)

:down_curl
IF EXIST "%busybox%" (
IF NOT EXIST "%curl%" (
ECHO.
ECHO Curl 正在下载 
%busybox% wget -q --no-check-certificate "%down%%url_curl%" -O "%~dp0bin\%ar%\curl.zip"
IF EXIST "%~dp0bin\%ar%\curl.zip" (
ECHO Curl 下载成功
IF EXIST "%md5%" (
for /f "delims=" %%s in ('certutil -hashfile "%~dp0bin\%ar%\curl.zip" MD5 2^>nul^|find /v ":" 2^>nul') do (SET md5_curl=%%s)
for /f "delims=" %%m in ('findstr /i "curl_md5" "%md5%" 2^>nul') do (SET %%m)
IF /i "!md5_curl!" == "!curl_md5!" (
ECHO Curl 校验成功
ECHO Curl 文件解压
%busybox% unzip -oq "%~dp0bin\%ar%\curl.zip" -d "%~dp0bin\%ar%"
) ELSE (
ECHO Curl 校验失败
DEL /f /q /a "%~dp0bin\%ar%\curl.zip" 1>NUL 2>NUL
)
)
IF EXIST "%curl%" (
ECHO Curl 解压成功
) ELSE (
ECHO Curl 解压失败
)
DEL /f /q /a "%~dp0bin\%ar%\curl.zip" 1>NUL 2>NUL
) ELSE (
ECHO Curl 下载失败
)
)
)

:down_nssm
IF EXIST "%busybox%" (
IF NOT EXIST "%nssm%" (
ECHO.
ECHO Nssm 正在下载 
%busybox% wget -q --no-check-certificate "%down%%url_nssm%" -O "%nssm%"
IF EXIST "%nssm%" (
ECHO Nssm 下载成功
IF EXIST "%md5%" (
for /f "delims=" %%s in ('certutil -hashfile "%nssm%" MD5 2^>nul^|find /v ":" 2^>nul') do (SET md5_nssm=%%s)
for /f "delims=" %%m in ('findstr /i "nssm_md5" "%md5%" 2^>nul') do (SET %%m)
IF /i "!md5_nssm!" == "!nssm_md5!" (
ECHO Nssm 校验成功
) ELSE (
ECHO Nssm 校验失败
DEL /f /q /a "%nssm%" 1>NUL 2>NUL
)
)
) ELSE (
ECHO Nssm 下载失败
)
)
)


ECHO.
%busybox%

ECHO.
%~dp0bin\%ar%\aria2c.exe -h

ECHO.
%~dp0bin\%ar%\curl.exe -h

ECHO.
%~dp0bin\%ar%\nssm.exe -h

PAUSE 
EXIT 