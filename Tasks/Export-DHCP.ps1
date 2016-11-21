# PS 2 and 3
if (!$PSScriptRoot){
 $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
}
$date = Get-Date
$dateold = $date.AddDays(-7)

$backupfolder = Join-Path $PSScriptRoot 'DHCPBackup'
if (!(Test-Path $backupfolder)) {
  New-Item $backupfolder -ItemType Directory -Force
}
$datefmt = (Get-Date -Format o) -replace '\W',''
$filename = Join-Path $backupfolder "Export-DHCPServer-$datefmt.xml"

Export-DhcpServer -File $filename -Leases

Get-ChildItem -Path $backupfolder -Include *.xml | Where-Object { $_.LastWriteTime -le $dateold} | Remove-Item -Force