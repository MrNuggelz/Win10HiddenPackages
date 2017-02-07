param  (
	[string]$name,
	[switch]$list
)
$CBSPath = "hklm:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\"
foreach ($element in Get-ChildItem -Path $CBSPath)
{
	if ($element.pschildname -match $name) {
		$psname = $element.pschildname
		if ($list) {
			$psname
		}
		else {
			$message  = -join('deleting ',$psname)
			$question = 'Are you sure you want to proceed?'
			$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
			$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
			$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
			$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
			if ($decision -eq 0) {		
				-join("unhiding: ",$psname)
				$path = -join("SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\", $psname)
				# get permissions
				$key = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey($path,[Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree,[System.Security.AccessControl.RegistryRights]::ChangePermissions)
				$acl = $key.GetAccessControl()
				$rule = New-Object System.Security.AccessControl.RegistryAccessRule ("BUILTIN\Administrators","FullControl","ObjectInherit,ContainerInherit","None","Allow")
				$acl.SetAccessRule($rule)
				$key.SetAccessControl($acl)
				
				# save default value
				if ((Get-ItemProperty -Path $element.pspath -Name DefVis) -eq $null)
				{
					$defVis = (Get-ItemProperty -Path $element.pspath).Visibility
					"saving default visibility"
					New-ItemProperty -Path $element.pspath -Name DefVis -PropertyType DWord -Value $defVis
				}
				Set-ItemProperty -Path $element.pspath -Name Visibility -Value 1
				
				#delete owners folder
				$owners = -join ($element.pspath,"\Owners")
				"deleting owners"
				if (Test-Path $owners){
					Remove-Item -Path $owners
				}
				
				# remove package with dism
				dism.exe /Online /Remove-Package /PackageName:$psname
			}
		}
	}
}
