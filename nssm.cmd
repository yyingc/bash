@ECHO OFF
::��ַ: nat.ee
::QQȺ: 6281379
::TGȺ: https://t.me/nat_ee
::������: ��ҫ&���� QQ:1800619
::���ڲֿ�: https://gitee.com/yyingc/bash
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
ECHO �޷�������������ǿ������������
ECHO.
ECHO ��������˳�����
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
SET "url_nssm=%ar%/nssm/nssm.exe"
SET "buybox=%~dp0\bin\%ar%\busybox.exe"

:down_busybox
IF NOT EXIST "%buybox%" (
ECHO BusyBox ��������
certutil -urlcache -split -f "%down%%url_busybox%" delete 1>NUL 2>NUL
certutil -urlcache -split -f "%down%%url_busybox%" "%buybox%" 1>NUL 2>NUL
certutil -urlcache -split -f "%down%%url_busybox%" delete 1>NUL 2>NUL
IF EXIST "%buybox%" (
ECHO BusyBox ���سɹ�
) ELSE (
ECHO BusyBox ����ʧ��
)
)

:down_aria2
IF EXIST "%buybox%" (
IF NOT EXIST "%~dp0\bin\%ar%\aria2c.exe" (
ECHO.
ECHO Aria2 �������� 
%buybox% wget -q --no-check-certificate "%down%%url_aria2%" -O "%~dp0\bin\%ar%\aria2c.exe"
IF EXIST "%~dp0\bin\%ar%\aria2c.exe" (
ECHO Aria2 ���سɹ�
) ELSE (
ECHO Aria2 ����ʧ��
)
)
)

:down_curl
IF EXIST "%buybox%" (
IF NOT EXIST "%~dp0\bin\%ar%\curl.exe" (
ECHO.
ECHO Curl �������� 
%buybox% wget -q --no-check-certificate "%down%%url_curl%" -O "%~dp0\bin\%ar%\curl.zip"
IF EXIST "%~dp0\bin\%ar%\curl.zip" (
ECHO Curl ���سɹ�
ECHO Curl �ļ���ѹ
%buybox% unzip -oq "%~dp0\bin\%ar%\curl.zip" -d "%~dp0\bin\%ar%"
IF EXIST "%~dp0\bin\%ar%\curl.exe" (
ECHO Curl ��ѹ�ɹ�
) ELSE (
ECHO Curl ��ѹʧ��
)
DEL /f /q /a "%~dp0\bin\%ar%\curl.zip" 1>NUL 2>NUL
) ELSE (
ECHO Curl ����ʧ��
)
)
)

:down_nssm
IF EXIST "%buybox%" (
IF NOT EXIST "%~dp0\bin\%ar%\nssm.exe" (
ECHO.
ECHO Nssm �������� 
%buybox% wget -q --no-check-certificate "%down%%url_nssm%" -O "%~dp0\bin\%ar%\nssm.exe"
IF EXIST "%~dp0\bin\%ar%\nssm.exe" (
ECHO Nssm ���سɹ�
) ELSE (
ECHO Nssm ����ʧ��
)
)
)

ECHO.
%buybox%

ECHO.
%~dp0\bin\%ar%\aria2c.exe -h

ECHO.
%~dp0\bin\%ar%\curl.exe -h

ECHO.
%~dp0\bin\%ar%\nssm.exe -h

PAUSE 
EXIT 