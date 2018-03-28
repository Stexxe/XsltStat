import os.path
from xsl_stat.parser import Type
from stat_case import StatCase


class MyTestCase(StatCase):
    def test_something(self):
        expect = {
            'functions': {
                'test:func':  [Type.STRING],
                'test:con-cat': [Type.STRING, Type.NUMBER],
                'test:text': [Type.UNKNOWN],
                'test:m1': [None],
                'test:m2': [None],
                'test:xslt3': [None],
                'ex:complex': [Type.NUMBER, Type.UNKNOWN, Type.STRING]
            }
        }

        self.assertStat(expect, os.path.join(self.get_res_dir(__file__), 'functions.xsl'))
