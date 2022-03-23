#!/bin/bash

#SBATCH -A sens2017552
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 04:00:00
#SBATCH -J metal_script



metal script_metal.txt
