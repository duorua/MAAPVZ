@echo off
chcp 65001 >nul
title MAAPVZ 游戏助手 - 启动中
color 0A

cd /d "%~dp0"

echo ========================================
echo   正在启动 Flask 服务...
echo ========================================

:: 后台启动 Flask，日志写入临时文件
call "..\..\.venv\Scripts\activate.bat"
start /b python pvz.py > flask.log 2>&1

:: 进度条最大长度（步数）
set MAX_STEPS=20
set STEP=0
set /p "=进度: [" <nul

:loop
:: 检测服务是否就绪
for /f %%i in ('curl -s -o nul -w "%%{http_code}" http://127.0.0.1:5000 2^>nul') do set CODE=%%i

if "%CODE%"=="200" (
    :: 填充剩余进度
    set /a REMAIN=%MAX_STEPS%-%STEP%
    for /l %%j in (1,1,!REMAIN!) do set /p "=#" <nul
    echo ] 服务就绪！

    :: 清屏，去掉所有进度条内容
    cls
    echo ========================================
    echo   Flask 服务已启动
    echo ========================================
    echo ----------------------------------------
    :: 使用 PowerShell 读取日志文件尾部
    powershell -Command "Get-Content flask.log -Tail 5"
    echo ----------------------------------------
    echo 完整日志请查看当前目录下的 flask.log
    echo.
    echo 正在打开浏览器...
    timeout /t 2 /nobreak >nul
    start http://127.0.0.1:5000
    exit /b
)

:: 进度推进
set /a STEP+=1
if %STEP% geq %MAX_STEPS% (
    echo ] 超时：服务启动失败，请检查 flask.log
    pause
    exit /b
)

set /p "=#" <nul
ping -n 1 -w 500 127.0.0.1 >nul
goto loop