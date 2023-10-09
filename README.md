# About
Code to build a 3-Dimensional map of the US showing median income by county. The plot is limited to the 50 states and does not include Puerto Rico or any overseas territories.

The main plot, produced in medium_income_data.R, uses rayshader, ggplot2, and tidycensus. The file annotate.R uses Magick to add a title and captions to the final rendered map.

![test_plot_grid](https://github.com/labonibayen/R-Census-Income/assets/26695981/b1eaca41-8b89-4953-af5d-17881734a5f6)


![titled_final_plot](https://github.com/labonibayen/R-Census-Income/assets/26695981/49bf20ad-eaee-4366-881d-011a62aff60f)

# Notes

The map is first rendered as a 2-Dimensional ggplot. This is where you can decide to include the long/lat grid and configure the size and tick markers of the legend.
