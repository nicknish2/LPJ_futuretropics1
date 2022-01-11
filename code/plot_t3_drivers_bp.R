library(ggplot2)
source("/home/ucfaako/Documents/R_code/fun_Utility.R")
ssp_col <- c('#919191','#66A36C', '#3DACC6', '#D28E54', '#C3474E')

df <- read.csv("/home/ucfaako/Documents/future_forests/data/t3_all.csv")
df <- df[df$varname!="restor-ctl_fire",]
df$ssp[is.na(df$ssp)] <- "baseline"

df$varname[df$varname=="fixco2_fixclim_2014_fire"] <- "no climate change \nfixed CO2"
df$varname[df$varname=="restor-ctl"] <- "climate change \ntransient CO2"
df$varname[df$varname=="restor-ctl_fixco2_2014"] <- "climate change \nfixed CO2"
df$varname[df$varname=="restor-ctl_fixco2_2014_fire"] <- "climate change \nfixed CO2 \nwildfires"

df$varname <- factor(df$varname, levels = c("no climate change \nfixed CO2", 
                                            "climate change \ntransient CO2", 
                                            "climate change \nfixed CO2", 
                                            "climate change \nfixed CO2 \nwildfires"))

p1 <- ggplot(df, aes(x = varname, y = value, color = ssp)) 
p1 <- p1 + geom_boxplot(outlier.size = 1)
p1 <- p1 + scale_color_manual(values = ssp_col) 
p1 <- p1 + theme_bw(base_size = 9) + theme(legend.title = element_blank())
p1 <- p1 + labs(title = bquote("Influence of"~CO[2]*", climate change, and wildfire on restoration"), 
                y = "Cumulative carbon uptake by 2100 (Pg C)", x = "")
p1 <- p1 + scale_y_continuous(limits = c(0, 43))
p1 <- p1 + coord_trans(y = squash_axis(from = 0, to = 20, factor = 10))
p1
ggsave(paste0("/home/ucfaako/Documents/future_forests/figures/", 't3_2100_bp.pdf'), 
       plot = p1, device = 'pdf', width = 130, height = 100, units = 'mm', dpi = 300)

## separate drivers ###########################################################
df_diff <- df[df$varname!="no climate change \nfixed CO2",]
df_diff <- merge.data.frame(df_diff, df[df$varname=="no climate change \nfixed CO2",], by = "model", all.x = T)
df_diff$diff <- df_diff$value.x - df_diff$value.y # drivers  - baseline 

df_diff[,c("year.y","varname.y","value.y", "ssp.y", "scenario.y")] <- NULL

df_co2 <- df_diff[df_diff$varname.x=="climate change \ntransient CO2",]
df_clim <- df_diff[df_diff$varname.x=="climate change \nfixed CO2",]
df_fire <- df_diff[df_diff$varname.x=="climate change \nfixed CO2 \nwildfires",]

df_co2$value <- df_co2$diff - df_clim$diff 
df_fire$value <- df_fire$diff - df_clim$diff
df_clim$value <- df_clim$diff

df_co2$varname <- "CO2 fertilization"
df_fire$varname <- "wildfire"
df_clim$varname <- "climate"

df_diff <- rbind(df_co2, df_fire, df_clim)
names(df_diff) <- c("model", "year", "value", "ssp", "scenario", "varname", "diff", "change", "varname_new")
df_diff <- merge.data.frame(df_diff, df[df$varname=="no climate change \nfixed CO2",], by = "model", all.x = T)
df_diff$perc <- abs(df_diff$change / df_diff$value.y)

df_diff$varname_new <- factor(df_diff$varname_new, levels = c("CO2 fertilization", "climate", "wildfire"))
ssp_col2 <- c('#66A36C', '#3DACC6', '#D28E54', '#C3474E')

p2 <- ggplot(df_diff, aes(x = varname_new, y = perc*100, color = ssp.x)) + geom_boxplot()
p2 <- p2 + scale_color_manual(values = ssp_col2) 
p2 <- p2 + theme_bw(base_size = 9) + theme(legend.title = element_blank())
p2 <- p2 + labs(title = "Contribution of CO2 fertilization, climate change, and wildfire \nto uncertainty in carbon uptake", 
                y = "Contribution w.r.t. baseline (%)", x = "")
p2
ggsave(paste0("/home/ucfaako/Documents/future_forests/figures/", 'uncertainty_bp.pdf'), 
       plot = p2, device = 'pdf', width = 130, height = 100, units = 'mm', dpi = 300)