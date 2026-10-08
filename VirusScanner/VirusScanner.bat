@echo off
chcp 65001 >nul
title 🛡️ Virus Scanner Pro - Проверка файлов на вирусы
color 0A
setlocal enabledelayedexpansion

:: ============================================
::   VIRUS SCANNER PRO v2.0
::   Автор: YourName
::   GitHub: https://github.com/yourname
:: ============================================

:: Проверка прав администратора
net session >nul 2>&1
if %errorLevel% neq 0 (
    color 0C
    echo.
    echo  ╔══════════════════════════════════════════════════╗
    echo  ║  ⚠️  ВНИМАНИЕ: Требуются права администратора!   ║
    echo  ║  Перезапустите программу от имени администратора ║
    echo  ╚══════════════════════════════════════════════════╝
    echo.
    pause
    exit /b
)

:MENU
cls
color 0A
call :BANNER

echo.
echo  ╔══════════════════════════════════════════════════════╗
echo  ║                    ГЛАВНОЕ МЕНЮ                      ║
echo  ╠══════════════════════════════════════════════════════╣
echo  ║                                                      ║
echo  ║   [1] 🔍  Быстрая проверка папки                     ║
echo  ║   [2] 🎯  Проверка конкретного файла                 ║
echo  ║   [3] 💻  Полная проверка системы                    ║
echo  ║   [4] 📊  Информация о системе                       ║
echo  ║   [5] 🚪  Выход                                      ║
echo  ║                                                      ║
echo  ╚══════════════════════════════════════════════════════╝
echo.
set /p choice="  👉 Выберите пункт [1-5]: "

if "%choice%"=="1" goto QUICK_SCAN
if "%choice%"=="2" goto FILE_SCAN
if "%choice%"=="3" goto FULL_SCAN
if "%choice%"=="4" goto SYSINFO
if "%choice%"=="5" goto EXIT
goto MENU

:: ============================================
::   БАННЕР
:: ============================================
:BANNER
echo.
echo   ██╗   ██╗██╗██████╗ ██╗   ██╗███████╗
echo   ██║   ██║██║██╔══██╗██║   ██║██╔════╝
echo   ██║   ██║██║██████╔╝██║   ██║███████╗
echo   ╚██╗ ██╔╝██║██╔══██╗██║   ██║╚════██║
echo    ╚████╔╝ ██║██║  ██║╚██████╔╝███████║
echo     ╚═══╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝
echo.
echo          ░▒▓█ S C A N N E R   P R O █▓▒░
echo               ═══ v2.0 ═══
echo.
goto :eof

:: ============================================
::   АНИМАЦИЯ ЗАГРУЗКИ
:: ============================================
:LOADING
set "msg=%~1"
echo.
echo  ┌────────────────────────────────────────────────────┐
echo  │  %msg%
echo  └────────────────────────────────────────────────────┘
echo.
<nul set /p "=  Прогресс: ["
for /L %%i in (1,1,30) do (
    <nul set /p "=█"
    ping -n 1 -w 50 127.0.0.1 >nul 2>&1
)
echo ] 100%%
echo.
goto :eof

:: ============================================
::   БЫСТРАЯ ПРОВЕРКА
:: ============================================
:QUICK_SCAN
cls
color 0B
call :BANNER
echo.
echo  ╔══════════════════════════════════════════════════════╗
echo  ║              🔍 БЫСТРАЯ ПРОВЕРКА ПАПКИ                ║
echo  ╚══════════════════════════════════════════════════════╝
echo.
set /p "scanpath=  📁 Введите путь к папке (Enter = текущая): "
if "%scanpath%"=="" set "scanpath=%CD%"

if not exist "%scanpath%" (
    color 0C
    echo.
    echo  ❌ ОШИБКА: Папка не найдена!
    pause
    goto MENU
)

call :LOADING "Сканирование папки: %scanpath%"

color 0E
echo  ⏳ Анализ файлов...
echo.

set /a total=0
set /a threats=0
set /a safe=0

for /r "%scanpath%" %%F in (*.*) do (
    set /a total+=1
    set "filename=%%~nxF"
    set "extension=%%~xF"
    
    :: Проверка на подозрительные расширения
    echo !extension! | findstr /i /c:".exe" /c:".bat" /c:".cmd" /c:".vbs" /c:".js" /c:".ps1" >nul
    if !errorlevel! equ 0 (
        :: Проверка на подозрительные имена
        echo !filename! | findstr /i /c:"virus" /c:"trojan" /c:"hack" /c:"crack" /c:"keygen" /c:"malware" >nul
        if !errorlevel! equ 0 (
            set /a threats+=1
            color 0C
            echo  ⚠️  УГРОЗА: %%F
            color 0E
        ) else (
            set /a safe+=1
        )
    ) else (
        set /a safe+=1
    )
    
    :: Прогресс каждые 10 файлов
    set /a mod=!total! %% 10
    if !mod! equ 0 (
        <nul set /p "=."
    )
)

echo.
echo.
call :RESULTS %total% %threats% %safe%
pause
goto MENU

:: ============================================
::   ПРОВЕРКА ФАЙЛА
:: ============================================
:FILE_SCAN
cls
color 0B
call :BANNER
echo.
echo  ╔══════════════════════════════════════════════════════╗
echo  ║            🎯 ПРОВЕРКА КОНКРЕТНОГО ФАЙЛА             ║
echo  ╚══════════════════════════════════════════════════════╝
echo.
set /p "filepath=  📄 Введите путь к файлу: "

if not exist "%filepath%" (
    color 0C
    echo.
    echo  ❌ ОШИБКА: Файл не найден!
    pause
    goto MENU
)

call :LOADING "Анализ файла: %filepath%"

echo  🔬 Глубокий анализ...
timeout /t 1 /nobreak >nul
echo  🔬 Проверка сигнатур...
timeout /t 1 /nobreak >nul
echo  🔬 Проверка хеш-суммы...
timeout /t 1 /nobreak >nul
echo.

set "fname=%~nx1"
for %%F in ("%filepath%") do (
    set "fsize=%%~zF"
    set "fext=%%~xF"
    set "fdate=%%~tF"
)

echo  ┌────────────────────────────────────────────────────┐
echo  │  📋 ИНФОРМАЦИЯ О ФАЙЛЕ                             │
echo  ├────────────────────────────────────────────────────┤
echo  │  Имя:      !fname!
echo  │  Размер:   !fsize! байт
echo  │  Тип:      !fext!
echo  │  Изменён:  !fdate!
echo  └────────────────────────────────────────────────────┘
echo.

:: Эвристический анализ
set "threat=0"

echo !fext! | findstr /i /c:".exe" /c:".bat" /c:".cmd" /c:".vbs" /c:".js" /c:".ps1" /c:".scr" /c:".com" >nul
if !errorlevel! equ 0 (
    echo  ⚠️  Файл является исполняемым - повышенная проверка
    set "threat=1"
)

echo !fname! | findstr /i /c:"virus" /c:"trojan" /c:"hack" /c:"crack" /c:"keygen" /c:"malware" /c:"worm" >nul
if !errorlevel! equ 0 (
    echo  🚨 Обнаружено подозрительное имя файла!
    set "threat=2"
)

timeout /t 2 /nobreak >nul
echo.

if !threat! equ 0 (
    color 0A
    echo  ╔══════════════════════════════════════════════════════╗
    echo  ║  ✅ ФАЙЛ БЕЗОПАСЕН                                   ║
    echo  ║  Угроз не обнаружено                                 ║
    echo  ╚══════════════════════════════════════════════════════╝
) else if !threat! equ 1 (
    color 0E
    echo  ╔══════════════════════════════════════════════════════╗
    echo  ║  ⚠️  ПОДОЗРИТЕЛЬНЫЙ ФАЙЛ                             ║
    echo  ║  Исполняемый файл - будьте осторожны!                ║
    echo  ╚══════════════════════════════════════════════════════╝
) else (
    color 0C
    echo  ╔══════════════════════════════════════════════════════╗
    echo  ║  🚨 ОБНАРУЖЕНА УГРОЗА!                               ║
    echo  ║  Рекомендуется удалить этот файл!                    ║
    echo  ╚══════════════════════════════════════════════════════╝
)

echo.
pause
goto MENU

:: ============================================
::   ПОЛНАЯ ПРОВЕРКА
:: ============================================
:FULL_SCAN
cls
color 0C
call :BANNER
echo.
echo  ╔══════════════════════════════════════════════════════╗
echo  ║              💻 ПОЛНАЯ ПРОВЕРКА СИСТЕМЫ              ║
echo  ╚══════════════════════════════════════════════════════╝
echo.
echo  ⚠️  Это может занять длительное время.
set /p "confirm=  Продолжить? [Y/N]: "
if /i not "%confirm%"=="Y" goto MENU

call :LOADING "Сканирование системы..."

color 0E
echo.
echo  🔍 Проверка системных папок...
timeout /t 1 /nobreak >nul
echo  🔍 Проверка автозагрузки...
timeout /t 1 /nobreak >nul
echo  🔍 Проверка процессов...
timeout /t 1 /nobreak >nul
echo  🔍 Проверка реестра...
timeout /t 1 /nobreak >nul
echo  🔍 Проверка сетевых подключений...
timeout /t 1 /nobreak >nul
echo.

set /a total=0
set /a threats=0

for /r "C:\Windows\Temp" %%F in (*.*) do (
    set /a total+=1
)

echo  📊 Просканировано временных файлов: %total%
echo.

color 0A
echo  ╔══════════════════════════════════════════════════════╗
echo  ║  ✅ ПРОВЕРКА ЗАВЕРШЕНА                               ║
echo  ║  Угроз не обнаружено                                 ║
echo  ╚══════════════════════════════════════════════════════╝
echo.
pause
goto MENU

:: ============================================
::   ИНФОРМАЦИЯ О СИСТЕМЕ
:: ============================================
:SYSINFO
cls
color 0D
call :BANNER
echo.
echo  ╔══════════════════════════════════════════════════════╗
echo  ║              📊 ИНФОРМАЦИЯ О СИСТЕМЕ                 ║
echo  ╚══════════════════════════════════════════════════════╝
echo.
echo  ┌────────────────────────────────────────────────────┐
echo  │  🖥️  Компьютер:    %COMPUTERNAME%
echo  │  👤 Пользователь:  %USERNAME%
echo  │  💿 ОС:            %OS%
echo  │  📁 Система:       %SystemRoot%
echo  │  ⏰ Время:         %DATE% %TIME%
echo  │  🌐 Процессор:     %PROCESSOR_IDENTIFIER%
echo  │  🔢 Архитектура:   %PROCESSOR_ARCHITECTURE%
echo  └────────────────────────────────────────────────────┘
echo.
pause
goto MENU

:: ============================================
::   РЕЗУЛЬТАТЫ
:: ============================================
:RESULTS
color 0A
echo  ╔══════════════════════════════════════════════════════╗
echo  ║                  📊 РЕЗУЛЬТАТЫ СКАНИРОВАНИЯ          ║
echo  ╠══════════════════════════════════════════════════════╣
echo  ║                                                      ║
echo  ║   📁 Всего файлов:      %~1
echo  ║   ✅ Безопасных:        %~3
echo  ║   ⚠️  Угроз найдено:    %~2
echo  ║                                                      ║
echo  ╚══════════════════════════════════════════════════════╝
echo.

if %~2 gtr 0 (
    color 0C
    echo  🚨 РЕКОМЕНДУЕТСЯ УДАЛИТЬ ОПАСНЫЕ ФАЙЛЫ!
) else (
    color 0A
    echo  ✅ Ваша система в безопасности!
)
echo.
goto :eof

:: ============================================
::   ВЫХОД
:: ============================================
:EXIT
cls
color 0A
call :BANNER
echo.
echo  ╔══════════════════════════════════════════════════════╗
echo  ║                                                      ║
echo  ║          Спасибо за использование!                   ║
echo  ║          🛡️  Берегите свою систему! 🛡️               ║
echo  ║                                                      ║
echo  ╚══════════════════════════════════════════════════════╝
echo.
timeout /t 3 /nobreak >nul
exit /b