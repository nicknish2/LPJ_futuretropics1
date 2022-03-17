# LPJ-LMfire model output and postprocessing code for tropical forest restoration experiments

This repository contains output from simulations performed with the LPJ-LMfire dynamic global vegetation model to investigate tropical forest restoration under different climate change and CO<sub>2</sub> fertilization scenarios. This output and included code were used to create time series plots and various maps shown in Koch and Kaplan (2022).

Koch, A., & Kaplan, J. O. (2022). Tropical forest restoration under future climate change. _Nature Climate Change_, 12, 279-283. [doi:10.1038/s41558-022-01289-6](https://doi.org/10.1038/s41558-022-01289-6)

The raw model output in this repository amounts to **more than 56GB of data**. Data are stored using the Git Large File Storage (Git LFS) extension. Cloning the repository requires the user to have `git lfs` installed.

The model processing scripts are packaged as `bash` shell scripts calling [NCO](http://nco.sourceforge.net) and [CDO](https://code.mpimet.mpg.de/projects/cdo) routines. All that is (theoretically) needed is to set `$DATADIR` (location of the downloaded data) and `$WORKDIR` (location where the output should be stored). Both can also be set to the same directory. The `R` scripts require the following libraries: `ncdf4`, `ggplot2`, and `reshape`.  

The general workflow is as follows:
1) extract the carbon in the regrowing tile for each time step/scenario for the restoration areas: `ensemble_ts_t3C_restor.sh`
2) calculate the amount of carbon that could be stored after prioritizing for carbon uptake potential (based on current climate), minimizing restoration cost, or both - `climate_cost_optimization.sh`
3) same as 2) but after factoring in climate change impacts at the end of the century - `climate_cost_optimization_CC.sh`
4) calculate most suitable locations for restoration based on cost and climate - `permanence_map2.sh`
5) create the underlying data structure used for plotting the box-whisker plots - `plot_baseline_Cuptake.R`
6) create the box-whisker plot for Fig. 1 - `plot_t3_drivers_bp.R`
7) create the box-whisker plots for Fig. 2 - `plot_bp_t3C_scenarios.R`
8) plot time series for the extended data figure 1 - `plot_carbon_TS_individual.R`

This work is licensed under a
[Creative Commons Attribution-ShareAlike 4.0 International License][cc-by-sa].

[![CC BY-SA 4.0][cc-by-sa-image]][cc-by-sa]

[cc-by-sa]: http://creativecommons.org/licenses/by-sa/4.0/
[cc-by-sa-image]: https://licensebuttons.net/l/by-sa/4.0/88x31.png
[cc-by-sa-shield]: https://img.shields.io/badge/License-CC%20BY--SA%204.0-lightgrey.svg
