import sys
import os.path
from pymongo import MongoClient


def error(msg):
    print(msg)
    sys.exit(1)


try:
    filepath = sys.argv[1]

    client = MongoClient()
    db = client['stat']
    db['process'].remove()

    with open(filepath) as fp:
        for line in fp:
            name, region = line.split('|')
            db['process'].insert_one({'name': name, 'region': region.rstrip()})

except IndexError:
    error(f"Usage: python3 {os.path.basename(sys.argv[0])} filepath")
