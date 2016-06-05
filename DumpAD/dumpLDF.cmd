@echo off
:: DumpLDF.cmd
::
:: Dumps current domain only and configuration and schema partitions
::
:: DJ - 1.0 - initial release

pushd %~dp0
whoami /all | findstr deny > nul
if errorlevel 1 goto :elevated
echo Please run with elevated privileges
goto :end
:elevated
whoami /all | findstr /R "\-512" > nul
if errorlevel 1 goto :nok
goto :admin
:nok
echo Please run with domain admin privileges
goto :end
:admin
set r=dummy-%random%.txt
echo "Test" > %r%
if exist %r% goto :writeok
echo Please make sure you have write access in %cd%
goto :end
:writeok
del %r% /q
ldifde -f %cd%\ad-schema.ldf -d "#schemaNamingContext" -j .
ren ldif.log ad-schema.log 
ldifde -f %cd%\ad-configuration.ldf -d "#configurationNamingContext" -j .
ren ldif.log ad-configuration.log 
ldifde -f %cd%\ad-data.ldf  -j .
ren ldif.log ad-data.log 
:end
popd