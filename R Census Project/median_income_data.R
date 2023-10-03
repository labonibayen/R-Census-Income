library(sf)
library(tigris)
library(tidyverse)
library(stars)
library(rayshader)
library(MetBrewer)
library(colorspace)
library(tidycensus)
library(rayrender)
library(rayshader)

options(tigris_use_cache = TRUE)

#avoid rate limit func
pause <- function(x)
{
  p1 <- proc.time()
  Sys.sleep(x)
  proc.time() - p1
}

#get a list of states, exclude overseas territories
st <- states()
st <- st[st$REGION!=9,]
state_names = st$STATEFP



#load all variables and descriptions
census_vars <- load_variables(2020, "acs5", cache = TRUE)

#initialize empty list to hold all dfs
datalist = vector("list", length = length(state_names))


for (i in 1:51){
  
  pause(1)

  tract <- get_acs(
      geography = "county",
      state=state_names[[i]],
      variables = "B19013_001",
      survey = "acs5",
      year = 2020,
      resolution = "20m",
      geometry = TRUE
    ) 
  
    datalist[[i]] <- tract
  
}

#bind each state's county data
all_counties= do.call(rbind, datalist)

#bring alaska and hawai'i to the viewport
all_counties <- all_counties %>% shift_geometry()

#test empty plot
plot(all_counties$geometry)

#format legend ticks
options(scipen=10000)
library(scales) 

#round down max to the nearest ten thousand, round up 
round_ten_thousand <- function(x) floor(max(x)/10000)*10000
round_ten_thousand_min <- function(x) ceiling(max(x)/10000)*10000


max <- round_ten_thousand(max(all_counties$estimate, na.rm = TRUE))
min <- round_ten_thousand_min(min(all_counties$estimate, na.rm = TRUE))
med <- round_ten_thousand(median(all_counties$estimate, na.rm = TRUE))

graph_breaks <- c(min, med, max)


#plot with color scale
med_income <- ggplot(data = all_counties, aes(fill = estimate)) + 
  geom_sf() + scale_fill_distiller(palette = "RdPu", 
                                  direction = 2, labels = dollar_format(), breaks=graph_breaks) +  labs(fill = "") +  
  guides(fill = guide_colorbar(barwidth = 2 , barheight = 20)) + theme_void()+
  theme(legend.margin=margin(0,0,0,0),
        legend.box.margin=margin(10,10,10,10), plot.background = element_rect(
          fill = "white",
          colour = "white"), legend.text=element_text(size = 15, face="bold"))

#plot with color scale/WITH TITLES + GRID
med_income_w_grid <- ggplot(data = all_counties, aes(fill = estimate)) + 
  geom_sf() + scale_fill_distiller(palette = "RdPu", 
                                   direction = 2, labels = dollar_format(), breaks=graph_breaks)
  guides(fill = guide_colorbar(barwidth = 2 , barheight = 20)) + theme_void()+
  theme(legend.margin=margin(0,0,0,0),
        legend.box.margin=margin(10,10,10,10), plot.background = element_rect(
          fill = "white",
          colour = "white"), legend.text=element_text(size = 15, face="bold")) + labs(title = "Median Income by County, 2020",
                                                                                        caption = "Data source: 2020 5-year ACS, US Census Bureau",
                                                                                        fill = "Median Income Estimate") + theme_void()

#show 2d plot
med_income

#plot in 3d
plot_gg(med_income,
        width=15, height = 15,
        multicore = TRUE, 
        scale=300,
        zoom = 0.5,
        solidbackground = "white",
        background = "white",
        windowsize = c(8000,8000))

render_snapshot()
render_snapshot("counties_med_income.png")
render_highquality("counties_med_income_4k.png", lightdirection = c(270))
render_movie("movie.mp4", title= "Median Income by County")

