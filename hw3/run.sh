#!/bin/bash

for i in {300..600..50}
do
# Affiliation: Dept. Materials Science and Engineering
# University of Arizona
# Abduljabar Alsayoud


# Units energy:eV time:ps distance:angstrom flux:energy*velocity
#---------Sim variables---------------
variable fileprefix string  optimized.data
#variable temp_s equal '300.0'
variable press_s equal '1.0'
log log.${fileprefix}

#-----------Setup----------------------
units metal            #Energy = eV , Distance= Angstroms
dimension 3
boundary p p p         #Periodic boundary conditions 
atom_style atomic

# Read config files

read_data ${fileprefix}
replicate 3 3 3

pair_style eam/alloy 
pair_coeff * *  Al99.eam.alloy Al
neighbor 2.0 bin 
neigh_modify delay 10 check yes 


#--------- NPT-------                                                                                                         
reset_timestep 0
timestep 0.001

thermo 1000
thermo_style custom step pe ke etotal enthalpy temp vol press
velocity all create $i 1518772 
fix 1 all npt temp $i $i 0.5 iso ${press_s} ${press_s} 5 
dump 2 all atom 2000 dump.npt${fileprefix}$i
run 60000
unfix 1
undump 2

######################################
# SIMULATION DONE
print "All done"

