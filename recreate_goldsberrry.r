library(ggplot2)
library(data.table)
library(ncaahoopR)
library(lubridate)
library(gridExtra)
library(grid)
library(cowplot)


# load PBP data with ncaahoopr
dat <- data.table(get_pbp("Dayton", "2019-20" , T))


# subset and process for shot chart data
gf <- dat[shot_team == "Dayton" & free_throw == FALSE & shooter == "Jalen Crutcher"]
gf <- gf[!is.na(shot_x)]
gf[home == shot_team]$shot_y <- 94 - gf[home == shot_team]$shot_y
gf[home == shot_team]$shot_x <- 50 - gf[home == shot_team]$shot_x

gf$shot_outcome <- as.numeric(factor(gf$shot_outcome, levels=c("missed", "made")))-1


#### PLOT ####
### NOTE: Commented Lines were previous attempts or things that work but not quite how I want
### NOTE: need to have ncaahoopr loaded in environment for the court polygons

	p <- ggplot() + 
		# geom_hex(data = gf, aes(x=shot_x, y=shot_y, alpha=..density..), bins=15, color="white") +
		stat_summary_hex(data = gf, geom="hex", aes(x=shot_x, y=shot_y, z=shot_outcome), bins=12, fun="mean", color="white") + 
		# stat_summary_hex(data = gf, geom="text", aes(x=shot_x, y=shot_y, z=shot_outcome, label=..count..), bins=15) + 
		scale_fill_gradient(low =  "#00AFBB", high = "#FC4E07") + 
		# stat_density_2d(data = gf, aes(x = shot_x, y = shot_y, color = stat(density/max(density)), size = stat(density)), geom = "point", contour = FALSE, n = 50) + 
		geom_polygon(data = side_one, aes(x = x, y = y, group = group), col = "gray") + 
		geom_point(alpha = 0.2, size = 1.5) + 
		coord_equal() + 
		xlab("") + 
		ylab("") + 
		# scale_color_viridis_c("Shot Frequency", limits = c(0, 1), breaks = c(0, 1), labels = c("Lower", "Higher"), option = "magma") + 
		# scale_size_continuous(range=c(3,0)) +
		scale_alpha_continuous(range=c(.5,1)) +
		theme_void() + 
		theme(
			axis.text.x = element_blank(), 
			axis.text.y = element_blank(), 
			axis.ticks.x = element_blank(), 
			axis.ticks.y = element_blank(), 
			axis.title = element_blank(), 
			plot.title = element_text(size = 16, hjust = 0.5), 
			plot.subtitle = element_text(size = 12, hjust = 0.5), 
			plot.caption = element_text(size = 8, hjust = 0)
		) + 
		labs(title = paste0(PLAYER, " Shots"), fill = "FG%", caption = "Meyappan Subbaiah (@msubbaiah1) Data Accessed via ncaahoopR")
		






