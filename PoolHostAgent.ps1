 ###This is a script pieced together from public information provided on how to add VM's to a hostpool in Azure.     

###Here's the source website, https://learn.microsoft.com/en-us/azure/virtual-desktop/add-session-hosts-host-pool?tabs=powershell%2Ccmd

$token = Get-Content "C:\DeploymentScripts\token.txt"
   
    $uris = @(
    "https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RWrmXv",
    "https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RWrxrH"
)

$installers = @()
foreach ($uri in $uris) {
    $download = Invoke-WebRequest -Uri $uri -UseBasicParsing
    $fileName = [System.IO.Path]::GetFileName(($download.Headers.'Content-Disposition').Split('=')[1].Replace('"',''))
    $output = [System.IO.FileStream]::new("$pwd\$fileName", [System.IO.FileMode]::Create)
    $output.Write($download.Content, 0, $download.RawContentLength)
    $output.Close()
    $installers += $fileName
}



    foreach ($installer in $installers) 
        If ($installer -match 'RDAgent.Installer') {
            $AgentInstaller = $installer
            Write-Host "Agent Installer detected. File name is \$AgentInstaller."
            Unblock-File -Path $AgentInstaller
            Move-Item -Path $AgentInstaller -Destination 'C:\DeploymentScripts' -Force

            cmd /c "msiexec /i `"C:\DeploymentScripts\$AgentInstaller`" /quiet REGISTRATIONTOKEN=`"C:\DeploymentScripts\token.txt`""
        } Else {
            $BootAgentInstaller = $installer
            Write-Host "Boot Agent Installer detected. File name is \$BootAgentInstaller."
            Unblock-File -Path $BootAgentInstaller
            Move-Item -Path $BootAgentInstaller -Destination 'C:\DeploymentScripts' -Force

            cmd /c "msiexec /i `"C:\DeploymentScripts\$BootAgentInstaller`" /quiet"

        }

