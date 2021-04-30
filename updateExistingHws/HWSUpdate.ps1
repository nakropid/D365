Invoke-WebRequest -Uri 'Insert SAS URL to updated Hardware Station installer file here' -OutFile C:\HWSDeployment\'Insert Hardware Station File Name.exe'

Start-Process C:\HWSDeployment\'Insert Hardware Station File Name.exe' -Wait -ArgumentList '-S -SkipMerchantInfo'