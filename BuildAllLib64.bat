@echo off

SET HMGPATH=%~dp0
SET PATH=%HMGPATH%harbour64\bin;%HMGPATH%mingw64\bin;%PATH%


cd SOURCE\hb_webview
hbmk2 hb_webview-64.hbp -i%hmgpath%\include
echo.


cd source\crypt
hbmk2 crypt-64.hbp -i%hmgpath%\include
echo.

cd..\..
cd source\edit
hbmk2 edit-64.hbp -i%hmgpath%\include
echo.

cd..\..
cd source\editex
hbmk2 editex-64.hbp -i%hmgpath%\include
echo.

cd..\..
cd source\graph
hbmk2 graph-64.hbp -i%hmgpath%\include
echo.

cd..\..
cd source\hbvpdf
hbmk2 hbvpdf-64.hbp -i%hmgpath%\include
echo.

cd..\..
cd source\ini
hbmk2 ini-64.hbp -i%hmgpath%\include
echo.

cd..\..
cd source\report
hbmk2 report-64.hbp -i%hmgpath%\include
echo.


cd..\..
cd hfcl\source
hbmk2 hfcl-64.hbp -i%hmgpath%\include -i%hmgpath%\hfcl\include
echo.

cd..\..
