Invoke-WebRequest -Uri 'Insert SAS URL to zip file here' -OutFile .\HWSDeployment.zip
Expand-Archive .\HWSDeployment.zip -DestinationPath C:\HWSDeployment

$MachineHostname = hostname
$CertThumbprint = (Get-ChildItem -Path Cert:LocalMachine\MY | where {$_.FriendlyName -eq "Insert Friendly Name of Certificate Here"}).Thumbprint
$HardwareStationRefRetailServerUrl = "Insert D365 Retail Server URL"
$FilePath = 'C:\HWSDeployment\hwsDeployment.xml'

[xml]$Values = Get-Content -Path $FilePath
$Values.configuration.appSettings.ChildNodes.Item(2).value = $CertThumbprint
$Values.configuration.appSettings.ChildNodes.Item(3).value = "$MachineHostname.Insert FQDN domain of the Hardware Station here (should also match the domain of the cert)"
$Values.configuration.appSettings.ChildNodes.Item(5).value = $HardwareStationRefRetailServerUrl
$Values.Save($FilePath)

Write-Output "Installing OPOS Common Control Objects..."

Start-Process msiexec.exe -Wait -ArgumentList '/I C:\HWSDeployment\OPOS_CCOs_1.14.001.msi /quiet /L*VI! C:\HWSDeployment\OPOS_installer_log.txt'

Get-Content C:\HWSDeployment\OPOS_installer_log.txt

Write-Output "Waiting for msiserver to exit..."

#Uncomment the below line if you are comfortable killing the MSI Server as soon as the OPOS CCO install finishes.
#Stop-Service msiserver
$(Get-Service msiserver).WaitForStatus("Stopped")

Write-Output "Installing Retail Hardware Station..."

Start-Process C:\HWSDeployment\Insert hardware station installer name here.exe -Wait -NoNewWindow -ArgumentList '-S -SkipMerchantInfo -C "C:\HWSDeployment\HWSDeployment.xml" -V -LogFile C:\HWSDeployment\HWS_installer_log.txt'

Get-Content C:\HWSDeployment\HWS_installer_log.txt
