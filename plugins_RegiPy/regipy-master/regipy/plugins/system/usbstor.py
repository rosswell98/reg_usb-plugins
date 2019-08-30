"""
--------------------RESULTAT ATTENDU-------------------------

Disk&Ven_JetFlash&Prod_Transcend_16GB&Rev_1100 [Wed Jun 26 19:34:59 2019]
  S/N: 17GIWK3QFAF50DSD&0 [Wed Jun 26 19:34:59 2019]
  Device Parameters LastWrite: [Wed Jun 26 19:34:59 2019]
  LogConf LastWrite          : [Wed Jun 26 19:34:59 2019]
  Properties LastWrite       : [Wed Jun 26 19:34:59 2019]
    FriendlyName    : JetFlash Transcend 16GB USB Device
    InstallDate     : Mon Oct  9 08:42:44 2017 UTC
    FirstInstallDate: Mon Oct  9 08:42:44 2017 UTC
    """

from regipy.registry import RegistryHive
reg = RegistryHive('SYSTEM')

print("-------------USBSTOR-----------")
print("FORENSIC de l'historique des peripheriques USB")
print("Version 1.0, ATK \n\n")

#for entry in reg.recurse_subkeys(as_json=True):
#    print(entry)

reg.get_key('SYSTEM\CurrentControlSet001\Enum\USBSTOR').get_values(as_json=True)
