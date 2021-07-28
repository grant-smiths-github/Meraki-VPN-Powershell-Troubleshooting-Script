

# Prevent Windows 10 problem with NAT-Traversal (often on hotspots)
# https://documentation.meraki.com/MX/Client_VPN/Troubleshooting_Client_VPN#Windows_Error_809
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\PolicyAgent"
$name = "AssumeUDPEncapsulationContextOnSendRule"
$value = "2"
Try {
    New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType DWORD -Force | Out-Null
}
Catch {
    Write-Host -ForegroundColor Red "`nUnable to create registry key, You must change the AssumeUDPEncapsulationContextOnSendRule value to 2 manually."
}

#Uninstall xbox service and game bar

Try {
Get-AppxPackage Microsoft.XboxApp | Remove-AppxPackage
Get-AppxPackage *xboxapp* | Remove-AppxPackage
Get-AppxPackage Microsoft.Xbox.TCUI | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxGameOverlay | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxGamingOverlay | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxIdentityProvider | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxSpeechToTextOverlay | Remove-AppxPackage
}
Catch {
    Write-Host -ForegroundColor Red "`nErrors occured while uninstalling xbox service and game bar"
}



#This is IPSec Policy Agent 
set-service PolicyAgent -startuptype automatic

#This is IKE and AuthIP IPsec Keying Modules
set-service IKEEXT -startuptype automatic

Restart-Service -DisplayName "IPSec Policy Agent*" 
Restart-Service -DisplayName "IKE and AuthIP IPsec Keying Modules" 


#turn off receive segement coalecing RSC for wifi adapter
Disable-NetAdapterRsc -Name Wi-Fi -IPv4


#Still need to remove WAN miniport driver

#Location of WAN miniport drivers:
#$WANMiniPortFolder = "Computer\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\"

    #step into each sub folder
    #search for WAN miniport string
    #if found, delete. 



#Disable ipv6 on network adapter for wifi and Ethernet 
Disable-NetAdapterBinding -Name Wi-Fi -ComponentID ms_tcpip6
Disable-NetAdapterBinding -Name Ethernet -ComponentID ms_tcpip6



#Set authentication method. 

#$VPNname =  = Read-Host -Prompt "`nName of VPN Connection, must be exact or will not work"

#Try { Get-VpnConnection -name  $VPNname | Set-VpnConnection -AuthenticationMethod PAP -EncryptionLevel "Optional" -PassThru

#}
#Catch {
#    Write-Host -ForegroundColor Yellow "`nUnable to change VPN encryption standards."
#}

#Check for windows updates
#Install-Module PSWindowsUpdate -a
#Get-WindowsUpdate
#Install-WindowsUpdate


#Restart pc
Write-Host -ForegroundColor Yellow "`nReboot computer to finish setup."




