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
  
#if necessary I could transform my coordinate system, but not necesarry here as both are in 2056 already
#st_transform(feld, crs = 2056)

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

plot(feld)

#Task 3: Annotate Trajectories from vector data
#make a subset for summermonths 01.05-30.06.2015
wildschwein_summer <- wildschwein_BE %>% 
  filter((DatetimeUTC >= as.Date('2015-05-01 00:00:00') & DatetimeUTC <= as.Date('2015-06-30 00:00:00')))
#join both sets
#https://r-spatial.github.io/sf/reference/st_join.html
join_set <- st_join(wildschwein_summer, feld)
plot(join_set)

#visualize the percentage of samples in a given crop per hour.
#round it to the next hour
#use datetimeround

wildschwein_set <-join_set %>%
  st_set_geometry(NULL) %>%
  mutate(datetimeround = lubridate::hour(DatetimeUTC)) %>% 
  group_by(TierName, Frucht, datetimeround ) %>%
  count() %>% 
  ungroup() %>% 
  group_by(TierName, datetimeround) %>% 
  mutate(perc= n/sum(n))  

#datetimeround = lubridate::hour(DatetimeUTC, "hour")
#datetimeround= round_date(DatetimeUTC,  unit = "hour")

#nur die 4 meisten und andere in "others" zusammenfassen 

#install.packages("forcats")
library(forcats)
fct_reorder()
#Lump together factor levels into "other"
fct_lump

    
    
#plot it with geom_bar, coloured by Frucht
    
ggplot(wildschwein_set, mapping= aes(x= datetimeround, y= perc, color= Frucht)) +
  geom_bar(stat="identity",position = "fill")+
  facet_wrap(~TierName)
  
  #same with a polar plot 
ggplot(wildschwein_set, mapping= aes(x= datetimeround, y= perc, fill= Frucht )) +
  geom_bar(stat="identity",position = "fill")+
  coord_polar(theta = "x", start = 0, direction = 1, clip = "on")+
  facet_wrap(~TierName)

ggplot(wildschwein_set, mapping= aes(x= datetimeround, y= perc, fill= Frucht )) +
  coord_polar(theta = "x", start = 0, direction = 1, clip = "on")+
  facet_wrap(~TierName)

 #Task 4: Import and visualize vegetationindex (raster data)
#import vegetationshoehe.tif

str_name<-'MOD16A2_ET_0.05deg_GEO_2008M01.tif' 

read_file<-readTIFF(str_name) 
