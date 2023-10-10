
# Definition du repertoire de fichiers
WD = dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(WD)

# Charger les bibliothèques nécessaires
if(!require("sf")){install.packages("sf")} ; library("sf")
if(!require("dplyr")){install.packages("dplyr")} ; library("dplyr")
if(!require("rgdal")){install.packages("rgdal")} ; library("rgdal")

# Charger le fichier shapefile
Flore_biblio <- st_read("Flore/BIBLIO/POINT_2023_10_03_16h45m20.shp")
Flore_biblio$cd_ref = as.character(Flore_biblio$cd_ref)

# Charger le geopackage
Method_enjeu <- st_read("Method_enjeu_PACAv1.4.gpkg")

# Effectuer la jointure en utilisant les champs cd_ref de XXX et CD_NOM de YYY
couche_jointe <- left_join(Flore_biblio, Method_enjeu, by = c("cd_ref" = "CD_NOM"))

# Appliquer un filtre sur une colonne de chaîne de caractères dans la couche jointe
couche_filtre <- couche_jointe %>%
  filter(INTERET_PACA == "FORT" | INTERET_PACA == "MODERE" | INTERET_PACA == "TRES FORT" | INTERET_PACA == "MAJEUR"
         | PROTECTION_PACA == "PN" | PROTECTION_PACA == "PR"  | PROTECTION_PACA == "PD04" | grepl("Aristolochia pistolochia", nom_valide))

# Réexporter la couche filtrée en shapefile
st_write(couche_filtre, "Flore/BIBLIO/Flore_BIBLIO_enjeu.shp")


