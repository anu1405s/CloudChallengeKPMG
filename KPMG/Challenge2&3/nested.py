def nestedValue(data, key):
    if isinstance(data, dict):
        if key in data:
            return data[key]
        for k, v in data.items():
            result = nestedValue(v, key)
            if result is not None:
                return result
    elif isinstance(data, list):
        for item in data:
            result = nestedValue(item, key)
            if result is not None:
                return result
    return None

