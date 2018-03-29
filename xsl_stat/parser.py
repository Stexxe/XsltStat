import xml.etree.ElementTree as Et
from entity import *
import re


class Parser:
    NS = {'xsl': 'http://www.w3.org/1999/XSL/Transform'}
    EXCLUDED_PREFIX = ['xs']

    @staticmethod
    def parse(filepath):
        tree = Et.parse(filepath)

        result = Result()
        for node in tree.findall('.//xsl:call-template', Parser.NS):
            template = Parser._parse_template(node)
            result.add_template(template)

        with open(filepath, 'r') as file:
            data = file.read()

            funcs = Parser._parse_funcs(data)
            [result.add_func(x) for x in funcs if x is not None and x.name.split(':')[0] not in Parser.EXCLUDED_PREFIX]

        return result

    @staticmethod
    def _parse_template(node):
        t = Template()
        t.name = node.get('name')

        for n in node.findall('xsl:with-param', Parser.NS):
            param = Param()
            param.name = n.get('name')
            val = n.get('select') if 'select' in n.attrib else n.text
            param.type = Parser._get_type(val)

            t.add_param(param)

        return t

    @staticmethod
    def _parse_funcs(string):
        it = re.finditer(r'(\w+:[a-z][a-z0-9-_]*)\(', string, re.IGNORECASE)

        func_list = []
        for m in it:
            start = m.end()
            arg_start = start
            limit = 1024
            bracket_count = 0
            args = []

            for pos in range(start, start + limit):
                symb = string[pos]
                arg = string[arg_start:pos]

                is_end = (symb == ')' and bracket_count == 0)

                if is_end:
                    args.append(arg) if len(arg) > 0 else None
                    break

                # Inner function call starts
                if symb == '(':
                    bracket_count += 1
                # Inner function call ends
                if symb == ')':
                    bracket_count -= 1

                # End of argument in our function call
                if symb == ',' and bracket_count == 0:
                    args.append(arg)
                    arg_start = pos + 1

            func = Func()
            func.name = m.group(1)

            for i, val in enumerate(args):
                p = Param()
                p.pos = i
                p.type = Parser._get_type(val)
                func.add_param(p)

            func_list.append(func)

        return func_list

    @staticmethod
    def _get_type(val):
        trimmed = str(val).strip()

        if len(trimmed) == 0:
            return Type.UNKNOWN

        first_letter = trimmed[0]

        if first_letter.isdigit():
            return Type.NUMBER
        elif first_letter.isprintable() and first_letter == "'":
            return Type.STRING

        return Type.UNKNOWN
