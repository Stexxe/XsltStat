import unittest
from nose.plugins.attrib import attr
from pymongo import MongoClient
from xsl_stat.entity import *
from xsl_stat.store import StoreEngine


class MyTestCase(unittest.TestCase):

    def setUp(self):
        dbname = 'test'

        self.client = MongoClient()
        self.db = self.client[dbname]
        self.engine = StoreEngine(self.client, dbname)

        self.inter = Interface()

    def tearDown(self):
        for name in self.db.list_collection_names():
            coll = self.db.get_collection(name)
            coll.remove()

    @attr('slow')
    def test_storing_interface_with_name(self):
        self.inter.name = 'Test'

        self.engine.store(self.inter)

        stored_inter = self.db['interfaces'].find_one()
        self.assertEqual('Test', stored_inter['name'])

    @attr('slow')
    def test_store_interface_with_region(self):
        self.inter.region = 'AMER'

        self.engine.store(self.inter)

        stored_inter = self.db['interfaces'].find_one()
        stored_region = self.db['regions'].find_one()

        self.assertEqual('AMER', stored_region['name'])
        self.assertEqual(stored_region['_id'], stored_inter['region'])

    @attr('slow')
    def test_store_interface_with_existed_region(self):
        inter1 = Interface()
        inter1.name = '1'
        inter1.region = 'AMER'

        inter2 = Interface()
        inter2.name = '2'
        inter2.region = 'AMER'

        self.engine.store(inter1)
        self.engine.store(inter2)

        stored_region = self.db['regions'].find_one()

        stored_inter1 = self.db['interfaces'].find_one({'name': '1'})
        stored_inter2 = self.db['interfaces'].find_one({'name': '2'})

        self.assertEqual(stored_region['_id'], stored_inter1['region'])
        self.assertEqual(stored_region['_id'], stored_inter2['region'])
