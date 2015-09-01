@echo off
setlocal

cd /d "%~dp0"
set TZ=UTC
ruby ..\lib\compile.rb

endlocal
