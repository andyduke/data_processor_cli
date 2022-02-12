@echo off
setlocal

SET ROOT=%~dp0

D:\Flutter2Live\dart run %ROOT%..\bin\data_processor.dart %*

endlocal