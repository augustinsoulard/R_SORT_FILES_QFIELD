# Chargement des librairies

if(!require("foreign")){install.packages("foreign")} ; library("foreign")
if(!require("tidyverse")){install.packages("tidyverse")} ; library("tidyverse")

# Choix du dossier de travail

WD = dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(WD)
path =  paste0(WD,"/")

#Chargement des donnees

FLORE = read.dbf(paste0(path,"Flore/FloreDocType.dbf"))
FLORE$id = 1:nrow(FLORE)
# RP = read.dbf("Flore/FloreDocType.dbf")
# FLORERP = read.dbf("Flore/FloreDocType.dbf")


FILES = list.files("DCIM")

for(i in 1:nrow(FLORE)){
  cat(FLORE$Photo1[i])
  if(FLORE$Photo1[i] %in% paste0("DCIM/",FILES)){
    file.rename(as.character(FLORE$Photo1[i]),paste0("DCIM/",FLORE$NomComplet[i],FLORE$id[i],".jpg"))
  }
  if(FLORE$Photo2[i] %in% paste0("DCIM/",FILES)){
    file.rename(as.character(FLORE$Photo2[i]),paste0("DCIM/",FLORE$NomComplet[i],FLORE$id[i],"_2.jpg"))
  }
  if(FLORE$Photo3[i] %in% paste0("DCIM/",FILES)){
    file.rename(as.character(FLORE$Photo3[i]),paste0("DCIM/",FLORE$NomComplet[i],FLORE$id[i],"_3.jpg"))
  }
  if(FLORE$Photo4[i] %in% paste0("DCIM/",FILES)){
    file.rename(as.character(FLORE$Photo4[i]),paste0("DCIM/",FLORE$NomComplet[i],FLORE$id[i],"_4.jpg"))
  }
  if(FLORE$Photo5[i] %in% paste0("DCIM/",FILES)){
    file.rename(as.character(FLORE$Photo5[i]),paste0("DCIM/",FLORE$NomComplet[i],FLORE$id[i],"_5.jpg"))
  }
}



HAB = read.dbf(paste0(path,"Habitats/Habitat_FR.dbf"))
HAB$HABLABEL_COR = HAB$HABLABEL %>% str_remove_all("<em>") %>% str_remove_all("</em>")

HAB$id = 1:nrow(HAB)

for(i in 1:nrow(HAB)){
  cat(HAB$PHOTO1[i])
  if(HAB$PHOTO1[i] %in% paste0("DCIM/",FILES)){
    file.rename(as.character(HAB$PHOTO1[i]),paste0("DCIM/",HAB$HABLABEL_COR[i],HAB$id[i],".jpg"))
  }
  if(HAB$PHOTO2[i] %in% paste0("DCIM/",FILES)){
    file.rename(as.character(HAB$PHOTO2[i]),paste0("DCIM/",HAB$HABLABEL_COR[i],HAB$id[i],"_2.jpg"))
  }
}

