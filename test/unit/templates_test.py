import os.path
from xsl_stat.parser import Type
from stat_case import StatCase


class MyTestCase(StatCase):
    def test_something(self):
        expect = {
            'templates': {
                'test':  {
                    'p1': Type.NUMBER,
                    'p2': Type.UNKNOWN,
                }
            }
        }

        self.assertStat(expect, os.path.join(self.get_res_dir(__file__), 'templates.xsl'))
