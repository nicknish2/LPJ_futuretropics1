# LPJ_futuretropics

Package containing output from LPJ-LMfire simulations of tropical forest restoration under different climate change and CO<sub>2</sub> fertilization scenarios and code to create time series and various maps as shown in the manuscript "Impact of future climate change on tropical forest restoration" (DOI: XXXX).

Extraction scripts are packaged as bash files calling NCO and CDO routines. All that is (theoretically) needed is to set `$DATADIR` (location of the downloaded data) and `$WORKDIR` (location where the output should be stored). Both can also be set to the same directory. The `R` scripts require the following libraries: `ncdf4`, `ggplot2`, and `reshape`.  

The general workflow is as follows:
1) extract the carbon in the regrowing tile for each time step/scenario for the restoration areas: `ensemble_ts_t3C_restor.sh`
2) calculate the amount of carbon that could be stored after prioritizing for carbon uptake potential (based on current climate), minimizing restoration cost, or both - `climate_cost_optimization.sh`
3) same as 2) but after factoring in climate change impacts at the end of the century - `climate_cost_optimization_CC.sh`
4) calculate most suitable locations for restoration based on cost and climate - `permanence_map2.sh`
5) create the underlying data structure used for plotting the box-whisker plots - `plot_baseline_Cuptake.R`
6) create the box-whisker plot for Fig. 1 - `plot_t3_drivers_bp.R`
7) create the box-whisker plots for Fig. 2 - `plot_bp_t3C_scenarios.R`
8) plot time series for the extended data figure 1 - `plot_carbon_TS_individual.R`
