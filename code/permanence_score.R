# Calculate the permanence score for each grid cell based on carbon and cost
library(ncdf4)
source('archived/code/fun_Utility.R')

input_args <- commandArgs(trailingOnly = TRUE)

nc.file <- input_args[1] #"/home/terraces/projects/LPJ_futuretropics/totc_restor/dt3_totalcarbon_CanESM5_restor_fire_ssp585_grid.nc"
restor_area.file <- input_args[2]# "/home/akoch/terraces/projects/LPJ_futuretropics/restor_area_tropics_ha.nc"
restor_cost.file <- input_args[3] #"/home/terraces/projects/LPJ_futuretropics/costs/restoration_cost_1.1_tropics_final.nc"
stable_mask.file <- input_args[4]
out.file <- input_args[5]

stable_mask.m <- nc_read(stable_mask.file)

restor_area.m <- nc_read(restor_area.file)
restor_area.m[restor_area.m < 1] <- NA

var.ar <- nc_read(nc.file)
var2100.m <- var.ar[,,dim(var.ar)[3]]
var2100.m <- var2100.m * stable_mask.m
var2100.m[var2100.m <= 0] <- NA

var2100_density.m <- var2100.m / restor_area.m # convert to density

restor_cost.m <- nc_read(restor_cost.file)
carbon_cost.m <- (restor_cost.m * restor_area.m) / (var2100.m * 1e-6)

# group by carbon (highest carbon has highest value) ##########################
var2100_density.vec <- as.vector(var2100_density.m)
carbon_cost.vec <- as.vector(carbon_cost.m)
var2100.df <- data.frame(id=1:length(var2100_density.vec), 
                         carbon=var2100_density.vec, cost=carbon_cost.vec)

var2100.df <- var2100.df[!is.na(var2100.df$carbon),]
var2100.df <- var2100.df[!is.na(var2100.df$cost),]

var2100.df <- var2100.df[order(var2100.df$carbon, decreasing = FALSE),]
var2100.df$id_carbon <- 1:nrow(var2100.df)

# group by cost ###############################################################
var2100.df <- var2100.df[order(var2100.df$cost, decreasing = TRUE),]
var2100.df$id_cost <- 1:nrow(var2100.df)

# normalize 
var2100.df$score <- (var2100.df$id_carbon + var2100.df$id_cost) / 
  (nrow(var2100.df) * 2)

# convert to matrix
template.m <- var2100.m
template.m[!is.na(template.m)] <- 0
template.m[var2100.df$id] <- var2100.df$score

# add to netdf
out.nc <- nc_open(out.file, write = TRUE)
ncvar_put(out.nc, varid = "tilecarbon", vals = template.m)
nc_close(out.nc)