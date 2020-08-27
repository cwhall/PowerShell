$Folder = Read-Host -Prompt "Folder where the msi is stored?"
$MSI = Read-Host -Prompt "File name of the msi?"
$Computers = Read-Host -Prompt "File path to .csv file with list of computers?"
$NetworkSharePath = Join-Path -Path $Folder -ChildPath $MSI 
$ImportedPath = Join-Path -Path "C:\Windows\Temp" -ChildPath $MSI

Import-Csv $Computers | ForEach-Object {
    Copy-Item -Path $NetworkSharePath -Destination (Join-Path -Path "\\" -ChildPath $($_.Name) | Join-Path -ChildPath "C$\Windows\Temp" | Join-Path -ChildPath $MSI)
    Invoke-Command -ComputerName $($_.Name) -ArgumentList $MSI -ScriptBlock {
        Start-Process -FilePath $using:ImportedPath -Wait -argumentlist '/quiet' 
    }
}
