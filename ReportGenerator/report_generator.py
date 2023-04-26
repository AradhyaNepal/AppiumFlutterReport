import datetime
from capabilities_and_url import capabilities


class FlutterReportGenerator:

    def __init__(self, capabilities):
        self.time = datetime.datetime.now()
        self.capabilities = capabilities
        self.testCaseData = []
        self.bookmark = []

    def generate_report(self):
        duration = datetime.datetime.now()-self.time




