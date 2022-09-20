<#
    .Synopsis
    Changes the computer name and joins the computer to the domain
    
    .Description
    Changes the computer name based on the user input and automatically joins the computer to the brf.llc domain

    .Parameter ComputerName
    The name you want to computer to become

    .Example
    #Rename a computer and join it to the domain
    Join-Computer -Computername NCFOIT-BRR1234

#>
function Join-Computer{

    param(
        $ComputerName
    )

    Rename-Computer -NewName $ComputerName -Force
    Add-Computer -DomainName "brf.llc" -Force 

}


<#
    .Synopsis
    Installs required software to local machine

    .Description
    Installs required software using parameters to indicate required software

    .Parameter Storis
    Installs Storis ERP software

    .Parameter Teamviewer
    Installs Teamviewer

    .Parameter Documware
    Installs Docuware

    .Parameter Sophos
    Installs Sophos

    .Parameter Chrome
    Installs Chrome

    .Parameter Mitel
    Installs Mitel

    .Parameter Java
    Installs Java

    .Example
    #Install Chrome and Java
    Install-Software -Chrome -Java

#>
function Install-Software{

    param(
        $Storis,
        $Teamviewer,
        $Docuware,
        $Sophos,
        $Chrome,
        $Mitel,
        $Java,
        $AnyConnect
    )
    
    if ($PSBoundParameters.ContainsKey('Storis')) {
            Start-Process -Wait -FilePath .\Software\ -ArgumentList "/S" -PassThru
        }
    if ($PSBoundParameters.ContainsKey('Teamviewer')){
            Start-Process -Wait -FilePath .\Software\TeamViewer_Host_Setup.exe -ArgumentList "/S" -PassThru
        }
    if ($PSBoundParameters.ContainsKey('Docuware')){
            Start-Process -Wait -FilePath .\Software\> -ArgumentList "/S" -PassThru
        }
    if ($PSBoundParameters.ContainsKey('Sophos')){
            Start-Process -Wait -FilePath .\Software\SophosSetup.exe -ArgumentList "/S" -PassThru
        }
    if ($PSBoundParameters.ContainsKey('Chrome')){
            Start-Process -Wait -FilePath .\Software\ChromeSetup.exe -ArgumentList "/S" -PassThru
        }
    if ($PSBoundParameters.ContainsKey('Mitel')){
            Start-Process -Wait -FilePath .\Software\MitelConnect.exe -ArgumentList "/S" -PassThru
        }
    if ($PSBoundParameters.ContainsKey('Java')){
            Start-Process -Wait -FilePath .\Software\jre-8u291-windows-x64 -ArgumentList "/S" -PassThru
        }
    if ($PSBoundParameters.ContainsKey('AnyConnect')){
            Start-Process -Wait -FilePath .\anyconnect-win-4.10.05085-core-vpn-predeploy-k9.msi -ArgumentList "/S" -PassThru
        }

}

<#
    .Synopsis
    Changes the basic computer settings of Windows 11

    .Description
    Changes the power settings and start layout of Windows 11

#>
function Change-Settings{

    #Export a start layout and import it here
    Import-StartLayout -Path \.layout.xml
    powercfg /import .\scheme.pow    


}

<#
    .Synopsis
    Exports the start layout and power configuration of local machine

    .Description
    Allows you to export configuration settings which can be applied to another machine with Change-Settings
#>
function Export-Settings{
    Export-StartLayout -Path .\layout.xml
    powercfg /export .\scheme.pow
}


Export-ModuleMember -Function Join-Computer, Install-Software, Change-Settings, Export-Settings