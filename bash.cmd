@ECHO OFF
::��ַ: nat.ee
::QQȺ: 6281379
::TGȺ: https://t.me/nat_ee
::������: ��ҫ&���� QQ:1800619
::���ڲֿ�: https://jihulab.com/winbash/cmd
::����ֿ�: https://github.com/yyingc/bash
setlocal enabledelayedexpansion
REG QUERY "HKU\S-1-5-19" 1>NUL 2>NUL
IF %ERRORLEVEL% GTR 0 ((
ECHO SET UAC = CreateObject^("Shell.Application"^)
ECHO UAC.ShellExecute "%~f0", "%1", "", "runas", 1
)>"%TEMP%\GetAdmin.vbs"
ECHO �Թ���Ա�������
CSCRIPT //Nologo "%TEMP%\GetAdmin.vbs"
DEL /F /Q "%TEMP%\GetAdmin.vbs" 1>NUL 2>NUL
EXIT /B)
IF NOT EXIST "%SystemRoot%\System32\certutil.exe" (
title ����
ECHO ����: 
ECHO ϵͳ������ certutil.exe �ļ�
ECHO �޷�������������ǿ���ܻ�������
ECHO.
ECHO ��������˳�����
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
ECHO У����Ϣ �������� 
certutil -f -split -urlcache "%down%%url_md5%" delete 1>NUL 2>NUL
certutil -f -split -urlcache "%down%%url_md5%" "%md5%" 1>NUL 2>NUL
certutil -f -split -urlcache "%down%%url_md5%" delete 1>NUL 2>NUL
IF EXIST "%md5%" (
ECHO MD5.txt ���سɹ�
for %%t in (%md5%) do (
if "%%~zt" equ "0" (
ECHO MD5.txt ��Ϣ����
DEL /f /q /a "%md5%" 1>NUL 2>NUL
)
)
) ELSE (
ECHO MD5.txt ����ʧ��
)
)

:down_busybox
IF NOT EXIST "%busybox%" (
ECHO.
ECHO BusyBox ��������
certutil -f -split -urlcache "%down%%url_busybox%" delete 1>NUL 2>NUL
certutil -f -split -urlcache "%down%%url_busybox%" "%busybox%" 1>NUL 2>NUL
certutil -f -split -urlcache "%down%%url_busybox%" delete 1>NUL 2>NUL
IF EXIST "%busybox%" (
ECHO BusyBox ���سɹ�
IF EXIST "%md5%" (
for /f "delims=" %%s in ('certutil -hashfile "%busybox%" MD5 2^>nul^|find /v ":" 2^>nul') do (SET md5_busybox=%%s)
for /f "delims=" %%m in ('findstr /i "busybox_md5" "%md5%" 2^>nul') do (SET %%m)
IF /i "!md5_busybox!" == "!busybox_md5!" (
ECHO BusyBox У��ɹ�
) ELSE (
ECHO BusyBox У��ʧ��
DEL /f /q /a "%busybox%" 1>NUL 2>NUL
)
)
) ELSE (
ECHO BusyBox ����ʧ��
)
)

:down_aria2
IF EXIST "%busybox%" (
IF NOT EXIST "%aria2c%" (
ECHO.
ECHO Aria2 ��������
%busybox% wget -q --no-check-certificate "%down%%url_aria2c%" -O "%aria2c%"
IF EXIST "%aria2c%" (
ECHO Aria2 ���سɹ�
IF EXIST "%md5%" (
for /f "delims=" %%s in ('certutil -hashfile "%aria2c%" MD5 2^>nul^|find /v ":" 2^>nul') do (SET md5_aria2c=%%s)
for /f "delims=" %%m in ('findstr /i "aria2c_md5" "%md5%" 2^>nul') do (SET %%m)
IF /i "!md5_aria2c!" == "!aria2c_md5!" (
ECHO Aria2 У��ɹ�
) ELSE (
ECHO Aria2 У��ʧ��
DEL /f /q /a "%aria2c%" 1>NUL 2>NUL
)
)
) ELSE (
ECHO Aria2 ����ʧ��
)
)
)

:down_curl
IF EXIST "%busybox%" (
IF NOT EXIST "%curl%" (
ECHO.
ECHO Curl �������� 
%busybox% wget -q --no-check-certificate "%down%%url_curl%" -O "%~dp0bin\%ar%\curl.zip"
IF EXIST "%~dp0bin\%ar%\curl.zip" (
ECHO Curl ���سɹ�
IF EXIST "%md5%" (
for /f "delims=" %%s in ('certutil -hashfile "%~dp0bin\%ar%\curl.zip" MD5 2^>nul^|find /v ":" 2^>nul') do (SET md5_curl=%%s)
for /f "delims=" %%m in ('findstr /i "curl_md5" "%md5%" 2^>nul') do (SET %%m)
IF /i "!md5_curl!" == "!curl_md5!" (
ECHO Curl У��ɹ�
ECHO Curl �ļ���ѹ
%busybox% unzip -oq "%~dp0bin\%ar%\curl.zip" -d "%~dp0bin\%ar%"
) ELSE (
ECHO Curl У��ʧ��
DEL /f /q /a "%~dp0bin\%ar%\curl.zip" 1>NUL 2>NUL
)
)
IF EXIST "%curl%" (
ECHO Curl ��ѹ�ɹ�
) ELSE (
ECHO Curl ��ѹʧ��
)
DEL /f /q /a "%~dp0bin\%ar%\curl.zip" 1>NUL 2>NUL
) ELSE (
ECHO Curl ����ʧ��
)
)
)

:down_nssm
IF EXIST "%busybox%" (
IF NOT EXIST "%nssm%" (
ECHO.
ECHO Nssm �������� 
%busybox% wget -q --no-check-certificate "%down%%url_nssm%" -O "%nssm%"
IF EXIST "%nssm%" (
ECHO Nssm ���سɹ�
IF EXIST "%md5%" (
for /f "delims=" %%s in ('certutil -hashfile "%nssm%" MD5 2^>nul^|find /v ":" 2^>nul') do (SET md5_nssm=%%s)
for /f "delims=" %%m in ('findstr /i "nssm_md5" "%md5%" 2^>nul') do (SET %%m)
IF /i "!md5_nssm!" == "!nssm_md5!" (
ECHO Nssm У��ɹ�
) ELSE (
ECHO Nssm У��ʧ��
DEL /f /q /a "%nssm%" 1>NUL 2>NUL
)
)
) ELSE (
ECHO Nssm ����ʧ��
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