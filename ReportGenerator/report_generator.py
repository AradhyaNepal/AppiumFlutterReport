import datetime
from driver import capabilities


class FlutterReportGenerator:

    def __init__(self, capabilities):
        self.time = datetime.datetime.now()
        self.capabilities = capabilities
        self.testCaseData = []
        self.bookmark = []

    def generate_report(self):
        duration = datetime.datetime.now()-self.time


report_generator = FlutterReportGenerator(capabilities)

