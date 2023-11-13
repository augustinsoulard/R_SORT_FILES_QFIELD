# Definition du repertoire de fichiers
WD = dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(WD)

# Charger les bibliothèques nécessaires
if(!require("sf")){install.packages("sf")} ; library("sf")
if(!require("dplyr")){install.packages("dplyr")} ; library("dplyr")
if(!require("rgdal")){install.packages("rgdal")} ; library("rgdal")
if(!require("readxl")){install.packages("readxl")} ; library("readxl")


# Chargement des fichiers
FLORE_MTDA = read_excel("../../ETUDE/BOTA/FLORE_MTDA.xlsx")
FloreDocType = st_read("Flore/FloreDocType.shp")
TAXAQgis <- st_read("DataProjetFlore.gpkg", layer = "TAXAQgis")

# Mise au bon format du CB_NOM
FLORE_MTDA$CD_NOM = as.character(FLORE_MTDA$CD_NOM)

#Jointure de taxaQgis à FloreDoCType
Flore_TAXAQgis <- left_join(FloreDocType, TAXAQgis, by = c("NomComplet" = "LB_NOM"))

# Effectuer la jointure en utilisant les champs cd_ref de XXX et CD_NOM de YYY
Flore_Complet <- left_join(Flore_TAXAQgis, FLORE_MTDA, by = c("CD_NOM" = "CD_NOM"))

# Appliquer un filtre sur une colonne de chaîne de caractères dans la couche jointe FLORE PATRIMONIALE
couche_filtre_PATRI <- Flore_Complet %>%
  filter(`Intérêt patrimonial` == "FORT" | `Intérêt patrimonial` == "MODERE" | `Intérêt patrimonial` == "TRES FORT" | `Intérêt patrimonial` == "MAJEUR"
         | Protection == "PN" | Protection == "PR") #| Protection == "PD04"


# Appliquer un filtre sur une colonne de chaîne de caractères dans la couche jointe EVEE
couche_filtre_EVEE <- Flore_Complet %>%
  filter(`EVEE (INVMED)` == 'Alerte'| `EVEE (INVMED)` == 'Emergente'| `EVEE (INVMED)` == 'Majeure'| `EVEE (INVMED)` == 'Modérée')

# Creation d'un geopackage avec les couches MTDA
st_write(couche_filtre_PATRI,"Postraitement.gpkg",layer="FLORE_MTDA_PATRI", driver = "GPKG")
st_write(couche_filtre_EVEE,"Postraitement.gpkg",layer="FLORE_MTDA_EVEE", driver = "GPKG")
st_write(Flore_Complet,"Postraitement.gpkg",layer="FLORE_MTDA_COMPLET", driver = "GPKG")


