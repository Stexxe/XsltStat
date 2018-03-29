class StoreEngine:

    def __init__(self, client, storage):
        self.client = client
        self.db = client[storage]

    def store(self, inter):
        region_id = None
        if inter.region is not None:
            region_id = self._fetch_region_id(inter.region)
            if region_id is None:
                region_id = self.db['regions'].insert_one({'name': inter.region}).inserted_id

        self.db['interfaces'].insert_one({'name': inter.name, 'region': region_id})

    def _fetch_region_id(self, name):
        region = self.db['regions'].find_one({'name': name})
        return region['_id'] if region is not None else None



