import unittest
from xsl_stat.parser import Parser
import os.path


class StatCase(unittest.TestCase):
    def get_res_dir(self, script_path):
        current_dir = os.path.dirname(os.path.abspath(script_path))
        return os.path.join(current_dir, 'files')

    def assertStat(self, expect, filepath):
        '''
        :param expect: expectation structure. Example:
        {
            templates: {
                'test':  {
                    'p1': Type.NUMBER,
                    'p2': Type.STRING,
                }
            },

            functions: {
                'ns:func': [Type.STRING, Type.STRING],
                'n2:func': [None] # In case if it has no parameters
            }

        }
        :param filepath: Path to tested XSLT file
        :return:
        '''

        result = Parser.parse(filepath)

        if 'templates' in expect:
            self.foreach_expected_entity(self.check_template, expect['templates'], result)
            self.check_amount(expect['templates'], result.templates)

        if 'functions' in expect:
            self.foreach_expected_entity(self.check_func, expect['functions'], result)
            self.check_amount(expect['functions'], result.funcs)

    def check_amount(self, expect, actual):
        names = list(map(lambda x: x.name, actual))
        exp_names = list(map(lambda x: x, expect.keys()))

        self.assertEqual(len(exp_names), len(names),
                         f'Expected names: {exp_names}. Actual are: {names}')

    def check_template(self, name, param_name, param_type, result):
        template = result.get_template(name)
        self.assertIsNotNone(template, f"Should have template {name}")

        param = template.get_param(param_name)
        self.assertIsNotNone(param, f"Template {name} should have param {param_name}")
        self.assertEqual(param_type, param.type, f"Template {name} param {param.name} should have type {param_type}")

    def check_func(self, name, param_pos, param_type, result):
        func = result.get_func(name)
        self.assertIsNotNone(func, f"Should have function {name}")

        if param_type is not None:
            param = func.get_param(param_pos)
            self.assertIsNotNone(param, f"Function {name} should have param #{param_pos} ")
            self.assertEqual(param_type, param.type,
                             f"Function {name} param #{param_pos} should have type {param_type}")

    def foreach_expected_entity(self, action, expect, result):
        for name, params in expect.items():
            if isinstance(params, dict):
                for param_name, param_type in params.items():
                    action(name, param_name, param_type, result)
            elif isinstance(params, list):
                for pos, param_type in enumerate(params):
                    action(name, pos, param_type, result)


