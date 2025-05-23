@echo off
setlocal enabledelayedexpansion

echo ===================================================
echo Chocolatey�p�b�P�[�W�����C���X�g�[���c�[��
echo ===================================================
echo ���t: %date%
echo ����: %time%
echo.

REM �������̎擾
SET yyyy=%date:~0,4%
SET mm=%date:~5,2%
SET dd=%date:~8,2%
SET time2=%time: =0%
SET hh=%time2:~0,2%
SET mn=%time2:~3,2%
SET ss=%time2:~6,2%
SET filename=%yyyy%-%mm%%dd%-%hh%%mn%%ss%

REM ���O�f�B���N�g���̐ݒ�
SET LOG_DIR=C:\work\log
SET LOG=%LOG_DIR%\cinst_%filename%.txt
SET TEMP_FILE=%TEMP%\packages_to_install.txt

REM ���O�f�B���N�g���̑��݊m�F�A�Ȃ���΍쐬
IF NOT EXIST "%LOG_DIR%" (
    MKDIR "%LOG_DIR%"
    echo ���O�f�B���N�g�����쐬���܂���: %LOG_DIR%
)

REM �p�b�P�[�W���X�g�t�@�C���̑��݊m�F
SET PACKAGE_LIST=packages.txt
IF NOT EXIST "%PACKAGE_LIST%" (
    echo �G���[: �p�b�P�[�W���X�g�t�@�C���i%PACKAGE_LIST%�j��������܂���B
    echo �����f�B���N�g���� %PACKAGE_LIST% �t�@�C�����쐬���Ă��������B
    echo �����𒆎~���܂��B
    goto :EOF
)

echo ���O�t�@�C��: %LOG%
echo �p�b�P�[�W���X�g: %PACKAGE_LIST%
echo.

REM �ꎞ�t�@�C���̏�����
if exist "%TEMP_FILE%" del "%TEMP_FILE%"

REM �p�b�P�[�W���X�g�̓ǂݍ��݂ƃt�B���^�����O
echo �p�b�P�[�W���X�g��ǂݍ���ł��܂�...
set count=0
for /F "usebackq tokens=* eol=# delims=" %%A in ("%PACKAGE_LIST%") do (
    set line=%%A
    if not "!line!"=="" (
        echo !line!>>"%TEMP_FILE%"
        set /a count+=1
    )
)

echo �C���X�g�[���Ώۃp�b�P�[�W��: !count!
echo.

REM �p�b�P�[�W��������Ȃ��ꍇ
if !count! EQU 0 (
    echo �x��: �C���X�g�[���Ώۂ̃p�b�P�[�W��������܂���B
    echo %PACKAGE_LIST% �t�@�C�����m�F���Ă��������B
    echo �����𒆎~���܂��B
    goto :EOF
)

REM �C���X�g�[���J�n
echo ===================================================
echo Chocolatey�p�b�P�[�W�̃C���X�g�[�����J�n���܂�...
echo ===================================================
echo.

REM ���O�t�@�C���̃w�b�_�[
echo ===== Chocolatey�p�b�P�[�W�C���X�g�[�����O ===== > "%LOG%"
echo ����: %date% %time% >> "%LOG%"
echo �p�b�P�[�W���X�g: %PACKAGE_LIST% >> "%LOG%"
echo �C���X�g�[���Ώۃp�b�P�[�W��: !count! >> "%LOG%"
echo. >> "%LOG%"

REM �ꊇ�C���X�g�[���R�}���h�̍\�z
set packages=
for /F "usebackq tokens=*" %%A in ("%TEMP_FILE%") do (
    set packages=!packages! %%A
)

REM �C���X�g�[���̎��s
echo �C���X�g�[������p�b�P�[�W:!packages!
echo.
echo �C���X�g�[�����J�n���܂�...���̏����ɂ͎��Ԃ�������ꍇ������܂��B
echo.

echo choco install!packages! -y >> "%LOG%"
choco install!packages! -y >> "%LOG%" 2>&1

REM ���ʂ̊m�F
IF %ERRORLEVEL% NEQ 0 (
    echo.
    echo �x��: �ꕔ�̃p�b�P�[�W�̃C���X�g�[���Ɏ��s�����\��������܂��B
    echo ���O�t�@�C���i%LOG%�j���m�F���Ă��������B
) ELSE (
    echo.
    echo ���ׂẴp�b�P�[�W������ɃC���X�g�[������܂����B
)

REM �ꎞ�t�@�C���̍폜
if exist "%TEMP_FILE%" del "%TEMP_FILE%"

echo.
echo ===================================================
echo �C���X�g�[���������������܂����B
echo ���O�t�@�C��: %LOG%
echo ===================================================
echo.
echo �����L�[�������ƏI�����܂�...
pause > nul
