# PoisonHandler

lateral movement techniques that can be used during red team exercises.

# Execute-PoisonHandler.ps1

This technique is registering a protocol handler remotely and invoke it to execute arbitrary code on the remote host. The idea is to simply invoke `explorer handler://` to execute commands and evade detection.

This cmdlet create a protocol handler that will call your payload. Then execute it over `WMI` using `explorer.exe`.

the command that will be execute will look like the following one:

`explorer ms-browser://`

Where `ms-browser` is the custom handler you registered and will execute the payload you specified.

The default handler name is `ms-browser` but it can be set with the `-Handler` switch 

```
Usage:

module-import .\Execute-PoisonHandler.ps1; Execute-PoisonHandler -ComputerName host -Payload "command to run"
module-import .\Execute-PoisonHandler.ps1; Execute-PoisonHandler -ComputerName host -Payload "command to run" -Handler ms-handler-name 
module-import .\Execute-PoisonHandler.ps1; Execute-PoisonHandler -ComputerName host -Payload "command to run" -Username MrUn1k0d3r -Password Password
```

# Credit
Mr.Un1k0d3r RingZer0 Team

Tazz0 RingZer0 Team
