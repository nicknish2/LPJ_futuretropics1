# Calculate permanence (grid cells with no carbon decline 2030-2100 and no carbon drop >10% long-term mean)
WORKDIR=/home/terraces/projects/LPJ_futuretropics/
AREA=${WORKDIR}restor_area_tropics_ha.nc
COST_FILE=${WORKDIR}costs/restoration_cost_1.1_tropics_final.nc

for SSP in ssp126 ssp245 ssp370 ssp585; 
do
for MOD in BCC-CSM2-MR IPSL-CM6A-LR MPI-ESM1-2-HR MRI-ESM2-0 FGOALS-g3 MIROC6 ACCESS-CM2 ACCESS-ESM1-5 AWI-CM-1-1-MR EC-Earth3-Veg INM-CM4-8 INM-CM5-0 CanESM5; 
do
for VAR in restor_fixco2_2014_fire restor_fire; 
do

cdo -L -selyear,2031/2099 -setctomiss,0 ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_${VAR}_${SSP}_grid.nc ${WORKDIR}permanence/tmpNA.nc

cdo -L -sub -selyear,2099 ${WORKDIR}permanence/tmpNA.nc -selyear,2031 ${WORKDIR}permanence/tmpNA.nc ${WORKDIR}permanence/tmp_diff.nc

cdo -L -setctomiss,0 -expr,"tilecarbon=tilecarbon>0" ${WORKDIR}permanence/tmp_diff.nc ${WORKDIR}permanence/tmp_mask.nc

cdo detrend ${WORKDIR}permanence/tmpNA.nc ${WORKDIR}permanence/tmpDETREND.nc

cdo -L -expr,"tilecarbon=tilecarbon>0" -sub -mulc,0.1 -timmean ${WORKDIR}permanence/tmpDETREND.nc -timmin ${WORKDIR}permanence/tmpDETREND.nc ${WORKDIR}permanence/tmp_mask2.nc 

cdo -L -setctomiss,0 -mul ${WORKDIR}permanence/tmp_mask.nc ${WORKDIR}permanence/tmp_mask2.nc ${WORKDIR}permanence/stable_${MOD}_${VAR}_${SSP}_mask.nc

done 

cdo -L -selyear,2099 ${WORKDIR}permanence/tmpNA.nc ${WORKDIR}permanence/permanence_score_${MOD}_restor_fixco2_2014_fire_${SSP}.nc

Rscript --vanilla /home/akoch/scripts/future_forests/permanence_score.R ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fixco2_2014_fire_${SSP}_grid.nc ${AREA} ${COST_FILE} ${WORKDIR}permanence/stable_${MOD}_restor_fixco2_2014_fire_${SSP}_mask.nc ${WORKDIR}permanence/permanence_score_${MOD}_restor_fixco2_2014_fire_${SSP}.nc

cdo -L -selyear,2099 ${WORKDIR}permanence/tmpNA.nc ${WORKDIR}permanence/permanence_score_${MOD}_restor_fire_${SSP}.nc

Rscript --vanilla /home/akoch/scripts/future_forests/permanence_score.R ${WORKDIR}totc_restor/t3_totalcarbon_${MOD}_restor-ctl_fire_${SSP}_grid.nc ${AREA} ${COST_FILE} ${WORKDIR}permanence/stable_${MOD}_restor_fire_${SSP}_mask.nc ${WORKDIR}permanence/permanence_score_${MOD}_restor_fire_${SSP}.nc

done
done

for SSP in ssp126 ssp245 ssp370 ssp585; 
do
for VAR in restor_fixco2_2014_fire restor_fire; 
do
cdo -L -divc,13 -enssum ${WORKDIR}permanence/stable_*_${VAR}_${SSP}_mask.nc ${WORKDIR}permanence/stable_${VAR}_${SSP}_mask.nc
done
done

for SSP in ssp126 ssp245 ssp370 ssp585; 
do
cdo -L -divc,13 -enssum ${WORKDIR}permanence/permanence_score_*_restor_fixco2_2014_fire_${SSP}.nc ${WORKDIR}permanence/permanence_score_restor_fixco2_2014_fire_${SSP}.nc

cdo -L -divc,13 -enssum ${WORKDIR}permanence/permanence_score_*_restor_fire_${SSP}.nc ${WORKDIR}permanence/permanence_score_restor_fire_${SSP}.nc
done
