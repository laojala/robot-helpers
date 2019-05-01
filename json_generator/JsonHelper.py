class JsonHelper:

    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    __version__ = '0.1'

    def add_value_to_custom_dictionary(self, dictionary, key, value):
        if key not in dictionary:
            dictionary[key] = value
        elif type(dictionary[key]) == list:
            dictionary[key].append(value)
        else:
            dictionary[key] = [dictionary[key], value]