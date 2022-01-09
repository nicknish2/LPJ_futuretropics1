library(ncdf4); library(ggplot2); library(reshape)
source('archived/code/fun_Utility.R')

wdir <- 'archived/data/totc_restor/'

NC2Df <- function(files, varname, scenario){
  
  xname <- gsub("archived/data/totc_restor//dt3perc_totalcarbon_", "", files)
  xname <- gsub("archived/data/totc_restor//t3_totalcarbon_", "", xname)
  xname <- gsub(paste0("_", varname, "_ssp\\d{3}_ts.nc"), "", xname)
  xname <- gsub(paste0("_", varname, "_ssp\\d{3}_ts_50p.nc"), "", xname)
  xname <- gsub(paste0("_", varname, "_ssp\\d{3}_cd2_ts_50p.nc"), "", xname)
  xname <- gsub(paste0("_", varname, "_ssp\\d{3}_cheap2_ts_50p.nc"), "", xname)
  xname <- gsub(paste0("_", varname, "_ssp\\d{3}_climcost2_ts_50p.nc"), "", xname)
  
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
  x <- x[x$year==2100,]
  return(x)
}


##############################################################################
## carbon density ############################################################
carbondensity_fixco2.files <- list.files(path = wdir, 
                                         pattern = glob2rx("t3_totalcarbon_*_restor-ctl_fixco2_2014_fire_ssp???_cd2_ts_50p.nc"), 
                                         full.names = TRUE)

carbondensity.files <- list.files(path = wdir, 
                                  pattern = glob2rx("t3_totalcarbon_*_restor-ctl_fire_ssp???_cd2_ts_50p.nc"), 
                                  full.names = TRUE)

carbondensity_fixco2.df <- NC2Df(files = carbondensity_fixco2.files, 
                                 varname = "restor-ctl_fixco2_2014_fire",
                                 scenario = "top 50% carbon")
carbondensity.df <- NC2Df(files = carbondensity.files, 
                          varname = "restor-ctl_fire", 
                          scenario = "top 50% carbon")

## cheapest ###################################################################
cheap_fixco2.files <- list.files(path = wdir, 
                                 pattern = glob2rx("t3_totalcarbon_*_restor-ctl_fixco2_2014_fire_ssp???_cheap2_ts_50p.nc"), 
                                 full.names = TRUE)

cheap.files <- list.files(path = wdir, 
                          pattern = glob2rx("t3_totalcarbon_*_restor-ctl_fire_ssp???_cheap2_ts_50p.nc"), 
                          full.names = TRUE)

cheap_fixco2.df <- NC2Df(files = cheap_fixco2.files, 
                         varname = "restor-ctl_fixco2_2014_fire", 
                         scenario = "cheapest 50%")
cheap.df <- NC2Df(files = cheap.files, 
                  varname = "restor-ctl_fire",
                  scenario = "cheapest 50%")

## climcost ###################################################################
climcost_fixco2.files <- list.files(path = wdir, 
                                    pattern = glob2rx("t3_totalcarbon_*_restor-ctl_fixco2_2014_fire_ssp???_climcost2_ts_50p.nc"), 
                                    full.names = TRUE)

climcost.files <- list.files(path = wdir, 
                             pattern = glob2rx("t3_totalcarbon_*_restor-ctl_fire_ssp???_climcost2_ts_50p.nc"), 
                             full.names = TRUE)

climcost_fixco2.df <- NC2Df(files = climcost_fixco2.files, 
                            varname = "restor-ctl_fixco2_2014_fire", 
                            scenario = "carbon+cost 50%")
climcost.df <- NC2Df(files = climcost.files, 
                     varname = "restor-ctl_fire",
                     scenario = "carbon+cost 50%")

## PLOT ######################################################################
plot.df <- rbind(carbondensity_fixco2.df, carbondensity.df, 
                 cheap_fixco2.df, cheap.df, 
                 climcost_fixco2.df, climcost.df)
plot.df$value <- plot.df$value * 1e-15
plot.df$varname[plot.df$varname=="restor-ctl_fire"] <- "climate change \ntransient CO2 \nwildfire"
plot.df$varname[plot.df$varname=="restor-ctl_fixco2_2014_fire"] <- "climate change \nfixed CO2 \nwildfire"

plot.df$scenario <- factor(plot.df$scenario, levels = c("top 50% carbon",
                                                        "cheapest 50%",
                                                        "carbon+cost 50%"))

lineT <- c(0, 0.5)
names(lineT) <- c("climate change \ntransient CO2 \nwildfire", "climate change \nfixed CO2 \nwildfire")
ssp_col <- c('#66A36C', '#3DACC6', '#D28E54', '#C3474E')
shapeT <- c(0, 1)
names(shapeT) <- c("climate change \ntransient CO2 \nwildfire", "climate change \nfixed CO2 \nwildfire")


p1 <- ggplot(plot.df, aes(x = ssp, y = value, color = ssp, fill = ssp, alpha = varname)) 
p1 <- p1 + geom_boxplot(outlier.size = 1, outlier.alpha = 1)
p1 <- p1 + scale_color_manual(values = ssp_col) + scale_fill_manual(values = ssp_col)
p1 <- p1 + scale_alpha_manual(values = lineT) + scale_shape_manual(guide = FALSE, values = c(shapeT))
p1 <- p1 + theme_bw(base_size = 9) + theme(legend.title = element_blank(), axis.text.x = element_text(angle = 315, hjust = 0.1, vjust = 0.8))
p1 <- p1 + labs(title = bquote("Influence of"~CO[2]*", climate change, and prioritization on carbon uptake"), 
                y = "Cumulative carbon uptake by 2100 (Pg C)", x = "")
p1 <- p1 + scale_y_continuous(limits = c(0, 26), breaks = seq(0, 25, 5))
p1 <- p1 + coord_trans(y = squash_axis(from = 0, to = 12, factor = 6))
p1 <- p1 + facet_wrap(facets = .~scenario, ncol = 3)
ggsave(paste0(wdir, 't3_fixco2_2100_CC_bp.pdf'), 
       plot = p1, device = 'pdf', width = 170, height = 110, units = 'mm', dpi = 300)

plot2.df <- plot.df[plot.df$varname=="restor_fire",]
p2 <- ggplot(plot2.df, aes(x = ssp, y = value, color = ssp)) 
p2 <- p2 + geom_hline(yintercept = 0, linetype = 2, col = "grey") + geom_boxplot(outlier.size = 1)
p2 <- p2 + scale_color_manual(values = ssp_col) 
p2 <- p2 + scale_y_continuous(limits = c(-30, 55), breaks = c(-25, 0, 25, 50))
p2 <- p2 + theme_bw(base_size = 8) + theme(legend.position = "none")
p2 <- p2 + labs(title = "Influence of climate change and prioritization on carbon uptake", 
                subtitle = bquote("(transient"~CO[2]*")"),
                y = "Change w.r.t. baseline (%)", x = "")
p2 <- p2 + facet_wrap(facets = .~scenario)
ggsave(paste0(wdir, 'dt3perc_2100_bp.pdf'), 
       plot = p2, device = 'pdf', width = 120, height = 110, units = 'mm', dpi = 300)

###############################################################################
df <- aggregate.data.frame(x = plot.df$value, 
                           by = list(ssp=plot.df$ssp, scenario=plot.df$scenario, varname=plot.df$varname), 
                           FUN=mean)
df$min <- aggregate.data.frame(x = plot.df$value, 
                               by = list(ssp=plot.df$ssp, scenario=plot.df$scenario, varname=plot.df$varname), 
                               FUN=min)$x
df$max <- aggregate.data.frame(x = plot.df$value, 
                               by = list(ssp=plot.df$ssp, scenario=plot.df$scenario, varname=plot.df$varname), 
                               FUN=max)$x
write.csv(df, paste0(wdir, "t3_ssps_CC.csv"), row.names=F)
###############################################################################
# take plot_bp_t3C_scnearios.R as plot1.df
df <- merge.data.frame(plot.df, plot1.df, by = c("ssp", "model", "scenario", "varname"))
df$diff <- df$value.x -  df$value.y # climate optimized - non-climate

df$varname[df$varname=="restor-ctl_fire"] <- "climate change \ntransient CO2 \nwildfire"
df$varname[df$varname=="restor-ctl_fixco2_2014_fire"] <- "climate change \nfixed CO2 \nwildfire"
write.csv(df, paste0(wdir, "t3_diff_ssps_CC-noCC.csv"), row.names = F)

df <- read.csv(paste0(wdir, "t3_diff_ssps_CC-noCC.csv"))
df$scenario <- factor(df$scenario, level = c("top 50% carbon", "cheapest 50%", "carbon+cost 50%"))
df$diff_perc <- (df$diff / df$value.y) * 100

lineT <- c("twodash", "solid")
ssp_col <- c('#66A36C', '#3DACC6', '#D28E54', '#C3474E')
p1 <- ggplot(df, aes(x = scenario, y = diff, color = ssp, fill = ssp, alpha = varname)) 
p1 <- p1 + geom_boxplot(outlier.size = 1, outlier.alpha = 1)
p1 <- p1 + scale_color_manual(values = ssp_col) 
p1 <- p1 + scale_fill_manual(values = ssp_col) + scale_alpha_manual(values = c(0.5, 0))
p1 <- p1 + theme_bw(base_size = 9) + theme(legend.title = element_blank())
p1 <- p1 + labs(title = bquote("Impact of accounting for climate change in prioritization"), 
                y = "Difference in cumulative carbon uptake by 2100 (Pg C) \nw.r.t. no-climate change prioritization", x = "")
# p1 <- p1 + scale_y_continuous(limits = c(0, 11), breaks = seq(0, 10, 2.5))
p1 <- p1 + scale_y_continuous(limits = c(0, 2), breaks = seq(0, 2, 0.5))
ggsave(paste0(wdir, 't3_diff_2100_CC-noCC_bp.pdf'), 
       plot = p1, device = 'pdf', width = 120, height = 110, units = 'mm', dpi = 300)
