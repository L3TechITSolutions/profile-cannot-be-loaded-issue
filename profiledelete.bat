@echo off
:: Batch file to delete .bak profiles and TEMP profiles

echo Deleting .bak profiles from registry...
reg load HKLM\TempHive "C:\Users\Default\NTUSER.DAT" 2>nul

for /f "tokens=*" %%A in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" /s /f ".bak"') do (
    echo Deleting %%A...
    reg delete "%%A" /f
)

echo .bak profiles deleted from registry.

:: Deleting temporary profile folders from C:\Users
echo Deleting TEMP profile folders...
for /d %%D in (C:\Users\TEMP*) do (
    echo Deleting %%D...
    rmdir /s /q %%D
)

for /d %%D in (C:\Users\*.*.PU*) do (
    echo Deleting %%D...
    rmdir /s /q %%D
)

echo TEMP profiles and folders deleted.

pause
