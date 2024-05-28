#description: Updates WinRAR via Chocolatey Package Manager (https://chocolatey.org/)
#execution mode: Combined
#tags: Nerdio, Apps Update, Chocolatey, AZRUSEDVDAPI013
<#
This script updates WinRAR via Chocolatey
#>

# Install Chocolatey if it isn't already installed
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Update WinRAR
choco upgrade winrar -y
