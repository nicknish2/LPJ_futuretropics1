# plot time series of carbon storage
library(ncdf4); library(ggplot2); library(reshape)
source('archived/code/fun_Utility.R')

wdir <- 'archived/data/totc_restor/'

NC2Df <- function(files, varname, scenario){
  
  xname <- gsub("archived/data/totc_restor//t3_totalcarbon_", "", files)
  xname <- gsub(paste0("_restor-ctl_fixco2_fixclim_2014_fire_ts.nc"), "", xname)
  xname <- gsub(paste0("_restor-ctl_fixco2_2014_fire_ssp\\d{3}_ts.nc"), "", xname)
  xname <- gsub(paste0("_restor-ctl_fire_ssp\\d{3}_ts.nc"), "", xname)

  x <- lapply(files, nc_read)
  
  ssp <- vector()
  for (i in 1:length(x)){
    if (grepl(pattern = "ssp126", files[[i]])){ssp[i] <- "SSP1-26"}
    if (grepl(pattern = "ssp245", files[[i]])){ssp[i] <- "SSP2-45"}
    if (grepl(pattern = "ssp370", files[[i]])){ssp[i] <- "SSP3-70"}
    if (grepl(pattern = "ssp585", files[[i]])){ssp[i] <- "SSP5-85"}
    
    x[[i]] <- data.frame(year=2014:2100, 
                         value=x[[i]], 
                         ssp=ssp[i], 
                         model=xname[i], 
                         scenario=scenario, 
                         varname=varname)
  }
  x <- do.call("rbind", x)
  return(x)
}
##############################################################################
## all grid cells #############################################################
all_fixco2.files <- list.files(path = wdir, 
                               pattern = glob2rx("t3_totalcarbon_*_restor-ctl_fixco2_2014_fire_ssp???_ts.nc"), 
                               full.names = TRUE)

all.files <- list.files(path = wdir, 
                        pattern = glob2rx("t3_totalcarbon_*_restor-ctl_fire_ssp???_ts.nc"), 
                        full.names = TRUE)

all_fixco2.df <- NC2Df(files = all_fixco2.files, 
                       varname = "fixed CO2", 
                       scenario = "all grid cells")

all.df <- NC2Df(files = all.files, 
                varname = "transient CO2", 
                scenario = "all grid cells")

## baseline ##################################################################
baseline.files <- list.files(path = wdir, 
                               pattern = glob2rx("t3_totalcarbon_*_restor-ctl_fixco2_fixclim_2014_fire_ts.nc"), 
                               full.names = TRUE)
baseline.df <- NC2Df(files = baseline.files, 
                       varname = "baseline", 
                       scenario = "all grid cells")
baseline.df$ssp <- "baseline"

baseline1.df <- baseline.df
baseline2.df <- baseline.df

baseline1.df$varname <- "fixed CO2"
baseline2.df$varname <- "transient CO2"

plot.df <- rbind(baseline1.df, baseline2.df, all.df, all_fixco2.df)
plot.df$value <- plot.df$value * 1e-15
## add multi-model mean #####################################################
mmm.df <- aggregate.data.frame(plot.df$value, by = list(year=plot.df$year, 
                                                  ssp=plot.df$ssp, 
                                                  scenario=plot.df$scenario, 
                                                  varname=plot.df$varname), 
                               FUN = mean)
mmm.df$model <- "MMM"
names(mmm.df)[grep("x", names(mmm.df))] <- "value"

plot.df <- rbind(plot.df, mmm.df)

## FIRST DERIVATIVE #########################################################
diffmean.df <- plot.df
for (s in c("baseline", "SSP1-26", "SSP2-45", "SSP3-70", "SSP5-85")){
  for (sc in unique(plot.df$varname)){
    diffmean.df$diff[diffmean.df$ssp==s & diffmean.df$varname==sc] <- 
      c(0, diff(diffmean.df$value[diffmean.df$ssp==s & diffmean.df$varname==sc]))
  }
}

## percentage of simulations where carbon is retained

## linear projection of c gains
df_predict <- data.frame(year=NA, diff=NA, varname=NA, ssp=NA)

for (s in c("baseline", "SSP1-26", "SSP2-45", "SSP3-70", "SSP5-85")){
  for (sc in unique(plot.df$varname)){
    df <- diffmean.df[diffmean.df$ssp==s & 
                        diffmean.df$varname==sc & 
                        diffmean.df$model=="MMM" &
                        diffmean.df$year >= 2040,]
    lm.mod <- lm(diff~year, df)
    df_predict <- rbind(df_predict, data.frame(year=2040:2200, 
               diff=as.numeric(predict.lm(lm.mod, newdata = data.frame(year = 2040:2200))), 
               varname=sc, ssp=s))
  }
}
ggplot(df_predict[!is.na(df_predict$diff),], aes(x = year, y = diff, color = ssp)) + 
  geom_line() + theme_bw() + facet_wrap(varname~.)

## PLOT ####################################################################
plot.df$group <- paste0(plot.df$varname, "_", plot.df$model, "_", plot.df$ssp)
plot.df$group <- factor(plot.df$group, levels = unique(plot.df$group))
ssp_col <- c("#626567", '#66A36C', '#3DACC6', '#D28E54', '#C3474E')

plot.df$varname <- factor(plot.df$varname, levels = c("transient CO2", "fixed CO2"))

p1 <- ggplot()
p1 <- p1 + geom_line(data = plot.df, mapping = aes(year, value, colour = ssp, group = group),
                     alpha = 0.2, size = 0.2, show.legend = FALSE)
p1 <- p1 + geom_line(data = plot.df[plot.df$model=="MMM",], 
                     mapping = aes(year, value, colour = ssp, group = group), 
                     stat='identity', size = 0.4, show.legend = TRUE)
p1 <- p1 + scale_color_manual(values = ssp_col, name = '')
p1 <- p1 + labs(title = "Restoration carbon storage", x = "Year", 
                y = "Total biomass carbon (Pg C)") + theme_bw(base_size = 6)
p1 <- p1 + scale_x_continuous(limits = c(2020, 2100))
p1 <- p1 + coord_trans(y = squash_axis(from = 0, to = 15, factor = 5))
p1 <- p1 + facet_wrap(.~varname)

ggsave(paste0(wdir, 'restoration_c_storage_2014-2100_ts.pdf'), 
       plot = p1, device = 'pdf', width = 100, height = 80, units = 'mm', dpi = 300)

### 
diffmean.df$group <- paste0(diffmean.df$varname, "_", diffmean.df$model, "_", plot.df$ssp)
diffmean.df$group <- factor(diffmean.df$group, levels = unique(diffmean.df$group))

diffmean.df$varname <- factor(diffmean.df$varname, levels = c("transient CO2", "fixed CO2"))

p2 <- ggplot()
p2 <- p2 + geom_line(data = diffmean.df, mapping = aes(year, diff, colour = ssp, group = group),
                     alpha = 0.2, size = 0.2, show.legend = FALSE)
p2 <- p2 + geom_line(data = diffmean.df[diffmean.df$model=="MMM",], 
                     mapping = aes(year, diff, colour = ssp, group = group), 
                     stat='identity', size = 0.4, show.legend = TRUE)
p2 <- p2 + scale_color_manual(values = ssp_col, name = '')
p2 <- p2 + labs(title = "Carbon flux into restoration", x = "Year", 
                y = bquote("Total biomass carbon uptake rate (Pg C"~yr^-1*")")) + theme_bw(base_size = 6)
p2 <- p2 + scale_x_continuous(limits = c(2020, 2100)) + scale_y_continuous(limits = c(-0.2,2))
p2 <- p2 + facet_wrap(.~varname)

ggsave(paste0(wdir, 'restoration_c_flux_2014-2100_ts.pdf'), 
       plot = p2, device = 'pdf', width = 100, height = 80, units = 'mm', dpi = 300)

