import logbook

from regipy.hive_types import SYSTEM_HIVE_TYPE
from regipy.plugins.plugin import Plugin
from regipy.utils import get_subkey_values_from_list

#logger = logbook.Logger(__name__)
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

class TemplatePlugin(Plugin):
    NAME = 'usbstor'
    DESCRIPTION = 'Enumere les connexions USB'

    def can_run(self):
        # TODO: Choose the relevant condition - to determine if the plugin is relevant for the given hive
        return self.registry_hive.hive_type == SYSTEM_HIVE_TYPE

    def run(self):
        # TODO: Return the relevant values
        raise NotImplementedError
