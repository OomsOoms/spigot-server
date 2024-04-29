@echo off
setlocal

REM Get current date and time in YYYY-MM-DD_HHMMSS format
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set "itdatetime=%%I"
set "itdate=%itdatetime:~0,4%-%itdatetime:~4,2%-%itdatetime:~6,2%"
set "ittime=%itdatetime:~8,2%-%itdatetime:~10,2%-%itdatetime:~12,2%"

REM Set backup directory path (one level back)
set "backup_dir=%~dp0..\backups\%itdate%_%ittime%"

REM Create backup directory if it doesn't exist
if not exist "%backup_dir%" mkdir "%backup_dir%"

REM Print backup directory to console
echo Backups will be stored in: %backup_dir%

REM Copy world, world_nether, and world_the_end directories
xcopy /E /C /H /I /V /R /Y /Q "world" "%backup_dir%\world"
xcopy /E /C /H /I /V /R /Y /Q "world_nether" "%backup_dir%\world_nether"
xcopy /E /C /H /I /V /R /Y /Q "world_the_end" "%backup_dir%\world_the_end"

REM Copy plugins directory if it exists
if exist "plugins" (
    xcopy /E /C /H /I /V /R /Y /Q "plugins" "%backup_dir%\plugins"
)

REM Delete older backup versions if needed (keeping only the last 5 backups)
for /f "skip=5 delims=" %%F in ('dir /AD /B /O-N "%~dp0..\backups\*"') do (
    echo Deleting old backup: %%F
    rd /S /Q "%~dp0..\backups\%%F"
)

echo Backup completed successfully.
pause
