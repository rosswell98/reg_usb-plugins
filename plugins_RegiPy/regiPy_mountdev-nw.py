from regipy.registry import RegistryHive
import sys
counter = 1

reg = RegistryHive(sys.argv[1])
regvalues = reg.get_key('System\MountedDevices').iter_values(as_json=True)
for value in regvalues:
	print(value)

"""
def run(self):	
	self.entries = {}
	mountdev_subkeys = self.registry_hive.get_control_sets(TZ_DATA_PATH)
	for mountdev_subkey in mountdev_subkeys:
		mountdev = self.registry_hive.get_key(mountdev_subkey)
		self.entries[mountdev_subkey] = [x for x in mountdev.iter_values(as_json=self.as_json)]
		
	if self.as_json:
		for k, v in self.entries.items():
		self.entries[k] = [attr.asdict(x) for x in v]
"""
