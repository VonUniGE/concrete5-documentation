@echo off
setlocal

cd /d "%~dp0"
set TZ=UTC
set CLASSPATH=%CLASSPATH%;%~dp0..\lib\saxon\saxon.jar;%~dp0..\lib\docbook-xsl\extensions\saxon65.jar;%~dp0..\lib\xslthl\xslthl.jar
ruby ..\lib\compile.rb

endlocal
