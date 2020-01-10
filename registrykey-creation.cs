using System;
using System.Management;

namespace RegistryEdit
{
    class Program
    {
        static void Main(string[] args)
        {
            ConnectionOptions co = new ConnectionOptions();
            co.Username = args[0];
            co.Password = args[1];
            string target = args[2];
            string handler = args[3];
            string command = args[4];

            ManagementScope ms = new ManagementScope("\\\\" + target + "\\root\\default");
            if (!args[0].Equals(""))
            {
                ms.Options = co;
            }

            ManagementClass mc = new ManagementClass(ms, new ManagementPath("StdRegProv"), null);

            ManagementBaseObject mbo = mc.GetMethodParameters("SetStringValue");

            mbo["hDefKey"] = 2147483649;
            mbo["sSubKeyName"] = "Software\\Classes\\" + handler;
            mbo["sValue"] = "URL: " + handler;
            mbo["sValueName"] = "URL Protocol";
            mc.InvokeMethod("CreateKey", mbo, null);
            mc.InvokeMethod("SetStringValue", mbo, null);
            mc.GetMethodParameters("SetStringValue");

            mbo["sSubKeyName"] = "Software\\Classes\\" + handler + "\\shell\\open\\command";
            mbo["sValue"] = command;
            mc.InvokeMethod("CreateKey", mbo, null);
            mc.InvokeMethod("SetStringValue", mbo, null);
        }
    }
}
