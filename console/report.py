from xsl_stat.parser import Parser
import sys
import os.path


def error(msg):
    print(msg)
    sys.exit(1)


try:
    filepath = sys.argv[1]

    if not os.path.exists(filepath):
        error(f"File {filepath} doesn't exist")

    result = Parser.parse(filepath)

    print("Templates calls:")
    for t in result.templates:
        print('\t', t)

    print("Functions calls:")
    for f in result.funcs:
        print('\t', f)

except IndexError:
    error(f"Usage: python3 {os.path.basename(sys.argv[0])} xslt_file")



