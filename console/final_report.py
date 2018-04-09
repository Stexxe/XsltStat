from pymongo import MongoClient
from collections import OrderedDict
import jinja2
import os.path
import io


def _get_result(interfaces, key):
    res = {}

    for interface in interfaces:
        for ent in interface[key]:
            if interface['region'] not in res:
                res[interface['region']] = {}

            region_entities = res[interface['region']]

            if ent['name'] not in region_entities:
                region_entities[ent['name']] = {}

            result_ent = region_entities[ent['name']]

            if 'count' in result_ent:
                result_ent['count'] += 1
            else:
                result_ent['count'] = 1

            if 'interfaces' not in result_ent:
                result_ent['interfaces'] = []

            result_ent['interfaces'].append(interface['name'])

    sorted_result = {}
    for region, data in res.items():
        od = OrderedDict(sorted(data.items(), key=lambda x: x[1]['count'], reverse=True))
        sorted_result[region] = od

    return sorted_result


client = MongoClient()
db = client['stat']
collected_interfaces = db['interfaces'].find({})

result = {
    'templates': _get_result(collected_interfaces, 'templates'),
    'functions': _get_result(collected_interfaces, 'functions'),
}

current_dir = os.path.dirname(os.path.abspath(__file__))

templateLoader = jinja2.FileSystemLoader(searchpath=current_dir)
templateEnv = jinja2.Environment(loader=templateLoader)
template = templateEnv.get_template("report.html.j2")
output = template.render(data=result)

with io.open(os.path.join(current_dir, 'report.html'), 'w', encoding='utf8') as file:
    file.write(output)



