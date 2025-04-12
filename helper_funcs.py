def find_max(dictionary):
    max_ = 0
    bitstring = 0
    for key in dictionary.keys():
        if dictionary[key] > max_:
            max_ = dictionary[key]
            bitstring = key
    return bitstring
