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

Start-Process msiexec.exe -Wait -ArgumentList '/I C:\HWSDeployment\OPOS_CCOs_1.14.001.msi /quiet'

Start-Process C:\HWSDeployment\Insert hardware station installer name here.exe -Wait -ArgumentList '-S -SkipMerchantInfo -C "C:\HWSDeployment\HWSDeployment.xml"'