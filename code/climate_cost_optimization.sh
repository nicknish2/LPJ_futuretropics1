#!/bin/bash
#Top 50% carbon on a grid cell level (no CC) selected
#- carbon uptake (no CC) = t3_totalcarbon_restor-ctl_fixco2_fixclim_2014_fire_ts_50p_ensmean.nc
#- climate impact = t3C_${SSP}_restor-ctl_ts_50p_ensmean.nc
#- cost
#Top 50% carbon density (no CC) selected
#- carbon uptake (no CC) = t3_totalcarbon_restor_fixco2_fixclim_2014_fire_ts_50p_ensmean.nc
#- climate impact = t3C_${SSP}_restor_ts_50p_ensmean.nc
#- cost
#Cheapest 50% carbon selected
#- carbon uptake (no CC) = cost_totalcarbon_restor_fixco2_fixclim_2014_fire_ts_50p_ensmean.nc
#- climate impact = t3C_cheap_${SSP}_restor_ts_50p_ensmean.nc
#- cost
#Top 50% carbon for each climate level (no CO2 & w. CO2)
#- carbon uptake 
#- cost
#Cheapest, climate-safe 50% (no CO2 & w. CO2)
#- carbon uptake
#- cost

WORKDIR=/archived/data/

MASK=${WORKDIR}restor_mask_tropics_LPJ.nc
COST_FILE=${WORKDIR}restoration_cost_1.1_tropics_final.nc

R_CREATE_MASK=/home/akoch/scripts/future_forests/create_mask_top50.R

for MOD in BCC-CSM2-MR IPSL-CM6A-LR MPI-ESM1-2-HR MRI-ESM2-0 FGOALS-g3 MIROC6 ACCESS-CM2 ACCESS-ESM1-5 AWI-CM-1-1-MR EC-Earth3-Veg INM-CM4-8 INM-CM5-0 CanESM5; 
do
cdo -L -div -selyear,2099 ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_grid.nc $MASK ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_mask.nc

Rscript --vanilla ${R_CREATE_MASK} ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_mask.nc ${COST_FILE} CARBON TRUE

cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_grid.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_ts_50p.nc 
done 

### climate impact on baseline choice
for SSP in ssp126 ssp245 ssp370 ssp585; 
do
for MOD in BCC-CSM2-MR IPSL-CM6A-LR MPI-ESM1-2-HR MRI-ESM2-0 FGOALS-g3 MIROC6 ACCESS-CM2 ACCESS-ESM1-5 AWI-CM-1-1-MR EC-Earth3-Veg INM-CM4-8 INM-CM5-0 CanESM5; 
do
## restor_fixco2_2014_fire
cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor_fixco2_2014_fire_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_mask.nc ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor_fixco2_2014_fire_${SSP}_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor_fixco2_2014_fire_${SSP}_grid_50p.nc ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor_fixco2_2014_fire_${SSP}_ts_50p.nc

cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor_fixco2_2014_fire_${SSP}_ts_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_ts_50p.nc ${WORKDIR}totc_restor/dt3perc_totalcarbon_${MOD}_restor_fixco2_2014_fire_${SSP}_ts_50p.nc

## restor_fire
cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor_fire_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_mask.nc ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor_fire_${SSP}_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor_fire_${SSP}_grid_50p.nc ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor_fire_${SSP}_ts_50p.nc

cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor_fire_${SSP}_ts_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_ts_50p.nc ${WORKDIR}totc_restor/dt3perc_totalcarbon_${MOD}_restor_fire_${SSP}_ts_50p.nc

## restor
cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_mask.nc ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor_${SSP}_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor_${SSP}_grid_50p.nc ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor_${SSP}_ts_50p.nc

cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor_${SSP}_ts_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_ts_50p.nc ${WORKDIR}totc_restor/dt3perc_totalcarbon_${MOD}_restor_${SSP}_ts_50p.nc

## restor_fixco2_2014
cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor_fixco2_2014_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_mask.nc ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor_fixco2_2014_${SSP}_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor_fixco2_2014_${SSP}_grid_50p.nc ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor_fixco2_2014_${SSP}_ts_50p.nc

cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor_fixco2_2014_${SSP}_ts_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_ts_50p.nc ${WORKDIR}totc_restor/dt3perc_totalcarbon_${MOD}_restor_fixco2_2014_${SSP}_ts_50p.nc
done 
done

## carbon density #############################################################
for MOD in BCC-CSM2-MR IPSL-CM6A-LR MPI-ESM1-2-HR MRI-ESM2-0 FGOALS-g3 MIROC6 ACCESS-CM2 ACCESS-ESM1-5 AWI-CM-1-1-MR EC-Earth3-Veg INM-CM4-8 INM-CM5-0 CanESM5; 
do
cdo -L -div -selyear,2099 ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor_fixco2_fixclim_2014_fire_grid.nc $MASK ${WORKDIR}totc_restor/t3_carbondensity_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_mask.nc

Rscript --vanilla ${R_CREATE_MASK} ${WORKDIR}totc_restor/t3_carbondensity_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_mask.nc ${COST_FILE} CARBON_DENSITY TRUE

cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_grid.nc ${WORKDIR}totc_restor/t3_carbondensity_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_cd_fixco2_fixclim_2014_fire_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_cd_fixco2_fixclim_2014_fire_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_cd_fixco2_fixclim_2014_fire_ts_50p.nc 
done 


### climate
for SSP in ssp126 ssp245 ssp370 ssp585; 
do
for MOD in BCC-CSM2-MR IPSL-CM6A-LR MPI-ESM1-2-HR MRI-ESM2-0 FGOALS-g3 MIROC6 ACCESS-CM2 ACCESS-ESM1-5 AWI-CM-1-1-MR EC-Earth3-Veg INM-CM4-8 INM-CM5-0 CanESM5; 
do
## restor_fixco2_2014_fire
cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_carbondensity_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cd_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cd_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cd_ts_50p.nc

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cd_ts_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_cd_fixco2_fixclim_2014_fire_ts_50p.nc ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cd_ts_50p.nc

cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cd_ts_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_cd_fixco2_fixclim_2014_fire_ts_50p.nc ${WORKDIR}totc_restor/dt3perc_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cd_ts_50p.nc

## restor_fire
cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_carbondensity_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cd_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cd_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cd_ts_50p.nc

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cd_ts_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_cd_fixco2_fixclim_2014_fire_ts_50p.nc ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cd_ts_50p.nc

cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cd_ts_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_cd_fixco2_fixclim_2014_fire_ts_50p.nc ${WORKDIR}totc_restor/dt3perc_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cd_ts_50p.nc

## restor
cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_carbondensity_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_cd_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_cd_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_cd_ts_50p.nc

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_cd_ts_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_cd_fixco2_fixclim_2014_fire_ts_50p.nc ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_${SSP}_cd_ts_50p.nc

cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_${SSP}_cd_ts_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_cd_fixco2_fixclim_2014_fire_ts_50p.nc ${WORKDIR}totc_restor/dt3perc_totalcarbon_${MOD}_restor-ctl_${SSP}_cd_ts_50p.nc

## restor_fixco2_2014
cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_carbondensity_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_cd_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_cd_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_cd_ts_50p.nc

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_cd_ts_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_cd_fixco2_fixclim_2014_fire_ts_50p.nc ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_cd_ts_50p.nc

cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_cd_ts_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_cd_fixco2_fixclim_2014_fire_ts_50p.nc ${WORKDIR}totc_restor/dt3perc_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_cd_ts_50p.nc

done 
done

### CHEAPEST 50% ###############################################################
## baseline
for MOD in BCC-CSM2-MR IPSL-CM6A-LR MPI-ESM1-2-HR MRI-ESM2-0 FGOALS-g3 MIROC6 ACCESS-CM2 ACCESS-ESM1-5 AWI-CM-1-1-MR EC-Earth3-Veg INM-CM4-8 INM-CM5-0 CanESM5; 
do
cdo -L -div -selyear,2099 ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_grid.nc $MASK ${WORKDIR}totc_restor/t3_cheapest_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_mask.nc

Rscript --vanilla ${R_CREATE_MASK} ${WORKDIR}totc_restor/t3_cheapest_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_mask.nc ${COST_FILE} COST TRUE

cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_grid.nc ${WORKDIR}totc_restor/t3_cheapest_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_cheap_fixco2_fixclim_2014_fire_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_cheap_fixco2_fixclim_2014_fire_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_cheap_fixco2_fixclim_2014_fire_ts_50p.nc 
done 


## climate
for SSP in ssp126 ssp245 ssp370 ssp585; 
do
for MOD in BCC-CSM2-MR IPSL-CM6A-LR MPI-ESM1-2-HR MRI-ESM2-0 FGOALS-g3 MIROC6 ACCESS-CM2 ACCESS-ESM1-5 AWI-CM-1-1-MR EC-Earth3-Veg INM-CM4-8 INM-CM5-0 CanESM5; 
do
## restor_fixco2_2014_fire
cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_cheapest_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cheap_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cheap_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cheap_ts_50p.nc

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cheap_ts_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_cheap_fixco2_fixclim_2014_fire_ts_50p.nc ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cheap_ts_50p.nc

cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cheap_ts_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_cheap_fixco2_fixclim_2014_fire_ts_50p.nc ${WORKDIR}totc_restor/dt3perc_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cheap_ts_50p.nc

## restor_fire
cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_cheapest_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cheap_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cheap_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cheap_ts_50p.nc

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cheap_ts_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_cheap_fixco2_fixclim_2014_fire_ts_50p.nc ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cheap_ts_50p.nc

cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cheap_ts_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_cheap_fixco2_fixclim_2014_fire_ts_50p.nc ${WORKDIR}totc_restor/dt3perc_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cheap_ts_50p.nc

## restor
cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_cheapest_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_cheap_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_cheap_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_cheap_ts_50p.nc

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_cheap_ts_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_cheap_fixco2_fixclim_2014_fire_ts_50p.nc ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_${SSP}_cheap_ts_50p.nc

cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_${SSP}_cheap_ts_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_cheap_fixco2_fixclim_2014_fire_ts_50p.nc ${WORKDIR}totc_restor/dt3perc_totalcarbon_${MOD}_restor-ctl_${SSP}_cheap_ts_50p.nc

## restor_fixco2_2014
cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_cheapest_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_cheap_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_cheap_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_cheap_ts_50p.nc

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_cheap_ts_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_cheap_fixco2_fixclim_2014_fire_ts_50p.nc ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_cheap_ts_50p.nc

cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_cheap_ts_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_cheap_fixco2_fixclim_2014_fire_ts_50p.nc ${WORKDIR}totc_restor/dt3perc_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_cheap_ts_50p.nc
done 
done


### cost-climate #############################################################
## baseline
for MOD in BCC-CSM2-MR IPSL-CM6A-LR MPI-ESM1-2-HR MRI-ESM2-0 FGOALS-g3 MIROC6 ACCESS-CM2 ACCESS-ESM1-5 AWI-CM-1-1-MR EC-Earth3-Veg INM-CM4-8 INM-CM5-0 CanESM5; 
do
cdo -L -div -selyear,2099 ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_grid.nc $MASK ${WORKDIR}totc_restor/t3_climcost_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_mask.nc

Rscript --vanilla ${R_CREATE_MASK} ${WORKDIR}totc_restor/t3_climcost_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_mask.nc ${COST_FILE} COST_CARBON TRUE

cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_grid.nc ${WORKDIR}totc_restor/t3_climcost_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_climcost_fixco2_fixclim_2014_fire_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_climcost_fixco2_fixclim_2014_fire_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_climcost_fixco2_fixclim_2014_fire_ts_50p.nc 
done 


for SSP in ssp126 ssp245 ssp370 ssp585; 
do
for MOD in BCC-CSM2-MR IPSL-CM6A-LR MPI-ESM1-2-HR MRI-ESM2-0 FGOALS-g3 MIROC6 ACCESS-CM2 ACCESS-ESM1-5 AWI-CM-1-1-MR EC-Earth3-Veg INM-CM4-8 INM-CM5-0 CanESM5; 
do
## restor_fixco2_2014_fire
cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_climcost_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_climcost_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_climcost_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_climcost_ts_50p.nc

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_climcost_ts_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_climcost_fixco2_fixclim_2014_fire_ts_50p.nc ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_climcost_ts_50p.nc

cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_climcost_ts_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_climcost_fixco2_fixclim_2014_fire_ts_50p.nc ${WORKDIR}totc_restor/dt3perc_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_climcost_ts_50p.nc

## restor_fire
cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_climcost_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_climcost_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_climcost_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_climcost_ts_50p.nc

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_climcost_ts_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_climcost_fixco2_fixclim_2014_fire_ts_50p.nc ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_climcost_ts_50p.nc

cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_climcost_ts_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_climcost_fixco2_fixclim_2014_fire_ts_50p.nc ${WORKDIR}totc_restor/dt3perc_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_climcost_ts_50p.nc

## restor
cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_climcost_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_climcost_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_climcost_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_climcost_ts_50p.nc

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_climcost_ts_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_climcost_fixco2_fixclim_2014_fire_ts_50p.nc ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_${SSP}_climcost_ts_50p.nc

cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_${SSP}_climcost_ts_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_climcost_fixco2_fixclim_2014_fire_ts_50p.nc ${WORKDIR}totc_restor/dt3perc_totalcarbon_${MOD}_restor-ctl_${SSP}_climcost_ts_50p.nc

## restor_fixco2_2014
cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_climcost_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_climcost_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_climcost_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_climcost_ts_50p.nc

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_climcost_ts_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_climcost_fixco2_fixclim_2014_fire_ts_50p.nc ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_climcost_ts_50p.nc

cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_climcost_ts_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_climcost_fixco2_fixclim_2014_fire_ts_50p.nc ${WORKDIR}totc_restor/dt3perc_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_climcost_ts_50p.nc

done 
done

