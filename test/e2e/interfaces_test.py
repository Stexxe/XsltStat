import os.path
from xsl_stat.parser import Type
from stat_case import StatCase


class InterfacesTest(StatCase):
    def setUp(self):
        self.res_dir = self.get_res_dir(__file__)

    def test_RaapapXDOTWO(self):
        expect = {
            'templates': {
                'conv': {
                    'TableNumber': Type.NUMBER,
                    'Key': Type.UNKNOWN
                }
            },
            'functions': {
                'eienv:get-env': [Type.STRING],
                'user:conv': [Type.NUMBER, Type.UNKNOWN],
                'knfunc:create-tws-member': [None],
                'eimf:set-local': [Type.STRING, Type.STRING, Type.STRING]
            }
        }

        self.assertStat(expect, os.path.join(self.res_dir, 'RaapapXDOTWO.xsl'))

    def test_RabukaPDFXML_validate(self):
        expect = {
            'functions': {
                'eienv:get-env': [Type.STRING],
                'eicf:get-common-block': [Type.STRING],
                'my:conv': [Type.NUMBER, Type.UNKNOWN]
            }
        }

        self.assertStat(expect, os.path.join(self.res_dir, 'RabukaPDFXML_validate.xsl'))

    def test_some(self):
        expect = {
            'templates': {
                'conv': {
                    'TableNumber': Type.NUMBER,
                    'Key': Type.UNKNOWN
                }
            },
            'functions': {
                'knfunc:create-tws-member': [None],
                'eimf:set-local': [Type.UNKNOWN, Type.STRING, Type.STRING],
                'eimf:set-global': [Type.STRING, Type.STRING]

            },
        }

        self.assertStat(expect, os.path.join(self.res_dir, 'RadicoXDOTWO.xsl'))
