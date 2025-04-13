def find_max(dictionary):
    max_ = 0
    bitstring = 0
    for key in dictionary.keys():
        if dictionary[key] > max_:
            max_ = dictionary[key]
            bitstring = key
    return bitstring

def get_gates(circuit):
    num_qubits_to_gates = {}
    gates_to_counts = {}
    for i in range(len(circuit[:])):
        gates_to_counts[circuit[i].name] = gates_to_counts.get(circuit[i].name, 0) + 1
        num_qubits = len(circuit[i].qubits)
        if num_qubits not in num_qubits_to_gates:
            num_qubits_to_gates[num_qubits] = set()
        num_qubits_to_gates[num_qubits].add(circuit[i].name)
    return num_qubits_to_gates, gates_to_counts

def get_connections(circuit):
    connections = set()
    for i in range(len(circuit[:])):
        if len(circuit[i].qubits) == 2:
            connections.add((circuit[i].qubits[0]._index, circuit[i].qubits[1]._index))
    return connections


