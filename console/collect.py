import sys
import os.path
from xsl_stat.collector import Collector
from pymongo import MongoClient


def error(msg):
    print(msg)
    sys.exit(1)


try:
    interfaces_dir = sys.argv[1]

    if not os.path.exists(interfaces_dir):
        error(f"File {interfaces_dir} doesn't exist")

    client = MongoClient()
    db = client['stat']

    collector = Collector(interfaces_dir, db)
    collector.collect()

except IndexError:
    error(f"Usage: python3 {os.path.basename(sys.argv[0])} interfaces_dir")
