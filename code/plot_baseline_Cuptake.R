library(ncdf4); library(ggplot2); library(reshape)
source('archived/code/fun_Utility.R')

ssp <- c('ssp126', 'ssp245', 'ssp370', 'ssp585')
ssp_labs <- c('SSP1-26', 'SSP2-45', 'SSP3-70', 'SSP5-85')
names(ssp_labs) <- ssp
scenario <- c('fixco2', 'transientco2')
coln <- paste(rep(scenario, each = length(ssp)), ssp, sep = '_')

tx <- 2014:2100

wdir <- 'archived/data/totc_restor/'

## plot baselines #############################################################
# all grid cells
diff_restor.file <- paste0(wdir, "t3_totalcarbon_restor-ctl_fixco2_fixclim_2014_fire_ensmean.nc")
diff_restor.df <- data.frame(year=tx, 
                             value=nc_read(diff_restor.file, "mean") * 1e-15, 
                             lower=nc_read(diff_restor.file, "min") * 1e-15, 
                             upper=nc_read(diff_restor.file, "max") * 1e-15,
                             baseline="all grid cells")

# top 50% carbon density
diff_carbondensity.file <- paste0(wdir, "t3_totalcarbon_restor-ctl_cd_fixco2_fixclim_2014_fire_ts_50p_ensmean.nc")
diff_carbondensity.df <- data.frame(year=tx, 
                           value=nc_read(diff_carbondensity.file, "mean") * 1e-15, 
                           lower=nc_read(diff_carbondensity.file, "min") * 1e-15, 
                           upper=nc_read(diff_carbondensity.file, "max") * 1e-15,
                           baseline="top 50% carbon density")

# top 50% cost constrained
diff_cheapest_base.file <- paste0(wdir, "t3_totalcarbon_restor-ctl_cheap_fixco2_fixclim_2014_fire_ts_50p_ensmean.nc")
diff_cheapest_base.df <- data.frame(year=tx, 
                                    value=nc_read(diff_cheapest_base.file, "mean") * 1e-15, 
                                    lower=nc_read(diff_cheapest_base.file, "min") * 1e-15, 
                                    upper=nc_read(diff_cheapest_base.file, "max") * 1e-15,
                                    baseline="cheapest 50%")

# top 50% carbon+cost constrained
diff_climcost_base.file <- paste0(wdir, "t3_totalcarbon_restor-ctl_climcost_fixco2_fixclim_2014_fire_ts_50p_ensmean.nc")
diff_climcost_base.df <- data.frame(year=tx, 
                                    value=nc_read(diff_climcost_base.file, "mean") * 1e-15, 
                                    lower=nc_read(diff_climcost_base.file, "min") * 1e-15, 
                                    upper=nc_read(diff_climcost_base.file, "max") * 1e-15,
                                    baseline="carbon+cost 50%")

plot.df <- rbind(diff_restor.df, 
                 diff_base.df, 
                 diff_carbondensity.df, 
                 diff_cheapest_base.df, 
                 diff_climcost_base.df)

plot.df$facet <- "no climate"

# CC impact all grid cells ############################################################
diff_fixco2.file <- list.files(wdir, 
                               pattern = glob2rx("dt3_totalcarbon_restor_fixco2_2014_fire_ssp???_ts_50p_ensmean.nc"),
                               full.names = TRUE)

diff_fixco2.df <- do.call("rbind", 
                          lapply(diff_fixco2.file, FUN = function(x){
                            data.frame(year=2014:2100, 
                                       value=nc_read(x, "mean") * 1e-15, 
                                       lower=nc_read(x, "min") * 1e-15, 
                                       upper=nc_read(x, "max") * 1e-15, 
                                       baseline=x,
                                       facet="fixCO2")
                          }))

diff_fixco2.df$baseline <- gsub("archived/data/totc_restor//dt3_totalcarbon_restor_fixco2_2014_fire_", 
                                "", diff_fixco2.df$baseline)
diff_fixco2.df$baseline <- gsub("_ts_50p_ensmean.nc",
                                "", diff_fixco2.df$baseline)
###
diff_co2.file <- list.files(wdir,
                            pattern = glob2rx("dt3_totalcarbon_restor_fire_ssp???_ts_50p_ensmean.nc"),
                            full.names = TRUE)

diff_co2.df <- do.call("rbind", 
                       lapply(diff_co2.file, FUN = function(x){
                         data.frame(year=2014:2100, 
                                    value=nc_read(x, "mean") * 1e-15, 
                                    lower=nc_read(x, "min") * 1e-15, 
                                    upper=nc_read(x, "max") * 1e-15, 
                                    baseline=x,
                                    facet="CO2")
                       }))

diff_co2.df$baseline <- gsub("archived/data/totc_restor//dt3_totalcarbon_restor_fire_", 
                             "", diff_co2.df$baseline)
diff_co2.df$baseline <- gsub("_ts_50p_ensmean.nc",
                             "", diff_co2.df$baseline)

plot.df <- rbind(plot.df, diff_co2.df, diff_fixco2.df)
# CC impact with carbon optimized mask ########################################
diff_climate_fixco2.file <- list.files(wdir, 
                                        pattern = glob2rx("dt3_totalcarbon_restor_fixco2_2014_fire_ssp???_ts_50p_ensmean.nc"),
                                        full.names = TRUE)

diff_climate_fixco2.df <- do.call("rbind", 
                                   lapply(diff_climate_fixco2.file, FUN = function(x){
                                     data.frame(year=2014:2100, 
                                                value=nc_read(x, "mean") * 1e-15, 
                                                lower=nc_read(x, "min") * 1e-15, 
                                                upper=nc_read(x, "max") * 1e-15, 
                                                baseline=x,
                                                facet="carbon+fixCO2")
                                   }))

diff_climate_fixco2.df$baseline <- gsub("archived/data/totc_restor//dt3_totalcarbon_restor_fixco2_2014_fire_", 
                                         "", diff_climate_fixco2.df$baseline)
diff_climate_fixco2.df$baseline <- gsub("_ts_50p_ensmean.nc",
                                         "", diff_climate_fixco2.df$baseline)
###
diff_climate.file <- list.files(wdir,
                                pattern = glob2rx("dt3_totalcarbon_restor_fire_ssp???_ts_50p_ensmean.nc"),
                                full.names = TRUE)

diff_climate.df <- do.call("rbind", 
                            lapply(diff_climate.file, FUN = function(x){
                              data.frame(year=2014:2100, 
                                         value=nc_read(x, "mean") * 1e-15, 
                                         lower=nc_read(x, "min") * 1e-15, 
                                         upper=nc_read(x, "max") * 1e-15, 
                                         baseline=x,
                                         facet="carbon+CO2")
                            }))

diff_climate.df$baseline <- gsub("archived/data/totc_restor//dt3_totalcarbon_restor_fire_", 
                                  "", diff_climate.df$baseline)
diff_climate.df$baseline <- gsub("_ts_50p_ensmean.nc",
                                  "", diff_climate.df$baseline)

plot.df <- rbind(plot.df, diff_climate.df, diff_climate_fixco2.df)

# CC impact with climate (carbon density) optimized mask #######################
diff_climate_fixco2_cd.file <- list.files(wdir, 
                                       pattern = glob2rx("dt3_totalcarbon_restor_fixco2_2014_fire_ssp???_cd_ts_50p_ensmean.nc"),
                                       full.names = TRUE)

diff_climate_fixco2_cd.df <- do.call("rbind", 
                                  lapply(diff_climate_fixco2_cd.file, FUN = function(x){
                                    data.frame(year=2014:2100, 
                                               value=nc_read(x, "mean") * 1e-15, 
                                               lower=nc_read(x, "min") * 1e-15, 
                                               upper=nc_read(x, "max") * 1e-15, 
                                               baseline=x,
                                               facet="carbon+fixCO2 (carbon density)")
                                  }))

diff_climate_fixco2_cd.df$baseline <- gsub("archived/data/totc_restor//dt3_totalcarbon_restor_fixco2_2014_fire_", 
                                        "", diff_climate_fixco2_cd.df$baseline)
diff_climate_fixco2_cd.df$baseline <- gsub("_cd_ts_50p_ensmean.nc",
                                        "", diff_climate_fixco2_cd.df$baseline)
###
diff_climate_cd.file <- list.files(wdir,
                                pattern = glob2rx("dt3_totalcarbon_restor_fire_ssp???_cd_ts_50p_ensmean.nc"),
                                full.names = TRUE)

diff_climate_cd.df <- do.call("rbind", 
                           lapply(diff_climate_cd.file, FUN = function(x){
                             data.frame(year=2014:2100, 
                                        value=nc_read(x, "mean") * 1e-15, 
                                        lower=nc_read(x, "min") * 1e-15, 
                                        upper=nc_read(x, "max") * 1e-15, 
                                        baseline=x,
                                        facet="carbon+CO2 (carbon density)")
                           }))

diff_climate_cd.df$baseline <- gsub("archived/data/totc_restor//dt3_totalcarbon_restor_fire_", 
                                 "", diff_climate_cd.df$baseline)
diff_climate_cd.df$baseline <- gsub("_cd_ts_50p_ensmean.nc",
                                 "", diff_climate_cd.df$baseline)

plot.df <- rbind(plot.df, diff_climate_cd.df, diff_climate_fixco2_cd.df)

# CC impact with cheapest optimized mask ##################################
diff_cheap_fixco2.file <- list.files(wdir, 
                                 pattern = glob2rx("dt3_totalcarbon_restor_fixco2_2014_fire_ssp???_cheap_ts_50p_ensmean.nc"),
                                 full.names = TRUE)

diff_cheap_fixco2.df <- do.call("rbind", 
                                   lapply(diff_cheap_fixco2.file, FUN = function(x){
                                     data.frame(year=2014:2100, 
                                                value=nc_read(x, "mean") * 1e-15, 
                                                lower=nc_read(x, "min") * 1e-15, 
                                                upper=nc_read(x, "max") * 1e-15, 
                                                baseline=x,
                                                facet="cheapest+carbon+fixCO2")
                                   }))

diff_cheap_fixco2.df$baseline <- gsub("archived/data/totc_restor//dt3_totalcarbon_restor_fixco2_2014_fire_", 
                                  "", diff_cheap_fixco2.df$baseline)
diff_cheap_fixco2.df$baseline <- gsub("_cheap_ts_50p_ensmean.nc",
                                  "", diff_cheap_fixco2.df$baseline)

###
diff_cheap.file <- list.files(wdir,
                                 pattern = glob2rx("dt3_totalcarbon_restor_fire_ssp???_cheap_ts_50p_ensmean.nc"),
                                 full.names = TRUE)

diff_cheap.df <- do.call("rbind", 
                                lapply(diff_cheap.file, FUN = function(x){
                                  data.frame(year=2014:2100, 
                                             value=nc_read(x, "mean") * 1e-15, 
                                             lower=nc_read(x, "min") * 1e-15, 
                                             upper=nc_read(x, "max") * 1e-15, 
                                             baseline=x,
                                             facet="cheapest+carbon+CO2")
                                }))

diff_cheap.df$baseline <- gsub("archived/data/totc_restor//dt3_totalcarbon_restor_fire_", 
                                                               "", diff_cheap.df$baseline)
diff_cheap.df$baseline <- gsub("_cheap_ts_50p_ensmean.nc",
                                  "", diff_cheap.df$baseline)

plot.df <- rbind(plot.df, diff_cheap.df, diff_cheap_fixco2.df)

# CC impact with carbon+cost optimized mask ##################################
diff_climcost_fixco2.file <- list.files(wdir, 
                                     pattern = glob2rx("dt3_totalcarbon_restor_fixco2_2014_fire_ssp???_climcost_ts_50p_ensmean.nc"),
                                     full.names = TRUE)

diff_climcost_fixco2.df <- do.call("rbind", 
                                lapply(diff_climcost_fixco2.file, FUN = function(x){
                                  data.frame(year=2014:2100, 
                                             value=nc_read(x, "mean") * 1e-15, 
                                             lower=nc_read(x, "min") * 1e-15, 
                                             upper=nc_read(x, "max") * 1e-15, 
                                             baseline=x,
                                             facet="cost+carbon+fixCO2")
                                }))

diff_climcost_fixco2.df$baseline <- gsub("archived/data/totc_restor//dt3_totalcarbon_restor_fixco2_2014_fire_", 
                                      "", diff_climcost_fixco2.df$baseline)
diff_climcost_fixco2.df$baseline <- gsub("_climcost_ts_50p_ensmean.nc",
                                      "", diff_climcost_fixco2.df$baseline)

###
diff_climcost.file <- list.files(wdir,
                              pattern = glob2rx("dt3_totalcarbon_restor_fire_ssp???_climcost_ts_50p_ensmean.nc"),
                              full.names = TRUE)

diff_climcost.df <- do.call("rbind", 
                         lapply(diff_climcost.file, FUN = function(x){
                           data.frame(year=2014:2100, 
                                      value=nc_read(x, "mean") * 1e-15, 
                                      lower=nc_read(x, "min") * 1e-15, 
                                      upper=nc_read(x, "max") * 1e-15, 
                                      baseline=x,
                                      facet="cost+carbon+CO2")
                         }))

diff_climcost.df$baseline <- gsub("archived/data/totc_restor//dt3_totalcarbon_restor_fire_", 
                               "", diff_climcost.df$baseline)
diff_climcost.df$baseline <- gsub("_climcost_ts_50p_ensmean.nc",
                               "", diff_climcost.df$baseline)

plot.df <- rbind(plot.df, diff_climcost.df, diff_climcost_fixco2.df)

###############################################################################
## carbon uptake optimization considering climate change
###############################################################################
### carbon density ############################################################
diff_climate_fixco2_cd2.file <- list.files(wdir, 
                                          pattern = glob2rx("dt3_totalcarbon_restor_fixco2_2014_fire_ssp???_cd2_ts_50p_ensmean.nc"),
                                          full.names = TRUE)

diff_climate_fixco2_cd2.df <- do.call("rbind", 
                                     lapply(diff_climate_fixco2_cd2.file, FUN = function(x){
                                       data.frame(year=2014:2100, 
                                                  value=nc_read(x, "mean") * 1e-15, 
                                                  lower=nc_read(x, "min") * 1e-15, 
                                                  upper=nc_read(x, "max") * 1e-15, 
                                                  baseline=x,
                                                  facet="carbon+fixCO2 (carbon density) (CC)")
                                     }))

diff_climate_fixco2_cd2.df$baseline <- gsub("archived/data/totc_restor//dt3_totalcarbon_restor_fixco2_2014_fire_", 
                                           "", diff_climate_fixco2_cd2.df$baseline)
diff_climate_fixco2_cd2.df$baseline <- gsub("_cd2_ts_50p_ensmean.nc",
                                           "", diff_climate_fixco2_cd2.df$baseline)

###

diff_climate_cd2.file <- list.files(wdir,
                                   pattern = glob2rx("dt3_totalcarbon_restor_fire_ssp???_cd2_ts_50p_ensmean.nc"),
                                   full.names = TRUE)

diff_climate_cd2.df <- do.call("rbind", 
                              lapply(diff_climate_cd2.file, FUN = function(x){
                                data.frame(year=2014:2100, 
                                           value=nc_read(x, "mean") * 1e-15, 
                                           lower=nc_read(x, "min") * 1e-15, 
                                           upper=nc_read(x, "max") * 1e-15, 
                                           baseline=x,
                                           facet="carbon+CO2 (carbon density) (CC)")
                              }))

diff_climate_cd2.df$baseline <- gsub("archived/data/totc_restor//dt3_totalcarbon_restor_fire_", 
                                    "", diff_climate_cd2.df$baseline)
diff_climate_cd2.df$baseline <- gsub("_cd2_ts_50p_ensmean.nc",
                                    "", diff_climate_cd2.df$baseline)

plot.df <- rbind(plot.df, diff_climate_cd2.df, diff_climate_fixco2_cd2.df)

## cheapest ##################################################################
diff_cheap2_fixco2.file <- list.files(wdir, 
                                     pattern = glob2rx("dt3_totalcarbon_restor_fixco2_2014_fire_ssp???_cheap2_ts_50p_ensmean.nc"),
                                     full.names = TRUE)

diff_cheap2_fixco2.df <- do.call("rbind", 
                                lapply(diff_cheap2_fixco2.file, FUN = function(x){
                                  data.frame(year=2014:2100, 
                                             value=nc_read(x, "mean") * 1e-15, 
                                             lower=nc_read(x, "min") * 1e-15, 
                                             upper=nc_read(x, "max") * 1e-15, 
                                             baseline=x,
                                             facet="cheapest+carbon+fixCO2 (CC)")
                                }))

diff_cheap2_fixco2.df$baseline <- gsub("archived/data/totc_restor//dt3_totalcarbon_restor_fixco2_2014_fire_", 
                                      "", diff_cheap2_fixco2.df$baseline)
diff_cheap2_fixco2.df$baseline <- gsub("_cheap2_ts_50p_ensmean.nc",
                                      "", diff_cheap2_fixco2.df$baseline)

###
diff_cheap2.file <- list.files(wdir,
                              pattern = glob2rx("dt3_totalcarbon_restor_fire_ssp???_cheap2_ts_50p_ensmean.nc"),
                              full.names = TRUE)

diff_cheap2.df <- do.call("rbind", 
                         lapply(diff_cheap2.file, FUN = function(x){
                           data.frame(year=2014:2100, 
                                      value=nc_read(x, "mean") * 1e-15, 
                                      lower=nc_read(x, "min") * 1e-15, 
                                      upper=nc_read(x, "max") * 1e-15, 
                                      baseline=x,
                                      facet="cheapest+carbon+CO2 (CC)")
                         }))

diff_cheap2.df$baseline <- gsub("archived/data/totc_restor//dt3_totalcarbon_restor_fire_", 
                               "", diff_cheap2.df$baseline)
diff_cheap2.df$baseline <- gsub("_cheap2_ts_50p_ensmean.nc",
                               "", diff_cheap2.df$baseline)

plot.df <- rbind(plot.df, diff_cheap2.df, diff_cheap2_fixco2.df)

## carbon+cost ###############################################################
diff_climcost2_fixco2.file <- list.files(wdir, 
                                        pattern = glob2rx("dt3_totalcarbon_restor_fixco2_2014_fire_ssp???_climcost2_ts_50p_ensmean.nc"),
                                        full.names = TRUE)

diff_climcost2_fixco2.df <- do.call("rbind", 
                                   lapply(diff_climcost2_fixco2.file, FUN = function(x){
                                     data.frame(year=2014:2100, 
                                                value=nc_read(x, "mean") * 1e-15, 
                                                lower=nc_read(x, "min") * 1e-15, 
                                                upper=nc_read(x, "max") * 1e-15, 
                                                baseline=x,
                                                facet="cost+carbon+fixCO2 (CC)")
                                   }))

diff_climcost2_fixco2.df$baseline <- gsub("archived/data/totc_restor//dt3_totalcarbon_restor_fixco2_2014_fire_", 
                                         "", diff_climcost2_fixco2.df$baseline)
diff_climcost2_fixco2.df$baseline <- gsub("_climcost2_ts_50p_ensmean.nc",
                                         "", diff_climcost2_fixco2.df$baseline)

###
diff_climcost2.file <- list.files(wdir,
                                 pattern = glob2rx("dt3_totalcarbon_restor_fire_ssp???_climcost2_ts_50p_ensmean.nc"),
                                 full.names = TRUE)

diff_climcost2.df <- do.call("rbind", 
                            lapply(diff_climcost2.file, FUN = function(x){
                              data.frame(year=2014:2100, 
                                         value=nc_read(x, "mean") * 1e-15, 
                                         lower=nc_read(x, "min") * 1e-15, 
                                         upper=nc_read(x, "max") * 1e-15, 
                                         baseline=x,
                                         facet="cost+carbon+CO2 (CC)")
                            }))

diff_climcost2.df$baseline <- gsub("archived/data/totc_restor//dt3_totalcarbon_restor_fire_", 
                                  "", diff_climcost2.df$baseline)
diff_climcost2.df$baseline <- gsub("_climcost2_ts_50p_ensmean.nc",
                                  "", diff_climcost2.df$baseline)

plot.df <- rbind(plot.df, diff_climcost2.df, diff_climcost2_fixco2.df)

###############################################################################

plot.df$facet <- factor(plot.df$facet, levels = c("fixCO2",
                                                  "CO2",
                                                  "carbon+fixCO2",
                                                  "carbon+CO2",
                                                  "carbon+fixCO2 (carbon density)",
                                                  "carbon+CO2 (carbon density)",
                                                  "cheapest+carbon+fixCO2", 
                                                  "cheapest+carbon+CO2",
                                                  "cost+carbon+fixCO2",
                                                  "cost+carbon+CO2",
                                                  "carbon+fixCO2 (CC)",
                                                  "carbon+CO2 (CC)",
                                                  "carbon+fixCO2 (carbon density) (CC)",
                                                  "carbon+CO2 (carbon density) (CC)",
                                                  "cheapest+carbon+fixCO2 (CC)", 
                                                  "cheapest+carbon+CO2 (CC)",
                                                  "cost+carbon+fixCO2 (CC)",
                                                  "cost+carbon+CO2 (CC)",
                                                  "no climate"))
lvls <- c("all grid cells", "top 50% carbon", "top 50% carbon density", "cheapest 50%", "carbon+cost 50%",
          "ssp126", "ssp245", "ssp370", "ssp585")
plot.df$baseline <- factor(plot.df$baseline, 
                           levels = lvls)
lab_names <- c("all grid cells", "top 50% carbon", "top 50% carbon density", "cheapest 50%", "carbon+cost 50%",
               "SSP1-26", "SSP2-45", "SSP3-70", "SSP5-85")
names(lab_names) <- lvls
col_pal <- c("#e41a1c", "#377eb8", "#4daf4a", "#984ea3", "#ff7f00")
plot.df[plot.df$year==2050,]
plot.df[plot.df$year==2100,]

write.csv(plot.df[plot.df$year==2100,], paste0(wdir, "t3_baseline.csv"), 
          row.names = FALSE)
