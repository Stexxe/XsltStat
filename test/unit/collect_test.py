import unittest
from nose.plugins.attrib import attr
from pymongo import MongoClient
from xsl_stat.collector import Collector
import os


class MyTestCase(unittest.TestCase):

    def setUp(self):
        dbname = 'test'

        self.client = MongoClient()
        self.db = self.client[dbname]
        current_dir = os.path.dirname(os.path.abspath(__file__))

        self.collector = Collector(os.path.join(current_dir, 'files'), self.db)

    def tearDown(self):
        for name in self.db.list_collection_names():
            coll = self.db.get_collection(name)
            coll.remove()

    @attr('slow')
    def test_collecting(self):
        self.db['process'].insert_one({'name': 'TestInterface', 'region': 'REGION'})
        self.collector.collect()

        stored_interface = self.db['interfaces'].find_one()

        self.assertEqual('TestInterface', stored_interface['name'])
        self.assertEqual('REGION', stored_interface['region'])
        self.assertTrue(self.db['process'].find_one()['success'])

        self.assertEqual('test:func', stored_interface['functions'][0]['name'])
        self.assertEqual('Number', stored_interface['templates'][0]['params'][0]['type'])






