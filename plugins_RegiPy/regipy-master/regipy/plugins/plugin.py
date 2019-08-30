import logbook

from regipy.registry import RegistryHive

PLUGINS = set()

logger = logbook.Logger(__name__)


class Plugin(object):

    NAME = None
    DESCRIPTION = None
    COMPATIBLE_HIVE = None

    def __init_subclass__(cls):
        PLUGINS.add(cls)

    def __init__(self, registry_hive: RegistryHive, as_json=False):
        self.registry_hive = registry_hive
        self.as_json = as_json

        # This variable should always hold the final result - in order to use it in anomaly detection and timeline gen.
        self.entries = list()

    def can_run(self):
        """
        Wether the plugin can run or not, according to specific checks
        :return:
        """
        return self.registry_hive.hive_type == self.COMPATIBLE_HIVE

    def run(self):
        """
        Execute the plugin
        :return:
        """

    def generate_timeline_artifacts(self):
        """
        Run on the output of a plugin and generate timeline entries
        :return:
        """
        pass

    def detect_anomalies(self):
        """
        Run on the output of a plugin and detect possible anomalies
        :return:
        """
        pass
