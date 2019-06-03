# Sponge Module
This module was developed by [ATA Engineering](http://www.ata-e.com) as an 
add-on to the Loci/CHEM computational fluid dynamics (CFD) solver. The module 
can be used to reduce reflections into the domain caused by boundary conditions.
The module works by adding a source term to the governing equations. The 
purpose of the source term is to drive the flow to a user defined reference 
state in the sponge layer region of influence.

# Dependencies
This module depends on both Loci and CHEM being installed. Loci is an open
source framework developed at Mississippi State University (MSU) by Dr. Ed 
Luke. The framework provides a rule-based programming model and can take 
advantage of massively parallel high performance computing systems. CHEM is a 
full featured open source CFD code with finite-rate chemistry built on the Loci 
framework. Both Loci and CHEM can be obtained from the 
[SimSys Software Forum](http://www.simcenter.msstate.edu) hosted by MSU.

# Installation Instructions
First Loci and CHEM should be installed. The **LOCI_BASE** environment
variable should be set to point to the Loci installation directory. The 
**CHEM_BASE** environment variable should be set to point to the CHEM 
installation directory. The installation process follows the standard 
make, make install procedure.

```bash
make
make install
```

# Usage
First the module must be loaded at the top of the **vars** file. 
Boundary conditions that permit outflow (e.g. **outflow**, **outflowNRBC**, 
**extrapolate**, **farfield**, etc) may be tagged with the **sponge** tag. A 
reference flow state along with a length specifying how far from the tagged 
boundaries the sponge layer is active, and a sponge layer strength can be 
specified inside the **sponge** options list.

```
loadModule: sponge

boundary_conditions: <BC_1=outflow(p=101325 Pa, sponge), ...>
sponge: <p=101325 Pa, T=300 K, u=[100 m/s, 0, 0], length=0.1 m, sigma=50000>
```

