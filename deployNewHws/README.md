# Dynamics 365 Commerce Templates and Scripts

## Deploy New Hardware Stations
The ARM template and PowerShell scripts in this repository will deploy Dynamics 365 Commerce Hardware Stations that can be paired with Dynamics 365 Commerce Cloud Point of Sale

### *Pre-Work*
1. The hardware station installer is not available as a public download. Follow the instructions outlined in [this doc](https://docs.microsoft.com/en-us/dynamics365/commerce/retail-hardware-station-configuration-installation#download-the-retail-hardware-station-installer) to download the executable from your Dynamics 365 Commerce tenant.

2. The OPOS Common Control Objects are also a requirement to install hardware station. I am providing the installer as part of this GitHub respository, but it can also be downloaded from the Monroe Consulting Services [website](http://monroecs.com/oposccos_current.htm).

3. Create a zip file containing the following items:
  * The hardware station installer
  * The OPOS installer
  * The hwsDeployment.xml file from this respository

4. Upload the zip file to an Azure blob container and generate a read only SAS URL for the blob. Copy the SAS URL for use later.

5. The hardware station installer requires an SSL certificate for HTTPS communication. The certificate must use private key storage, and server authentication must be listed in the enhanced key usage property. Additionally, the certificate must be trusted locally, and it can't be expired. This information is referenced in [this doc](https://docs.microsoft.com/en-us/dynamics365/commerce/retail-hardware-station-configuration-installation#run-the-installer). Upload your SSL certificate to Azure Key Vault using the process outlined in [this doc](https://docs.microsoft.com/en-us/azure/key-vault/certificates/tutorial-import-certificate#import-a-certificate-to-key-vault).

6. Download the HWSDeployment.ps1 script found in this repository and edit the script to include the following:
  * The SAS URL that was created in step 4. This should be filled in on line 1 where it says 'Insert SAS URL to zip file here'
  * The friendly name of the SSL certificate that was uploaded to Azure Key Vault in step 5. This should be filled in on line 5 where is says "Insert Friendly Name of Certificate Here"
  * Your D365 Retail Server URL. This should be filled in on line 6 where is says "Insert D365 Retail Server URL"
  * The FQDN of the domain the hardware stations are being joined to. This should be filled in on line 11 where is says "Insert FQDN domain of the Hardware Station here (should also match the domain of the cert)"
  * The name of the hardware station executable. This should be filled in on line 17 where is says "Insert hardware station installer name here"

7. Save the script, upload it to an Azure blob container and generate a read only SAS URL for the blob. Copy the SAS URL for use later.

8. Add the script SAS URL as a Key Vault secret using the process outlined in [this doc](https://docs.microsoft.com/en-us/azure/key-vault/secrets/quick-create-portal#add-a-secret-to-key-vault). This is similar to the process used in step 5, but instead of adding a certificate, we are adding a secret.

### *Deployment*
Download deployHWS-Parameters.json file from this respository and edit the values to align with your Azure environment.

Deploy the ARM template using PowerShell

    Connect-AzAccount
    New-AzResourceGroupDeployment -Name deployHWS01 -ResourceGroupName 'Resoure Group Containing Hardware Stations' -TemplateFile 'Path to deployHWS.json' -TemplateParameterFile 'Path to deployHWS-Parameters.json' -Verbose
