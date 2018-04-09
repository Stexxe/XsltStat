import os.path
from xsl_stat.store import StoreEngine
from xsl_stat.parser import Parser


class Collector:

    def __init__(self, source_dir, db):
        self.source_dir = source_dir
        self.db = db
        self.store_engine = StoreEngine(db)

    def collect(self):
        to_process = self.db['process'].find({'success': None}).sort([('name', 1)])

        for one in to_process:
            try:
                filename = one['name'] + '.xsl'
                xslt_file = os.path.join(self.source_dir, one['name'], 'xsl', filename)

                if os.path.exists(xslt_file):
                    interface = Parser.parse(xslt_file)
                    interface.name = one['name']
                    interface.region = one['region']

                    self.store_engine.store(interface)
                    self._update_processed(one)
            except BaseException as e:
                print(one['name'], ' ', e.__traceback__)


    def _update_processed(self, info):
        data = {
            'name': info['name'],
            'region': info['region'],
            'success': True
        }

        self.db['process'].update({'name': info['name']}, data)