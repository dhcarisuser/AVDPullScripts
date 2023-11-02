REM Batch file to accompany Powershell script

REM Run the Powershell script
powershell -ExecutionPolicy Bypass -File "%~dp0PoolHostAgent.ps1"

REM Delete all files in the folder including batch script and restart the computer

del /Q "%~dp0*.*"
REM Self-delete this batch file and hutdown command with a 2-minute countdown (120 seconds)

shutdown /r /t 120 & del /Q "%~dp0%~nx0"