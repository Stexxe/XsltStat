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
        self.engine = StoreEngine(self.db)

        self.inter = Interface()

    def tearDown(self):
        for name in self.db.list_collection_names():
            coll = self.db.get_collection(name)
            coll.remove()

    @attr('slow')
    def test_storing_interface_base_info(self):
        self.inter.name = 'Test'
        self.inter.region = 'AMER'

        self.engine.store(self.inter)
        stored_inter = self.db['interfaces'].find_one()

        self.assertEqual('Test', stored_inter['name'])
        self.assertEqual('AMER', stored_inter['region'])

    @attr('slow')
    def test_storing_templates(self):
        param = Param()
        param.name = 'param1'
        param.type = Type.STRING

        template = Template()
        template.name = 'conv'
        template.add_param(param)
        self.inter.add_template(template)

        self.engine.store(self.inter)
        stored_templates = self.db['interfaces'].find_one()['templates']

        self.assertEqual('conv', stored_templates[0]['name'])
        self.assertEqual('String', stored_templates[0]['params'][0]['type'])
        self.assertEqual('param1', stored_templates[0]['params'][0]['name'])

    @attr('slow')
    def test_storing_functions(self):
        param = Param()
        param.pos = 0
        param.type = Type.NUMBER

        func = Func()
        func.name = 'example:func'
        func.add_param(param)
        self.inter.add_func(func)

        self.engine.store(self.inter)
        stored_funcs = self.db['interfaces'].find_one()['functions']

        self.assertEqual('example:func', stored_funcs[0]['name'])
        self.assertEqual('Number', stored_funcs[0]['params'][0]['type'])
        self.assertEqual(1, stored_funcs[0]['params'][0]['position'])

    @attr('slow')
    def test_storing_existed_interface(self):
        inter1 = Interface()
        inter1.name = 'Test'
        inter1.region = 'IMEA'

        self.engine.store(inter1)

        inter2 = Interface()
        inter2.name = 'Test'
        inter2.region = 'AMER'

        self.engine.store(inter2)

        self.assertEqual(1, self.db['interfaces'].count())
        self.assertEqual('AMER', self.db['interfaces'].find_one()['region'])
