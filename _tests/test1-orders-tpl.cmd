@echo off
setlocal

SET ROOT=%~dp0

CALL %ROOT%_run.cmd "." %ROOT%files\orders.yaml -o template -t %ROOT%files\orders-report.tpl %*

endlocal