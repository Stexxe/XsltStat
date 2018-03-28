from enum import Enum
import abc


class Type(Enum):
    UNKNOWN = -1
    NUMBER = 1
    STRING = 2

    def __str__(self):
        conv = {
            Type.UNKNOWN: 'Unknown',
            Type.NUMBER: 'Number',
            Type.STRING: 'String',
        }

        return conv[self]


class Result:
    def __init__(self):
        self.templates = []
        self.funcs = []

    def add_template(self, template):
        self._add(self.templates, template)

    def add_func(self, func):
        self._add(self.funcs, func)

    def _add(self, alist, item):
        similar = find(lambda x: x != item and x.similar(item), alist)

        if similar is not None:
            similar.merge(item)
        else:
            alist.append(item)

    def get_func(self, name):
        return find(lambda t: t.name == name, self.funcs)

    def get_template(self, name):
        return find(lambda t: t.name == name, self.templates)


class Entity(abc.ABC):
    def __init__(self):
        self.name = None
        self.params = []

    def add_param(self, p):
        self.params.append(p)

    @abc.abstractmethod
    def get_param(self, p):
        return

    def merge(self, other):
        for p in self.params:
            other_p = other.get_param(p)
            p.merge(other_p)

    def similar(self, other):
        if self.name != other.name:
            return False

        for p in self.params:
            other_p = other.get_param(p)

            if other_p is None or not p.similar(other_p):
                return False

        return True


class Template(Entity):
    def get_param(self, param):
        name = param.name if 'name' in dir(param) else param
        return find(lambda p: p.name == name, self.params)

    def __str__(self):
        params_repr = list(map(lambda x: f'{x.name}({str(x.type)})', self.params))
        params_str = ', '.join(params_repr) if len(params_repr) > 0 else 'No params'

        return f"{self.name}: {params_str}"


class Func(Entity):
    def get_param(self, param):
        pos = param.pos if 'pos' in dir(param) else param
        return find(lambda p: p.pos == pos, self.params)

    def __str__(self):
        types = list(map(lambda x: str(x.type), self.params))
        types_str = ', '.join(types)

        return f"{self.name}({types_str})"


class Param:
    def __init__(self):
        self.name = None
        self.pos = None
        self.type = Type.UNKNOWN

    def merge(self, other):
        self.type = self.type if self.type != Type.UNKNOWN else other.type

    def similar(self, other):
        similar_type = (self.type == other.type or self.type == Type.UNKNOWN or other.type == Type.UNKNOWN)
        return self.name == other.name and similar_type


def find(predicate, a_list):
    found_list = list(filter(predicate, a_list))

    if len(found_list) == 0:
        return None

    return found_list[0]
