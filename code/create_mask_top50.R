library(ncdf4)
source('archived/code/fun_Utility.R')

input_args <- commandArgs(trailingOnly = TRUE)

r2100.file <- input_args[1] # last time slice of run ; gC per grid cell
restor_cost.file <- input_args[2] # cost file USD/ha
top <- input_args[3] # CARBON_DENSITY; CARBON; COST; COST_CARBON
area <- input_args[4] # TRUE = 50% of area ; FALSE = 50% of all restoration grid cells

restor_area.file <- "archived/data/restor_area_tropics_ha.nc"

r2100.nc <- nc_open(r2100.file, write = TRUE)
r2100.var <- ncvar_get(r2100.nc, varid = "tilecarbon")

restor_area.var <- nc_read(restor_area.file)
restor_cost.var <- nc_read(restor_cost.file)

# remove grid cells with <1 ha restoration area
restor_area.var[restor_area.var < 1] <- NA

# create mask of restoration areas and set <0 to NA as we don't want grid cells
# with less carbon by 2100 than at the start of restoration
restor_mask <- r2100.var * restor_area.var
sprintf("%.0f grid cells below zero (out of %.0f).", length(which(restor_mask < 0)),
        length(which(!is.na(restor_mask))))
restor_mask[restor_mask < 0] <- NA
restor_mask[!is.na(restor_mask)] <- 1
# 
template.df <- data.frame(id=1:length(r2100.var),
                          carbon_gC=as.vector(r2100.var * restor_mask), 
                          area_ha=as.vector(restor_area.var * restor_mask),
                          cost_USD_ha=as.vector(restor_cost.var * restor_mask))
template.df <- template.df[!is.na(template.df$carbon_gC),]

if (top=="CARBON_DENSITY"){
  template.df$carbon_gC_ha <- template.df$carbon_gC / template.df$area_ha
  df <- template.df[order(template.df$carbon_gC_ha, decreasing = TRUE),]}
if (top=="CARBON"){
  df <- template.df[order(template.df$carbon_gC, decreasing = TRUE),]
  print(head(df))
  write.csv(df, "archived/data/totalcarbon.csv", row.names = FALSE)
} 
if (top=="COST"){
  df <- template.df[order(template.df$cost_USD_ha),]
  df <- df[df$carbon > 0,]
  print(head(df))
} 
if (top=="COST_CARBON"){
  # template.df$cost_tC_USD_ha <- (template.df$carbon_gC / 1e6) / 
  #   ((template.df$carbon_gC / 1e6) / 
  #      (template.df$cost_USD_ha * template.df$area_ha * 30)) # AK: using USD per tC as optimized
  template.df$cost_USD_tC <- (template.df$cost_USD_ha * template.df$area_ha * 30) /
    (template.df$carbon_gC / 1E6)
  df <- template.df[order(template.df$cost_USD_tC),]
  df <- df[df$carbon > 0,]
  print(head(df))
  write.csv(df, "archived/data/cost_carbon.csv", row.names = FALSE)
}

# pick threshold
if (area){
  df$cum_area_ha <- cumsum(df$area_ha)
  threshold <- which.min(abs(df$cum_area_ha - (max(df$cum_area_ha) / 2)))  
} else {
  df$cum_carbon_gC <- cumsum(df$carbon_gC)
  threshold <- which.min(abs(df$cum_carbon_gC - median(df$cum_carbon_gC)))
}
idx <- df$id[1:threshold]

r2100.var[idx] <- 1
r2100.var[r2100.var!=1] <- NA

ncvar_put(r2100.nc, varid = "tilecarbon", vals = r2100.var)
nc_close(r2100.nc)