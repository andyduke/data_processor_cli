@echo off
setlocal

SET ROOT=%~dp0

CALL %ROOT%_run.cmd "users[*].name" %ROOT%files\sample1.json %*

endlocal