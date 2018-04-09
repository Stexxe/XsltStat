class StoreEngine:

    def __init__(self, client, storage):
        self.client = client
        self.db = client[storage]

    def store(self, inter):
        data = {
            'name': inter.name,
            'region': inter.region,
            'templates': self._convert_entities(inter.templates),
            'functions': self._convert_entities(inter.funcs),
        }
        self.db['interfaces'].update({'name': inter.name}, data, True)

    def _convert_entities(self, entities):
        result = []

        for ent in entities:
            data = {
                'name': ent.name,
                'params': self._convert_params(ent.params)
            }

            result.append(data)

        return result

    def _convert_params(self, params):
        result = []

        for p in params:
            position = p.pos + 1 if p.pos is not None else None

            data = {
                'name': p.name,
                'position': position,
                'type': str(p.type)
            }

            result.append(data)

        return result

