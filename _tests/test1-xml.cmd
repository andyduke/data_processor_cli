@echo off
setlocal

SET ROOT=%~dp0

CALL %ROOT%_run.cmd "users[*].name" %ROOT%files\sample1.json -o xml --output-xml-root-node=user --output-xml-declaration="" %*

endlocal