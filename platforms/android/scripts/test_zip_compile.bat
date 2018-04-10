REM @ECHO OFF
IF NOT "%1%"=="" GOTO START_TEST
ECHO USAGE: %0% zip_file_name
GOTO END
@ECHO ON

:START_TEST
SET SCRIPT_PATH=%~dp0

SET PROGRAMFILES_DIR_X86=%programfiles(x86)%
if NOT EXIST "%PROGRAMFILES_DIR_X86%" SET PROGRAMFILES_DIR_X86=%programfiles%
SET PROGRAMFILES_DIR=%programfiles%

REM Find Visual Studio or Msbuild
SET VS2005="%VS80COMNTOOLS%..\IDE\devenv.com"
SET VS2008="%VS90COMNTOOLS%..\IDE\devenv.com"
SET VS2010="%VS100COMNTOOLS%..\IDE\devenv.com"
SET VS2012="%VS110COMNTOOLS%..\IDE\devenv.com"
SET VS2013="%VS120COMNTOOLS%..\IDE\devenv.com"
SET VS2015="%VS140COMNTOOLS%..\IDE\devenv.com"

SET VS2017="%PROGRAMFILES_DIR_X86%\Microsoft Visual Studio\2017\Community\Common7\IDE\devenv.com"
IF EXIST "%PROGRAMFILES_DIR_X86%\Microsoft Visual Studio\2017\Professional\Common7\IDE\devenv.com" SET VS2017="%PROGRAMFILES_DIR_X86%\Microsoft Visual Studio\2017\Professional\Common7\IDE\devenv.com"
IF EXIST "%PROGRAMFILES_DIR_X86%\Microsoft Visual Studio\2017\Enterprise\Common7\IDE\devenv.com" SET VS2017="%PROGRAMFILES_DIR_X86%\Microsoft Visual Studio\2017\Enterprise\Common7\IDE\devenv.com"
IF EXIST "%VS2017INSTALLDIR%\Common7\IDE\devenv.com" SET VS2017="%VS2017INSTALLDIR%\Common7\IDE\devenv.com"
IF EXIST "%VS150COMNTOOLS%..\IDE\devenv.com" SET VS2017="%VS150COMNTOOLS%..\IDE\devenv.com"

IF EXIST "%windir%\Microsoft.NET\Framework\v3.5\MSBuild.exe" SET MSBUILD35=%windir%\Microsoft.NET\Framework\v3.5\MSBuild.exe
IF EXIST "%windir%\Microsoft.NET\Framework64\v3.5\MSBuild.exe" SET MSBUILD35=%windir%\Microsoft.NET\Framework64\v3.5\MSBuild.exe
IF EXIST "%windir%\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe" SET MSBUILD40=%windir%\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe

IF EXIST "%MSBUILD35%" SET DEVENV="%MSBUILD35%"
IF EXIST "%MSBUILD40%" SET DEVENV="%MSBUILD40%"
IF EXIST %VS2005% SET DEVENV=%VS2005% 
IF EXIST %VS2008% SET DEVENV=%VS2008%
IF EXIST %VS2010% SET DEVENV=%VS2010%
IF EXIST %VS2012% SET DEVENV=%VS2012%

IF EXIST %VS2013% SET DEVENV=%VS2013%
IF EXIST %VS2015% SET DEVENV=%VS2015%
IF EXIST %VS2017% SET DEVENV=%VS2017%


:SET_BUILD_TYPE
IF %DEVENV%=="%MSBUILD35%" SET BUILD_TYPE=/property:Configuration=Release
IF %DEVENV%=="%MSBUILD40%" SET BUILD_TYPE=/property:Configuration=Release
IF %DEVENV%==%VS2005% SET BUILD_TYPE=/Build "Release|Any CPU"
IF %DEVENV%==%VS2008% SET BUILD_TYPE=/Build "Release|Any CPU"
IF %DEVENV%==%VS2010% SET BUILD_TYPE=/Build "Release|Any CPU"
IF %DEVENV%==%VS2012% SET BUILD_TYPE=/Build "Release|Any CPU"
IF %DEVENV%==%VS2013% SET BUILD_TYPE=/Build "Release|Any CPU"
IF %DEVENV%==%VS2015% SET BUILD_TYPE=/Build "Release|Any CPU"
IF %DEVENV%==%VS2017% SET BUILD_TYPE=/Build "Release|Any CPU"

IF %DEVENV%=="%MSBUILD35%" SET CMAKE_CONF="Visual Studio 12 2005%OS_MODE%"
IF %DEVENV%=="%MSBUILD40%" SET CMAKE_CONF="Visual Studio 12 2005%OS_MODE%"
IF %DEVENV%==%VS2005% SET CMAKE_CONF="Visual Studio 8 2005%OS_MODE%"
IF %DEVENV%==%VS2008% SET CMAKE_CONF="Visual Studio 9 2008%OS_MODE%"
IF %DEVENV%==%VS2010% SET CMAKE_CONF="Visual Studio 10%OS_MODE%"
IF %DEVENV%==%VS2012% SET CMAKE_CONF="Visual Studio 11%OS_MODE%"
IF %DEVENV%==%VS2013% SET CMAKE_CONF="Visual Studio 12%OS_MODE%"
IF %DEVENV%==%VS2015% SET CMAKE_CONF="Visual Studio 14%OS_MODE%"
IF %DEVENV%==%VS2017% SET CMAKE_CONF="Visual Studio 15%OS_MODE%"

IF EXIST tmp rm -rf tmp
mkdir tmp
SET ZIP_FILE_NAME=%1%
cp %ZIP_FILE_NAME% tmp/
cd tmp
unzip %ZIP_FILE_NAME%
cd libemgucv-android\Solution\Android
%SCRIPT_PATH%..\..\..\miscellaneous\nuget.exe restore Emgu.CV.Android.Example.sln
call %DEVENV% %BUILD_TYPE% Emgu.CV.Android.Example.sln 
cd ..\..\..\..

:END