@echo off
setlocal
pushd %~dp0

CALL build.cmd
pkzipc -max -add dp-windows.zip binary\dp.exe

popd
endlocal