@echo off
echo Setting Execution Policy to RemoteSigned...
powershell -Command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force"

echo Setting Execution Policy to Unrestricted...
powershell -Command "Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force"

echo Running PowerShell script to modify ACLs...
powershell -Command ^
    "$profile = 'C:\Users\Default';" ^
    "$acl = Get-Acl $profile;" ^
    "$acl.SetAccessRuleProtection($true, $false);" ^
    "$rule1 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule('BUILTIN\Users', 'ReadAndExecute', 'ContainerInherit, ObjectInherit', 'None', 'Allow');" ^
    "$rule2 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule('Everyone', 'ReadAndExecute', 'ContainerInherit, ObjectInherit', 'None', 'Allow');" ^
    "$acl.SetAccessRule($rule1);" ^
    "$acl.SetAccessRule($rule2);" ^
    "Set-Acl -Path $profile -AclObject $acl -Verbose;"

echo Applying full control permission to Administrators in C:\Users\Default...
icacls "C:\Users\Default" /grant Administrators:(OI)(CI)F /T /C

echo Taking ownership of NTUSER.DAT and related files...
takeown /F "C:\Users\Default\NTUSER.DAT*" /A /R /D Y

echo Granting full control to Administrators for NTUSER.DAT and related files...
icacls "C:\Users\Default\NTUSER.DAT*" /grant Administrators:F /T /C

echo Deleting NTUSER.DAT and related files...
powershell -Command ^
    "Get-ChildItem -Path 'C:\Users\Default\' -Filter 'NTUSER.DAT*' | Remove-Item -Force;"

echo Copying NTUSER.DAT from C:\ to C:\Users\Default...
if exist "C:\NTUSER.DAT" (
    copy /Y "C:\NTUSER.DAT" "C:\Users\Default\NTUSER.DAT"
    echo NTUSER.DAT copied successfully!
) else (
    echo NTUSER.DAT file does not exist at C:\.
)

echo Script completed.
pause
