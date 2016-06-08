@echo off
c:\progra~3\dev-pas\bin\ldw.exe  E:\WORKING\TEKKOM\rsrc.o -s   -o e:\working\tekkom\project.exe link.res exp.$$$
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occured while assembling %THEFILE%
goto end
:linkend
echo An error occured while linking %THEFILE%
:end
