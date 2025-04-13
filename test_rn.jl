using ITensors, ITensorMPS

# Define the single qubit system (2-level system)
site = SiteTensor(2)  # 2-level system for a single qubit
s = [site]

# Define the rotation parameters for Rn
θ = 2.005764
φ = -0.88174361
λ = 1.7982687

# Define the Rn operator for the single qubit site
op_rn = op("Rn", s[1]; θ = θ, φ = φ, λ = λ)

# Define the basis states |0⟩ and |1⟩ as SiteTensors
state_0 = SiteTensor(2)
state_0[1] = 1  # |0⟩ state: [1, 0]

state_1 = SiteTensor(2)
state_1[2] = 1  # |1⟩ state: [0, 1]

# Apply the Rn operator to the |0⟩ state and |1⟩ state
result_0 = op_rn * state_0
result_1 = op_rn * state_1

# Now we can use the dot product to compute the matrix elements
# The dot product of the state with the operator gives the amplitudes of the states
matrix_element_00 = dot(state_0, result_0)  # <0|Rn|0>
matrix_element_01 = dot(state_0, result_1)  # <0|Rn|1>
matrix_element_10 = dot(state_1, result_0)  # <1|Rn|0>
matrix_element_11 = dot(state_1, result_1)  # <1|Rn|1>

# Print the matrix elements
println("Matrix element <0|Rn|0>: ", matrix_element_00)
println("Matrix element <0|Rn|1>: ", matrix_element_01)
println("Matrix element <1|Rn|0>: ", matrix_element_10)
println("Matrix element <1|Rn|1>: ", matrix_element_11)
