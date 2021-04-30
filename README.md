# Dynamics 365 Commerce Templates and Scripts

## Update Existing Hardware Stations
After deploying D365 Commerce hardware stations in Azure, it may be necessary to update the hardware station install with a new build. This can be accomplished by using the ARM template and PowerShell scripts in this repository.

### *Pre-Work*
1. Upload the hardware station installer to an Azure blob container and generate a read only SAS URL for the blob. Copy the SAS URL for use later.

2. Edit the HWSUpdate.ps1 script to include the following:
  * The SAS URL that was created in the previous step
  * The file name of the hardware station installer.exe. NOTE: This should be added to the "-OutputFile" section as well as the "Start-Process" section

3. Save the script and upload it to an Azure blob container

4. Generate a read only SAS URL for the script that was just uploaded. Copy the SAS URL for use later.

5. Create an Azure Key Vault if one does not exist and add the script SAS URL as a Key Vault secret.

6. Copy the ResourceId of the Key Vault from the "Properties" section of the Key Vault Blade for use later.

7. Edit the following items in the updateHWS-Parameters.json file
  * virtualMachineName array. This parameter can hold multiple values so that many VMs can be updated with a single deployment
  * keyVault id. This parameter should contain the Key Vault ID copied in a previous step
  * secretName. This is the name of the Key Vault secret containing the SAS URL for the HWSUpdate.ps1 script

8. Save the parameters file.

### *Deployment*
Deploy the ARM template using PowerShell

Connect-AzAccount
New-AzResourceGroupDeployment -Name updateHWS01 -ResourceGroupName 'Resoure Group Containing Hardware Stations' -TemplateFile 'Path to updateHWS.json' -TemplateParameterFile 'Path to updateHWS-Parameters.json' -Verbose
