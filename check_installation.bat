@echo off
REM Check if Docker Desktop is installed
echo Checking if Docker Desktop is installed...
where docker >nul 2>&1
if %errorlevel% neq 0 (
    echo Docker Desktop is not installed.
) else (
    echo Docker Desktop is installed.
)

REM Check if Postman is installed by checking its version
echo Checking if Postman is installed...
for /f "tokens=*" %%i in ('postman -version 2^>nul') do (
    set postman_version=%%i
)

if defined postman_version (
    echo Postman is installed: %postman_version%
) else (
    echo Postman is not installed or not found in the system PATH.
)

REM Check if Visual Studio Code is installed
echo Checking if Visual Studio Code is installed...
where code >nul 2>&1
if %errorlevel% neq 0 (
    echo Visual Studio Code is not installed.
) else (
    echo Visual Studio Code is installed.
)

REM Execute a curl command to post the contents of testpost.json to the specified URL
echo Executing curl command to post testpost.json to HTTP://localhost/test...
curl -X POST -H "Content-Type: application/json" -d @testpost.json "http://localhost/test"
if %errorlevel% neq 0 (
    echo Failed to execute curl command.
) else (
    echo Curl command executed successfully.
)

pause
