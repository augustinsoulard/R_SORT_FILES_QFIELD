library(foreign)
library(tidyverse)

path =  "\\\\SERVEUR/Etudes/Environnement/Venelles/1146-EE-PLUIh-Rhone-Crussol/Cartographie/BOTA/"

FLORE = read.dbf(paste0(path,"Flore/FloreDocType.dbf"))

# RP = read.dbf("Flore/FloreDocType.dbf")
# FLORERP = read.dbf("Flore/FloreDocType.dbf")


FILES = list.files("DCIM")

for(i in 1:nrow(FLORE)){
  cat(FLORE$Photo1[i])
  if(FLORE$Photo1[i] %in% paste0("DCIM/",FILES)){
    file.rename(as.character(FLORE$Photo1[i]),paste0("DCIM/",FLORE$NomComplet[i],".jpg"))
  }
  if(FLORE$Photo2[i] %in% paste0("DCIM/",FILES)){
    file.rename(as.character(FLORE$Photo2[i]),paste0("DCIM/",FLORE$NomComplet[i],"2.jpg"))
  }
}



HAB = read.dbf(paste0(path,"Habitats/Habitat_FR.dbf"))
HAB$HABLABEL_COR = HAB$HABLABEL %>% str_remove_all("<em>") %>% str_remove_all("</em>")

for(i in 1:nrow(HAB)){
  cat(HAB$PHOTO1[i])
  if(HAB$PHOTO1[i] %in% paste0("DCIM/",FILES)){
    file.rename(as.character(HAB$PHOTO1[i]),paste0("DCIM/",HAB$HABLABEL_COR[i],".jpg"))
  }
  if(HAB$PHOTO2[i] %in% paste0("DCIM/",FILES)){
    file.rename(as.character(HAB$PHOTO2[i]),paste0("DCIM/",HAB$HABLABEL_COR[i],"2.jpg"))
  }
}

