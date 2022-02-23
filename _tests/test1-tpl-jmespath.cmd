@echo off
setlocal

SET ROOT=%~dp0

CALL %ROOT%_run.cmd . %ROOT%files\settings1.json -o template -t %ROOT%files\settings1-jmespath.tpl %*

endlocal