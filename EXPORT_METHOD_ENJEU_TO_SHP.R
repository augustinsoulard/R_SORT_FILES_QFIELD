# Definition du repertoire de fichiers
WD = dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(WD)

# Charger les bibliothèques nécessaires
if(!require("sf")){install.packages("sf")} ; library("sf")
if(!require("dplyr")){install.packages("dplyr")} ; library("dplyr")
if(!require("rgdal")){install.packages("rgdal")} ; library("rgdal")
if(!require("readxl")){install.packages("readxl")} ; library("readxl")


# Chargement du fichier
FLORE_MTDA <- read_excel("../../ETUDE/BOTA/FLORE_MTDA.xlsx")

# Creation d'un geopackage avec la couche FLORE_MTDA
st_write(FLORE_MTDA,"Postraitement.gpkg",layer="FLORE_MTDA", driver = "GPKG")
