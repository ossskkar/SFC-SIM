# SFC-SIM
SFC-SIM is an implementation of the social force model for simulating crowds.

## PREREQUISITES
MATLAB

## INSTALLING
Clone or download the repository to a local directory.

## RUNNING THE SIMULATOR

### CONFIGURATION FILE
- The configuration file ./data/<config_file>.conf contains the configuration parameters of the model.
- Parameter intent_count indicates the number of static points of interest.
- Parameter temp_intent_count indicates the number of temporal points of interest (stopovers).

### TOPOLOGY MAP
- The topology of the environment is specified in the file ./images/<map_file> in JPE/PNG format.
- The dimensions of the environment corresponds to the dimensions of <map_file>.
- The walls of the environment correspond to the black (0,0,0) pixels in <map_file>.
- The static points of interest (origin/destination) corresponds to the green (0,255,0) pixels in <map_file>.
- The temporal points of interest (stopovers) corresponds to the magenta (255,0,255) pixels in <map_file>.
- The area for spectators corresponds to the yellow (255,255,0) pixels in <map_file>.
- The area for crowd crystals (e.g. performers) corresponds to the orange (255,155,0) pixels in <map_file>.
- The <map_file> to be used is indicated by the "floor_1_build" parameter in the <config_file>.

### SIMULATION PLAN
- The simulation plan can be specified in ./scripts/initSimulations.m
- The set of simulation segments are stored in the cell array data.simulation.
- The function newSimulation() creates a new simulation segment with default parameters.
- The parameters of each simulation segment can be adjusted manually.

### RUN A SIMULATION
- Open and execute the file ./scripts/simulate.m to run a simulation.

## AUTHORS
- Oscar J. Urizar.

## LICENCE
This project is licensed under the MIT License - see the LICENCE.MD file for details.

## ACKNOWLEDGEMENT
This crowd simulation tool was developed as part of the research conducted by Oscar J. Urizar under the Erasmus Mundus Joint Doctorate Program in Interactive and Cognitive Environments (EMJD-ICE).
