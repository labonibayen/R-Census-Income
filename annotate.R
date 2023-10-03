library(magick)
library(ggplot2)
library(glue)
library(stringr)
library(sysfonts)

img <- image_read("counties_med_income.png")

img |> 
  image_crop(gravity = "center",
             geometry = "6000x3500+0-150") |> 
  image_annotate("Median Income by U.S. County",
                 gravity = "northwest",
                 location = "+200+100",
                 color = "#FF69B4",
                 size = 200,
                 weight = 700,
                 font = "mono") |> 
  image_annotate(glue("Data source: 2020 5-year ACS, US Census Bureau"),
                 gravity = "south",
                 location = "+0+250",
                 font = "mono",
                 color = alpha("#808080", .5),
                 size = 70) |> 
  image_write("median_income_titled.png")
