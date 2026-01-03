# run.ps1 - Quick start script for the Crop Recommendation app
# Usage (PowerShell):
#   .\run.ps1
# If execution is blocked, run:
#   powershell -ExecutionPolicy Bypass -NoProfile -File .\run.ps1

$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $ProjectRoot

$python = Join-Path $ProjectRoot '.venv\Scripts\python.exe'
$reqFile = Join-Path $ProjectRoot 'requirements.txt'
$hashFile = Join-Path $ProjectRoot '.venv\reqhash'

if (-not (Test-Path $python)) {
    Write-Output 'Virtualenv not found - creating .venv with Python 3.11...'
    py -3.11 -m venv .venv
    & .\.venv\Scripts\python.exe -m pip install --upgrade pip setuptools wheel
    Write-Output 'Installing project dependencies...'
    & .\.venv\Scripts\python.exe -m pip install -r requirements.txt --prefer-binary --timeout 120 --retries 10
    if (Test-Path $reqFile) {
        $hash = (Get-FileHash $reqFile -Algorithm SHA256).Hash
        $hash | Out-File $hashFile -Encoding ASCII
    }
} else {
    if (Test-Path $reqFile) {
        $currentHash = (Get-FileHash $reqFile -Algorithm SHA256).Hash
        $prevHash = ''
        if (Test-Path $hashFile) { $prevHash = (Get-Content $hashFile -Raw).Trim() }
        if ($currentHash -ne $prevHash) {
            Write-Output 'requirements.txt changed or new - installing/refreshing dependencies...'
            & .\.venv\Scripts\python.exe -m pip install -r requirements.txt --prefer-binary --timeout 120 --retries 10
            $currentHash | Out-File $hashFile -Encoding ASCII
        } else {
            Write-Output 'Virtualenv and dependencies are up-to-date.'
        }
    } else {
        Write-Output 'requirements.txt not found; skipping dependency check.'
    }
}

Write-Output ('Starting app using: ' + $python)
& .\.venv\Scripts\python.exe app.py
