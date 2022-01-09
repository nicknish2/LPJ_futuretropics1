#!/bin/bash
# same as climate_cost_optimization.txt but minimizing climate change

WORKDIR=/archived/data/

MASK=${WORKDIR}restor_mask_tropics_LPJ.nc
COST_FILE=${WORKDIR}restoration_cost_1.1_tropics_final.nc

R_CREATE_MASK=/home/akoch/scripts/future_forests/create_mask_top50.R

# maximizing carbon via carbon density #########################################
for SSP in ssp126 ssp245 ssp370 ssp585; 
do
for MOD in BCC-CSM2-MR IPSL-CM6A-LR MPI-ESM1-2-HR MRI-ESM2-0 FGOALS-g3 MIROC6 ACCESS-CM2 ACCESS-ESM1-5 AWI-CM-1-1-MR EC-Earth3-Veg INM-CM4-8 INM-CM5-0 CanESM5; 
do
## restor_fixco2_2014_fire
cdo -L -div -selyear,2099 ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_grid.nc $MASK ${WORKDIR}totc_restor/t3_carbondensity2_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_mask.nc

Rscript --vanilla ${R_CREATE_MASK} ${WORKDIR}totc_restor/t3_carbondensity2_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_mask.nc ${COST_FILE} CARBON_DENSITY TRUE

cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_carbondensity2_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cd2_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cd2_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cd2_ts_50p.nc

cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_grid.nc ${WORKDIR}totc_restor/t3_carbondensity2_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_mask.nc ${WORKDIR}totc_restor/t3_carbondensity2_rff_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_carbondensity2_rff_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_grid_50p.nc ${WORKDIR}totc_restor/t3_carbondensity2_rff_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc 

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cd2_ts_50p.nc ${WORKDIR}totc_restor/t3_carbondensity2_rff_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc  ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cd2_ts_50p.nc

cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cd2_ts_50p.nc ${WORKDIR}totc_restor/t3_carbondensity2_rff_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc ${WORKDIR}totc_restor/dt3perc_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cd2_ts_50p.nc

## restor_fire
cdo -L -div -selyear,2099 ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_grid.nc $MASK ${WORKDIR}totc_restor/t3_carbondensity2_${MOD}_restor-ctl_fire_${SSP}_mask.nc

Rscript --vanilla ${R_CREATE_MASK} ${WORKDIR}totc_restor/t3_carbondensity2_${MOD}_restor-ctl_fire_${SSP}_mask.nc ${COST_FILE} CARBON_DENSITY TRUE

cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_carbondensity2_${MOD}_restor-ctl_fire_${SSP}_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cd2_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cd2_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cd2_ts_50p.nc

cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_grid.nc ${WORKDIR}totc_restor/t3_carbondensity2_${MOD}_restor-ctl_fire_${SSP}_mask.nc ${WORKDIR}totc_restor/t3_carbondensity2_rf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_carbondensity2_rf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_grid_50p.nc ${WORKDIR}totc_restor/t3_carbondensity2_rf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cd2_ts_50p.nc ${WORKDIR}totc_restor/t3_carbondensity2_rf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cd2_ts_50p.nc

cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cd2_ts_50p.nc ${WORKDIR}totc_restor/t3_carbondensity2_rf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc ${WORKDIR}totc_restor/dt3perc_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cd2_ts_50p.nc

## restor
cdo -L -div -selyear,2099 ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_grid.nc $MASK ${WORKDIR}totc_restor/t3_carbondensity2_nf_${MOD}_restor-ctl_${SSP}_mask.nc

Rscript --vanilla ${R_CREATE_MASK} ${WORKDIR}totc_restor/t3_carbondensity2_nf_${MOD}_restor-ctl_${SSP}_mask.nc ${COST_FILE} CARBON_DENSITY TRUE

cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_carbondensity2_nf_${MOD}_restor-ctl_${SSP}_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_cd2_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_cd2_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_cd2_ts_50p.nc

cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_grid.nc ${WORKDIR}totc_restor/t3_carbondensity2_nf_${MOD}_restor-ctl_${SSP}_mask.nc ${WORKDIR}totc_restor/t3_carbondensity2_nf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_carbondensity2_nf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_grid_50p.nc ${WORKDIR}totc_restor/t3_carbondensity2_nf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_cd2_ts_50p.nc ${WORKDIR}totc_restor/t3_carbondensity2_nf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_${SSP}_cd2_ts_50p.nc

cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_${SSP}_cd2_ts_50p.nc ${WORKDIR}totc_restor/t3_carbondensity2_nf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc ${WORKDIR}totc_restor/dt3perc_totalcarbon_${MOD}_restor-ctl_${SSP}_cd2_ts_50p.nc

## restor_fixco2
cdo -L -div -selyear,2099 ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_grid.nc $MASK ${WORKDIR}totc_restor/t3_carbondensity2_rfnf_${MOD}_restor-ctl_fixco2_2014_${SSP}_mask.nc

Rscript --vanilla ${R_CREATE_MASK} ${WORKDIR}totc_restor/t3_carbondensity2_rfnf_${MOD}_restor-ctl_fixco2_2014_${SSP}_mask.nc ${COST_FILE} CARBON_DENSITY TRUE

cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_carbondensity2_rfnf_${MOD}_restor-ctl_fixco2_2014_${SSP}_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_cd2_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_cd2_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_cd2_ts_50p.nc

cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_grid.nc ${WORKDIR}totc_restor/t3_carbondensity2_rfnf_${MOD}_restor-ctl_fixco2_2014_${SSP}_mask.nc ${WORKDIR}totc_restor/t3_carbondensity2_rfnf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_carbondensity2_rfnf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_grid_50p.nc ${WORKDIR}totc_restor/t3_carbondensity2_rfnf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_cd2_ts_50p.nc ${WORKDIR}totc_restor/t3_carbondensity2_rfnf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_cd2_ts_50p.nc

cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_cd2_ts_50p.nc ${WORKDIR}totc_restor/t3_carbondensity2_rfnf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc ${WORKDIR}totc_restor/dt3perc_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_cd2_ts_50p.nc

done 
done

for SSP in ssp126 ssp245 ssp370 ssp585; 
do
for MOD in BCC-CSM2-MR IPSL-CM6A-LR MPI-ESM1-2-HR MRI-ESM2-0 FGOALS-g3 MIROC6 ACCESS-CM2 ACCESS-ESM1-5 AWI-CM-1-1-MR EC-Earth3-Veg INM-CM4-8 INM-CM5-0 CanESM5; 
do
cdo div /home/akoch/terraces/projects/LPJ_futuretropics/totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_carbondensity2_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cd2_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cd2_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cd2_ts_50p.nc

cdo div /home/akoch/terraces/projects/LPJ_futuretropics/totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_carbondensity2_${MOD}_restor-ctl_fire_${SSP}_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cd2_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cd2_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cd2_ts_50p.nc

cdo div /home/akoch/terraces/projects/LPJ_futuretropics/totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_carbondensity2_${MOD}_restor-ctl_${SSP}_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_cd2_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_cd2_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_cd2_ts_50p.nc
done
done


# minimizing cost #############################################################
for SSP in ssp126 ssp245 ssp370 ssp585; 
do
for MOD in BCC-CSM2-MR IPSL-CM6A-LR MPI-ESM1-2-HR MRI-ESM2-0 FGOALS-g3 MIROC6 ACCESS-CM2 ACCESS-ESM1-5 AWI-CM-1-1-MR EC-Earth3-Veg INM-CM4-8 INM-CM5-0 CanESM5; 
do
## restor_fixco2_2014_fire
cdo -L -div -selyear,2099 ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_grid.nc $MASK ${WORKDIR}totc_restor/t3_cheapest2_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_mask.nc

Rscript --vanilla ${R_CREATE_MASK} ${WORKDIR}totc_restor/t3_cheapest2_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_mask.nc ${COST_FILE} COST TRUE

cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_cheapest2_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cheap2_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cheap2_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cheap2_ts_50p.nc

cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_grid.nc ${WORKDIR}totc_restor/t3_cheapest2_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_mask.nc ${WORKDIR}totc_restor/t3_cheapest2_rff_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_cheapest2_rff_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_grid_50p.nc ${WORKDIR}totc_restor/t3_cheapest2_rff_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc 

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cheap2_ts_50p.nc ${WORKDIR}totc_restor/t3_cheapest2_rff_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc  ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cheap2_ts_50p.nc

cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cheap2_ts_50p.nc ${WORKDIR}totc_restor/t3_cheapest2_rff_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc ${WORKDIR}totc_restor/dt3perc_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cheap2_ts_50p.nc

## restor_fire
cdo -L -div -selyear,2099 ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_grid.nc $MASK ${WORKDIR}totc_restor/t3_cheapest2_${MOD}_restor-ctl_fire_${SSP}_mask.nc

Rscript --vanilla ${R_CREATE_MASK} ${WORKDIR}totc_restor/t3_cheapest2_${MOD}_restor-ctl_fire_${SSP}_mask.nc ${COST_FILE} COST TRUE

cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_cheapest2_${MOD}_restor-ctl_fire_${SSP}_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cheap2_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cheap2_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cheap2_ts_50p.nc

cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_grid.nc ${WORKDIR}totc_restor/t3_cheapest2_${MOD}_restor-ctl_fire_${SSP}_mask.nc ${WORKDIR}totc_restor/t3_cheapest2_rf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_cheapest2_rf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_grid_50p.nc ${WORKDIR}totc_restor/t3_cheapest2_rf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cheap2_ts_50p.nc ${WORKDIR}totc_restor/t3_cheapest2_rf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cheap2_ts_50p.nc

cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cheap2_ts_50p.nc ${WORKDIR}totc_restor/t3_cheapest2_rf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc ${WORKDIR}totc_restor/dt3perc_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cheap2_ts_50p.nc

## restor
cdo -L -div -selyear,2099 ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_grid.nc $MASK ${WORKDIR}totc_restor/t3_cheapest2_nf_${MOD}_restor-ctl_${SSP}_mask.nc

Rscript --vanilla ${R_CREATE_MASK} ${WORKDIR}totc_restor/t3_cheapest2_nf_${MOD}_restor-ctl_${SSP}_mask.nc ${COST_FILE} COST TRUE

cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_cheapest2_nf_${MOD}_restor-ctl_${SSP}_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_cheap2_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_cheap2_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_cheap2_ts_50p.nc

cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_grid.nc ${WORKDIR}totc_restor/t3_cheapest2_nf_${MOD}_restor-ctl_${SSP}_mask.nc ${WORKDIR}totc_restor/t3_cheapest2_nf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_cheapest2_nf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_grid_50p.nc ${WORKDIR}totc_restor/t3_cheapest2_nf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_cheap2_ts_50p.nc ${WORKDIR}totc_restor/t3_cheapest2_nf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_${SSP}_cheap2_ts_50p.nc

cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_${SSP}_cheap2_ts_50p.nc ${WORKDIR}totc_restor/t3_cheapest2_nf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc ${WORKDIR}totc_restor/dt3perc_totalcarbon_${MOD}_restor-ctl_${SSP}_cheap2_ts_50p.nc

## restor_fixco2
cdo -L -div -selyear,2099 ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_grid.nc $MASK ${WORKDIR}totc_restor/t3_cheapest2_rfnf_${MOD}_restor-ctl_fixco2_2014_${SSP}_mask.nc

Rscript --vanilla ${R_CREATE_MASK} ${WORKDIR}totc_restor/t3_cheapest2_rfnf_${MOD}_restor-ctl_fixco2_2014_${SSP}_mask.nc ${COST_FILE} COST TRUE

cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_cheapest2_rfnf_${MOD}_restor-ctl_fixco2_2014_${SSP}_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_cheap2_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_cheap2_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_cheap2_ts_50p.nc

cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_grid.nc ${WORKDIR}totc_restor/t3_cheapest2_rfnf_${MOD}_restor-ctl_fixco2_2014_${SSP}_mask.nc ${WORKDIR}totc_restor/t3_cheapest2_rfnf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_cheapest2_rfnf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_grid_50p.nc ${WORKDIR}totc_restor/t3_cheapest2_rfnf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_cheap2_ts_50p.nc ${WORKDIR}totc_restor/t3_cheapest2_rfnf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_cheap2_ts_50p.nc

cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_cheap2_ts_50p.nc ${WORKDIR}totc_restor/t3_cheapest2_rfnf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc ${WORKDIR}totc_restor/dt3perc_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_cheap2_ts_50p.nc
done 
done

for SSP in ssp126 ssp245 ssp370 ssp585; 
do
for MOD in BCC-CSM2-MR IPSL-CM6A-LR MPI-ESM1-2-HR MRI-ESM2-0 FGOALS-g3 MIROC6 ACCESS-CM2 ACCESS-ESM1-5 AWI-CM-1-1-MR EC-Earth3-Veg INM-CM4-8 INM-CM5-0 CanESM5; 
do
cdo div /home/akoch/terraces/projects/LPJ_futuretropics/totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_cheapest2_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cheap2_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cheap2_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_cheap2_ts_50p.nc

cdo div /home/akoch/terraces/projects/LPJ_futuretropics/totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_cheapest2_${MOD}_restor-ctl_fire_${SSP}_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cheap2_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cheap2_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_cheap2_ts_50p.nc

cdo div /home/akoch/terraces/projects/LPJ_futuretropics/totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_cheapest2_${MOD}_restor-ctl_${SSP}_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_cheap2_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_cheap2_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_cheap2_ts_50p.nc
done
done
###########


# maximizing carbon+minimizing cost ###########################################
for SSP in ssp126 ssp245 ssp370 ssp585; 
do
for MOD in BCC-CSM2-MR IPSL-CM6A-LR MPI-ESM1-2-HR MRI-ESM2-0 FGOALS-g3 MIROC6 ACCESS-CM2 ACCESS-ESM1-5 AWI-CM-1-1-MR EC-Earth3-Veg INM-CM4-8 INM-CM5-0 CanESM5; 
do
## restor_fixco2_2014_fire
cdo -L -div -selyear,2099 ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_grid.nc $MASK ${WORKDIR}totc_restor/t3_climcost2_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_mask.nc

Rscript --vanilla ${R_CREATE_MASK} ${WORKDIR}totc_restor/t3_climcost2_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_mask.nc ${COST_FILE} COST_CARBON TRUE

cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_climcost2_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_climcost2_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_climcost2_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_climcost2_ts_50p.nc

cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_grid.nc ${WORKDIR}totc_restor/t3_climcost2_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_mask.nc ${WORKDIR}totc_restor/t3_climcost2_rff_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_climcost2_rff_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_grid_50p.nc ${WORKDIR}totc_restor/t3_climcost2_rff_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc 

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_climcost2_ts_50p.nc ${WORKDIR}totc_restor/t3_climcost2_rff_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc  ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_climcost2_ts_50p.nc

cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_climcost2_ts_50p.nc ${WORKDIR}totc_restor/t3_climcost2_rff_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc ${WORKDIR}totc_restor/dt3perc_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_climcost2_ts_50p.nc

## restor_fire
cdo -L -div -selyear,2099 ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_grid.nc $MASK ${WORKDIR}totc_restor/t3_climcost2_${MOD}_restor-ctl_fire_${SSP}_mask.nc

Rscript --vanilla ${R_CREATE_MASK} ${WORKDIR}totc_restor/t3_climcost2_${MOD}_restor-ctl_fire_${SSP}_mask.nc ${COST_FILE} COST_CARBON TRUE

cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_climcost2_${MOD}_restor-ctl_fire_${SSP}_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_climcost2_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_climcost2_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_climcost2_ts_50p.nc

cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_grid.nc ${WORKDIR}totc_restor/t3_climcost2_${MOD}_restor-ctl_fire_${SSP}_mask.nc ${WORKDIR}totc_restor/t3_climcost2_rf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_climcost2_rf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_grid_50p.nc ${WORKDIR}totc_restor/t3_climcost2_rf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_climcost2_ts_50p.nc ${WORKDIR}totc_restor/t3_climcost2_rf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_climcost2_ts_50p.nc

cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_climcost2_ts_50p.nc ${WORKDIR}totc_restor/t3_climcost2_rf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc ${WORKDIR}totc_restor/dt3perc_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_climcost2_ts_50p.nc

## restor
cdo -L -div -selyear,2099 ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_grid.nc $MASK ${WORKDIR}totc_restor/t3_climcost2_nf_${MOD}_restor-ctl_${SSP}_mask.nc

Rscript --vanilla ${R_CREATE_MASK} ${WORKDIR}totc_restor/t3_climcost2_nf_${MOD}_restor-ctl_${SSP}_mask.nc ${COST_FILE} COST_CARBON TRUE

cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_climcost2_nf_${MOD}_restor-ctl_${SSP}_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_climcost2_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_climcost2_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_climcost2_ts_50p.nc

cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_grid.nc ${WORKDIR}totc_restor/t3_climcost2_nf_${MOD}_restor-ctl_${SSP}_mask.nc ${WORKDIR}totc_restor/t3_climcost2_nf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_climcost2_nf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_grid_50p.nc ${WORKDIR}totc_restor/t3_climcost2_nf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_climcost2_ts_50p.nc ${WORKDIR}totc_restor/t3_climcost2_nf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_${SSP}_climcost2_ts_50p.nc

cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_${SSP}_climcost2_ts_50p.nc ${WORKDIR}totc_restor/t3_climcost2_nf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc ${WORKDIR}totc_restor/dt3perc_totalcarbon_${MOD}_restor-ctl_${SSP}_climcost2_ts_50p.nc

## restor_fixco2
cdo -L -div -selyear,2099 ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_grid.nc $MASK ${WORKDIR}totc_restor/t3_climcost2_rfnf_${MOD}_restor-ctl_fixco2_2014_${SSP}_mask.nc

Rscript --vanilla ${R_CREATE_MASK} ${WORKDIR}totc_restor/t3_climcost2_rfnf_${MOD}_restor-ctl_fixco2_2014_${SSP}_mask.nc ${COST_FILE} COST_CARBON TRUE

cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_climcost2_rfnf_${MOD}_restor-ctl_fixco2_2014_${SSP}_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_climcost2_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_climcost2_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_climcost2_ts_50p.nc

cdo div ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_grid.nc ${WORKDIR}totc_restor/t3_climcost2_rfnf_${MOD}_restor-ctl_fixco2_2014_${SSP}_mask.nc ${WORKDIR}totc_restor/t3_climcost2_rfnf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_climcost2_rfnf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_grid_50p.nc ${WORKDIR}totc_restor/t3_climcost2_rfnf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc

cdo sub ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_climcost2_ts_50p.nc ${WORKDIR}totc_restor/t3_climcost2_rfnf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_climcost2_ts_50p.nc

cdo div ${WORKDIR}totc_restor/dt3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_climcost2_ts_50p.nc ${WORKDIR}totc_restor/t3_climcost2_rfnf_${MOD}_restor-ctl_fixco2_fixclim_2014_fire_${SSP}_ts_50p.nc ${WORKDIR}totc_restor/dt3perc_totalcarbon_${MOD}_restor-ctl_fixco2_2014_${SSP}_climcost2_ts_50p.nc

done 
done

for SSP in ssp126 ssp245 ssp370 ssp585; 
do
for MOD in BCC-CSM2-MR IPSL-CM6A-LR MPI-ESM1-2-HR MRI-ESM2-0 FGOALS-g3 MIROC6 ACCESS-CM2 ACCESS-ESM1-5 AWI-CM-1-1-MR EC-Earth3-Veg INM-CM4-8 INM-CM5-0 CanESM5; 
do
cdo div /home/akoch/terraces/projects/LPJ_futuretropics/totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_climcost2_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_climcost2_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_climcost2_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_climcost2_ts_50p.nc

cdo div /home/akoch/terraces/projects/LPJ_futuretropics/totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_climcost2_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_climcost2_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_climcost2_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_climcost2_ts_50p.nc

cdo div /home/akoch/terraces/projects/LPJ_futuretropics/totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_grid.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_climcost2_mask.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_climcost2_grid_50p.nc

cdo fldsum ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_climcost2_grid_50p.nc ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_${SSP}_climcost2_ts_50p.nc
done
done

