library(ncdf4); library(ggplot2); library(reshape)
source('archived/code/fun_Utility.R')

ssp_col <- c('#66A36C', '#3DACC6', '#D28E54', '#C3474E')
wdir <- 'archived/data/totc_restor/'

NC2Df <- function(files, varname, scenario){

  xname <- gsub("archived/data/totc_restor//dt3perc_totalcarbon_", "", files)
  xname <- gsub("archived/data/totc_restor//t3_totalcarbon_", "", xname)
  xname <- gsub(paste0("_", varname, "_ssp\\d{3}_ts.nc"), "", xname)
  xname <- gsub(paste0("_", varname, "_ssp\\d{3}_ts_50p.nc"), "", xname)
  xname <- gsub(paste0("_", varname, "_ssp\\d{3}_cd_ts_50p.nc"), "", xname)
  xname <- gsub(paste0("_", varname, "_ssp\\d{3}_cheap_ts_50p.nc"), "", xname)
  xname <- gsub(paste0("_", varname, "_ssp\\d{3}_climcost_ts_50p.nc"), "", xname)
  
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
## all grid cells #############################################################
all_fixco2.files <- list.files(path = wdir, 
                                  pattern = glob2rx("t3_totalcarbon_*_restor-ctl_fixco2_2014_fire_ssp???_ts.nc"), 
                                  full.names = TRUE)

all.files <- list.files(path = wdir, 
                           pattern = glob2rx("t3_totalcarbon_*_restor-ctl_fire_ssp???_ts.nc"), 
                           full.names = TRUE)

all_fixco2.df <- NC2Df(files = all_fixco2.files, 
                          varname = "restor-ctl_fixco2_2014_fire", 
                          scenario = "all grid cells")
all.df <- NC2Df(files = all.files, 
                   varname = "restor-ctl_fire", 
                   scenario = "all grid cells")


## carbon density ############################################################
carbondensity_fixco2.files <- list.files(path = wdir, 
                                  pattern = glob2rx("t3_totalcarbon_*_restor-ctl_fixco2_2014_fire_ssp???_cd_ts_50p.nc"), 
                                  full.names = TRUE)

carbondensity.files <- list.files(path = wdir, 
                           pattern = glob2rx("t3_totalcarbon_*_restor-ctl_fire_ssp???_cd_ts_50p.nc"), 
                           full.names = TRUE)

carbondensity_fixco2.df <- NC2Df(files = carbondensity_fixco2.files, 
                                 varname = "restor-ctl_fixco2_2014_fire",
                                 scenario = "top 50% carbon")
carbondensity.df <- NC2Df(files = carbondensity.files, 
                          varname = "restor-ctl_fire", 
                          scenario = "top 50% carbon")

## cheapest ###################################################################
cheap_fixco2.files <- list.files(path = wdir, 
                                         pattern = glob2rx("t3_totalcarbon_*_restor-ctl_fixco2_2014_fire_ssp???_cheap_ts_50p.nc"), 
                                         full.names = TRUE)

cheap.files <- list.files(path = wdir, 
                                  pattern = glob2rx("t3_totalcarbon_*_restor-ctl_fire_ssp???_cheap_ts_50p.nc"), 
                                  full.names = TRUE)

cheap_fixco2.df <- NC2Df(files = cheap_fixco2.files, 
                         varname = "restor-ctl_fixco2_2014_fire", 
                         scenario = "cheapest 50%")
cheap.df <- NC2Df(files = cheap.files, 
                  varname = "restor-ctl_fire",
                  scenario = "cheapest 50%")

## climcost ###################################################################
climcost_fixco2.files <- list.files(path = wdir, 
                                 pattern = glob2rx("t3_totalcarbon_*_restor-ctl_fixco2_2014_fire_ssp???_climcost_ts_50p.nc"), 
                                 full.names = TRUE)

climcost.files <- list.files(path = wdir, 
                          pattern = glob2rx("t3_totalcarbon_*_restor-ctl_fire_ssp???_climcost_ts_50p.nc"), 
                          full.names = TRUE)

climcost_fixco2.df <- NC2Df(files = climcost_fixco2.files, 
                            varname = "restor-ctl_fixco2_2014_fire", 
                            scenario = "carbon+cost 50%")
climcost.df <- NC2Df(files = climcost.files, 
                     varname = "restor-ctl_fire",
                     scenario = "carbon+cost 50%")

## PLOT ######################################################################
plot.df <- rbind(all_fixco2.df, all.df, 
                 carbondensity_fixco2.df, carbondensity.df, 
                 cheap_fixco2.df, cheap.df, 
                 climcost_fixco2.df, climcost.df)
plot.df$value <- plot.df$value * 1e-15

plot.df$varname[plot.df$varname=="restor-ctl_fire"] <- "climate change \ntransient CO2 \nwildfire"
plot.df$varname[plot.df$varname=="restor-ctl_fixco2_2014_fire"] <- "climate change \nfixed CO2 \nwildfire"

plot.df$scenario <- factor(plot.df$scenario, levels = c("all grid cells",
                                                        "top 50% carbon",
                                                        "cheapest 50%",
                                                        "carbon+cost 50%"))

write.csv(plot.df, paste0(wdir, "C_uptake_all_prioritization_2100.csv"), row.names = FALSE)

plot1.df <- plot.df[plot.df$scenario!="all grid cells",]

plot_base <- data.frame(x = c(19.63, 16.06, 19.06), min = c(17.66, 14.33, 17.07), max = c(20.23, 16.82, 19.74), 
                        scenario = c("top 50% carbon",  "cheapest 50%", "carbon+cost 50%"))
plot_base$scenario <- factor(plot_base$scenario, levels = c("top 50% carbon",
                                                            "cheapest 50%",
                                                            "carbon+cost 50%"))


p1 <- ggplot(plot1.df, aes(x = ssp, y = value, color = ssp, fill = ssp, alpha = varname)) 
p1 <- p1 + geom_hline(data = plot_base, mapping = aes(yintercept = x), linetype = 2, col = "grey") 
p1 <- p1 + geom_boxplot(outlier.size = 1, outlier.alpha = 1)
p1 <- p1 + scale_color_manual(values = ssp_col) + scale_fill_manual(values = ssp_col)
p1 <- p1 + scale_alpha_manual(values = c(0.5, 0))
p1 <- p1 + theme_bw(base_size = 9) + theme(legend.title = element_blank(), axis.text.x = element_text(angle = 315, hjust = 0.1, vjust = 0.8))
p1 <- p1 + labs(title = bquote("Influence of"~CO[2]*", climate change, and prioritization on carbon uptake"), 
                y = "Cumulative carbon uptake by 2100 (Pg C)", x = "")
p1 <- p1 + scale_y_continuous(limits = c(0, 26), breaks = seq(0, 25, 5))
p1 <- p1 + coord_trans(y = squash_axis(from = 0, to = 12, factor = 6))
p1 <- p1 + facet_wrap(facets = .~scenario, ncol = 3)
ggsave(paste0(wdir, 't3_fixco2_2100_bp.pdf'), 
       plot = p1, device = 'pdf', width = 170, height = 110, units = 'mm', dpi = 300)

p1 <- ggplot(plot1.df, aes(x = ssp, y = value*100, color = ssp, fill = ssp, alpha = varname)) 
p1 <- p1 + geom_boxplot(outlier.size = 1, outlier.alpha = 1)
p1 <- p1 + scale_color_manual(values = ssp_col) + scale_fill_manual(values = ssp_col)
p1 <- p1 + scale_alpha_manual(values = c(0.5, 0))
p1 <- p1 + theme_bw(base_size = 9) + theme(legend.title = element_blank(), axis.text.x = element_text(angle = 315, hjust = 0.1, vjust = 0.8))
p1 <- p1 + labs(title = bquote("Influence of"~CO[2]*", climate change, and prioritization on carbon uptake"), 
                y = "Change in cumulative carbon uptake by 2100 (%)\nw.r.t. baseline", x = "")
p1 <- p1 + facet_wrap(facets = .~scenario, ncol = 3)
ggsave(paste0(wdir, 'dt3perc_fixco2_2100_bp.pdf'), 
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
ggsave(paste0(wdir, 't3_2100_bp.pdf'), 
       plot = p2, device = 'pdf', width = 120, height = 110, units = 'mm', dpi = 300)


###############################################################################
## how much of the carbon loss due to climate change can be mitigated by accounting 
## for climate change in prioritization?
plot.df <- plot.df[plot.df$varname=="climate change \nfixed CO2 \nwildfire" & plot.df$scenario!="all grid cells",]
baseline <- read.csv(paste0(wdir, "t3_baseline.csv"))
baseline <- baseline[baseline$facet=="no climate" & baseline$scenario!="all grid cells",]
baseline_diff <- merge.data.frame(plot.df, baseline, by = c("model", "scenario"))
baseline_diff$cc_impact <- baseline_diff$value.y - baseline_diff$value.x

df_cc <- read.csv(paste0(wdir, "t3_diff_ssps_CC-noCC.csv"))
df_cc <- df_cc[df_cc$varname=="climate change \nfixed CO2 \nwildfire",]

baseline_diff <- merge.data.frame(baseline_diff, df_cc, by.x = c("model", "scenario", "ssp.x"), 
                                  by.y = c("model", "scenario", "ssp"))
baseline_diff$cc_mitigation <- baseline_diff$diff / baseline_diff$cc_impact

## PLOT

baseline_diff$scenario <- factor(baseline_diff$scenario, levels = c(
                                                        "top 50% carbon",
                                                        "cheapest 50%",
                                                        "carbon+cost 50%"))

lineT <- c("twodash", "solid")
ssp_col <- c('#66A36C', '#3DACC6', '#D28E54', '#C3474E')
p1 <- ggplot(baseline_diff, aes(x = scenario, y = cc_mitigation*100, color = ssp.x, fill = ssp.x, alpha = varname)) 
p1 <- p1 + geom_boxplot(outlier.size = 1, outlier.alpha = 1)
p1 <- p1 + scale_color_manual(values = ssp_col) 
p1 <- p1 + scale_fill_manual(values = ssp_col) + scale_alpha_manual(values = c(0.5, 0))
p1 <- p1 + theme_bw(base_size = 9) + theme(legend.title = element_blank())
p1 <- p1 + labs(title = bquote("Mitigation potential by accounting for climate change in prioritization"), 
                y = "Gain in cumulative carbon uptake by 2100 (%) \nw.r.t. priortization without climate change accounting", x = "")
p1 <- p1 + coord_cartesian(ylim = c(0, 120))
ggsave(paste0(wdir, 't3_CC_mitigation_bp_uncapped.pdf'), 
       plot = p1, device = 'pdf', width = 120, height = 110, units = 'mm', dpi = 300)