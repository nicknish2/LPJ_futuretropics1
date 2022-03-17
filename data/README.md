# File naming convention
The LPJ-LMfire model output in this archive are named with the following structure:

`GCM` `Shared Socioeconomic Pathway (SSP) scenario` `resolution` `extent` `experiment` `[CO2]` `[fire]`

For example, the file `AWI-CM-1-1-MR_ssp585_30min_global_restor_fixco2_2014_fire.nc` has the following attributes:
| Label         | Value         | Description                                                   |
|---------------|---------------|---------------------------------------------------------------|
| Climate model | AWI-CM-1-1-MR | Alfred Wegener Institute Climate Model v1.1 Medium Resolution |
| SSP           | 585           | SSP 5-8.5                                                     |
| resolution    | 30min         | 30 arc minute (half-degree)                                   |
| extent        | global        |                                                               |
| experiment    | restor        | with forest restoration                                       |
| CO2           | fixco2_2014   | CO2 concentrations fixed at 2014 levels                       |
| fire          | fire          | with fire model turned on (if not present then fire off)      |

