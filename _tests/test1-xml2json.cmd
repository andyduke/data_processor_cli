@echo off
setlocal

SET ROOT=%~dp0

CALL %ROOT%_run.cmd "." %ROOT%files\sample1.xml -o json %*

endlocal