import sys
import solution_reader_test

# load a solution reader object which parses the input spec
sr = solution_reader_test.SolutionReader('input_data')

# load the density data at output step 20
rho = sr.loadVec('test.dat')

# the shape of the data is (NX, NY, size) for 2D runs and (NX, NY, NZ, size) for 3D
# where size depends on the data read.  For rho, size is the number of components.  
# For velocity, size is the number of dimensions (u,v,w) velocities.
# This assumes we did a 2D simulation with 2 components (standard bubble test).
print rho.shape

# visualize density of the 0th component with matplotlib
from matplotlib import pyplot as plt
plt.imshow(rho[:,:,0].transpose(), origin='lower')
plt.colorbar()
plt.show()
