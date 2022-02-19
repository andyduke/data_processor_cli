@echo off
setlocal

SET ROOT=%~dp0

CALL %ROOT%_run.cmd "users" %ROOT%files\sample1.json -v -o csv --output-csv-col-sep="<tab>" --output-csv-headers="perms<tab>path<tab>name" %*

endlocal