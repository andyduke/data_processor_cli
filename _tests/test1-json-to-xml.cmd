@echo off
setlocal

SET ROOT=%~dp0

CALL %ROOT%_run.cmd "users.user[*].{\"@id\": id, name: name} | {persons: {person: @}}" %ROOT%files\users.json -o xml %*

endlocal