library(readr)
library(sf)
library(terra)
library(dplyr)
library(lubridate)
library(ggplot2)
library(tmap)

wildschwein_BE <- read_delim("wildschwein_BE_2056.csv",",") %>%
  st_as_sf(coords = c("E", "N"), crs = 2056, remove = FALSE)

feld <-read_sf("Feldaufnahmen_Fanel.gpkg")

#What information does the dataset contain?
#ID, feld, list of 12x2
#What is the geometry type of the dataset (possible types are: Point, Lines and Polygons)?
#What are the data types of the other columns?
str(feld)
#FieldID: num [1:975] 1 0 0 2 3 5 6 4 7 0 ...
#$ Frucht : chr [1:975] "Roggen" NA NA "Wiese" ...
#$ geom   :sfc_POLYGON of length 975; first list element: List of 1

#What is the coordinate system of the dataset?
#CH1903+ / LV95
st_crs(feld)

#Task 2: Annotate Trajectories from vector data

wildschwein_summer <- wildschwein_BE %>% 
  filter()
