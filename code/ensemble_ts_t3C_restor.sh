#!/bin/bash
# Baseline carbon uptake (no CC)
# t3_totalcarbon_${MOD}_${VAR}_fixco2_fixclim_2014_fire_grid.nc
# t3_totalcarbon_${MOD}_${VAR2}_fixco2_fixclim_2014_fire_ts.nc
# Carbon density of that (for prioritisation)
# t3carbon_${MOD}_${VAR}_fixco2_fixclim_2014_fire.nc
# Climate change w.r.t. baseline
# dt3_totalcarbon_${MOD}_${VAR}_${SSP}_grid.nc
# dt3_totalcarbon_${MOD}_${VAR}_${SSP}_ts.nc
# dt3perc_totalcarbon_${MOD}_${VAR}_${SSP}_ts.nc
# Raw gridded climate change 
# t3_totalcarbon_${MOD}_${VAR}_${SSP}_grid.nc 

# Set these to your directory structure
WORKDIR=/archived/data/
DATADIR=/archived/data/

MASK=${WORKDIR}restor_mask_tropics_LPJ.nc

mkdir ${WORKDIR}/totc_restor

for MOD in BCC-CSM2-MR IPSL-CM6A-LR MPI-ESM1-2-HR MRI-ESM2-0 FGOALS-g3 MIROC6 ACCESS-CM2 ACCESS-ESM1-5 AWI-CM-1-1-MR EC-Earth3-Veg INM-CM4-8 INM-CM5-0 CanESM5; 
do
for VAR in restor ctl;
do
cdo -L  -selyear,2014/2100 -sellevel,3 -selvar,tilecarbon ${DATADIR}${MOD}_30min_global_${VAR}_fixco2_fixclim_2014.nc ${WORKDIR}totc_restor/t3carbon_${MOD}_${VAR}_fixco2_fixclim_2014_fire.nc

cdo -L  -selyear,2014/2100 -sellevel,3 -selvar,coverfrac ${DATADIR}${MOD}_30min_global_${VAR}_fixco2_fixclim_2014.nc ${WORKDIR}totc_restor/t3cover_${MOD}_${VAR}_fixco2_fixclim_2014_fire.nc

cdo -L -mul -mul -mul -mul ${WORKDIR}totc_restor/t3carbon_${MOD}_${VAR}_fixco2_fixclim_2014_fire.nc ${WORKDIR}totc_restor/t3cover_${MOD}_${VAR}_fixco2_fixclim_2014_fire.nc -gridarea $MASK ${WORKDIR}landfrac.nc $MASK ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_${VAR}_fixco2_fixclim_2014_fire_grid.nc
done

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor_fixco2_fixclim_2014_fire_grid.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_ctl_fixco2_fixclim_2014_fire_grid.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_grid.nc

for VAR2 in restor restor-ctl;
do

cdo -L fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_${VAR2}_fixco2_fixclim_2014_fire_grid.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_${VAR2}_fixco2_fixclim_2014_fire_ts.nc

cdo -selyear,2014 ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_${VAR2}_fixco2_fixclim_2014_fire_ts.nc ${WORKDIR}totc_restor/tmp.nc

cdo -L -sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_${VAR2}_fixco2_fixclim_2014_fire_ts.nc ${WORKDIR}totc_restor/tmp.nc ${WORKDIR}totc_restor/tmp2.nc

mv ${WORKDIR}totc_restor/tmp2.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_${VAR2}_fixco2_fixclim_2014_fire_ts.nc
rm ${WORKDIR}totc_restor/tmp.nc ${WORKDIR}totc_restor/tmp2.nc
done
done

for SSP in ssp126 ssp245 ssp370 ssp585; 
do
for MOD in BCC-CSM2-MR IPSL-CM6A-LR MPI-ESM1-2-HR MRI-ESM2-0 FGOALS-g3 MIROC6 ACCESS-CM2 ACCESS-ESM1-5 AWI-CM-1-1-MR EC-Earth3-Veg INM-CM4-8 INM-CM5-0 CanESM5; 
do
for VAR in restor_fixco2_2014_fire restor_fire restor restor_fixco2_2014; 
do

cdo -L  -selyear,2014/2100 -sellevel,3 -selvar,tilecarbon ${DATADIR}${MOD}_${SSP}_30min_global_${VAR}.nc ${WORKDIR}totc_restor/t3carbon_${MOD}_${VAR}_${SSP}.nc

cdo -L  -selyear,2014/2100 -sellevel,3 -selvar,coverfrac ${DATADIR}${MOD}_${SSP}_30min_global_${VAR}.nc ${WORKDIR}totc_restor/t3cover_${VAR}_${SSP}.nc

cdo -L -mul -mul -mul -mul ${WORKDIR}totc_restor/t3carbon_${MOD}_${VAR}_${SSP}.nc ${WORKDIR}totc_restor/t3cover_${VAR}_${SSP}.nc -gridarea $MASK ${WORKDIR}landfrac.nc $MASK ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_${VAR}_${SSP}_grid.nc

done

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor_fixco2_2014_fire_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_ctl_fixco2_2014_fire_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_grid.nc

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor_fire_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_ctl_fire_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_grid.nc

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_ctl_fire_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_grid.nc

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor_fixco2_2014_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_ctl_fire_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_grid.nc

for VAR in restor-ctl_fixco2_2014_fire restor-ctl_fire restor-ctl restor-ctl_fixco2_2014;
do

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_${VAR}_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_${VAR}_${SSP}_ts.nc

cdo selyear,2014 ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_${VAR}_${SSP}_ts.nc ${WORKDIR}totc_restor/tmp.nc

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_${VAR}_${SSP}_ts.nc ${WORKDIR}totc_restor/tmp.nc ${WORKDIR}totc_restor/tmp2.nc

mv ${WORKDIR}totc_restor/tmp2.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_${VAR}_${SSP}_ts.nc

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_${VAR}_${SSP}_ts.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_ts.nc ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_${VAR}_${SSP}_ts.nc

cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_${VAR}_${SSP}_ts.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_ts.nc ${WORKDIR}totc_restor/dt3perc_totalcarbon_${MOD}_${VAR}_${SSP}_ts.nc
done
done
done
