@echo off
setlocal
pushd "%~dp0" || exit /b 1

if not exist build mkdir build

lualatex -file-line-error -interaction=nonstopmode -synctex=1 -output-directory=build main.tex
if errorlevel 1 goto :fail

biber build/main
if errorlevel 1 goto :fail

lualatex -file-line-error -interaction=nonstopmode -synctex=1 -output-directory=build main.tex
if errorlevel 1 goto :fail

lualatex -file-line-error -interaction=nonstopmode -synctex=1 -output-directory=build main.tex
if errorlevel 1 goto :fail

echo.
echo PDF written to build\main.pdf
popd
exit /b 0

:fail
set RESULT=%errorlevel%
popd
exit /b %RESULT%
