def get_nested_value(data, key):
    keys = key.split('/')
    current = data
    for k in keys:
        if k in current:
            current = current[k]
        else:
            return None  # Key not found
    return current
