@echo off
setlocal

SET ROOT=%~dp0

pushd %ROOT%..
D:\Flutter2Live\dart compile exe -o %ROOT%binary\dp.exe bin\data_processor.dart
popd

endlocal