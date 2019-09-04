import logbook

from regipy.hive_types import SYSTEM_HIVE_TYPE
from regipy.plugins.plugin import Plugin

logger = logbook.Logger(__name__)

MOUNTDEV_PATH = r'MountedDevices'

class MountDevPlugin(Plugin):
    NAME = 'mountdev'
    DESCRIPTION = 'Get Mounted Devices'

    def can_run(self):
        return self.registry_hive.hive_type == system

    def run(self):
        logger.info('Started Mounted Devices Plugin...')

        self.entries = {}
        mountdev_subkeys = self.registry_hive.get_control_sets(MOUNTDEV_PATH)
        for mountdev_subkey in mountdev_subkeys:
            mountdev = self.registry_hive.get_key(mountdev_subkey)
            self.entries[mountdev_subkey] = [x for x in mountdev.iter_values(as_json=self.as_json)]

        if self.as_json:
            for k, v in self.entries.items():
                self.entries[k] = [attr.asdict(x) for x in v]
        raise NotImplementedError
