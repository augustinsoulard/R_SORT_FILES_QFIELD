# Chargement des librairies

if(!require("foreign")){install.packages("foreign")} ; library("foreign")
if(!require("tidyverse")){install.packages("tidyverse")} ; library("tidyverse")
if(!require("sf")){install.packages("sf")} ; library("sf")

# Choix du dossier de travail

WD = dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(WD)
path =  paste0(WD,"/")

#Chargement des donnees

FLORE = read.dbf(paste0(path,"Flore/Flore.dbf"))
FLORE$id = 1:nrow(FLORE)
# RP = read.dbf("Flore/FloreDocType.dbf")
# FLORERP = read.dbf("Flore/FloreDocType.dbf")


FILES = list.files("DCIM")
dir.create("DCIM_RENOM")
# Fonction pour copier les fichiers d'un dossier source vers un dossier destination
copier_dossier <- function(source, destination) {
  
  # Créer le dossier destination s'il n'existe pas
  if (!file.exists(destination)) {
    dir.create(destination)
  }
  
  # Copier chaque fichier du dossier source vers le dossier destination
  for (i in 1:length(FILES)) {
    file.copy(paste0("DCIM/",FILES[i]), destination, overwrite = TRUE)
    cat("Fichier : ",FILES[i])
  }
}

# Spécifier les chemins vers les dossiers source (DCIM) et destination (DCIM_RENOM)
dossier_source <- "DCIM"
dossier_destination <- "DCIM_RENOM"

copier_dossier(dossier_source,dossier_destination)

# Appeler la fonction pour copier les fichiers
FLORE$photo1 = paste0(dossier_destination,"/",str_split(FLORE$photo1, "/", simplify = TRUE)[,2])
FLORE$photo2 = paste0(dossier_destination,"/",str_split(FLORE$photo2, "/", simplify = TRUE)[,2])
FLORE$photo3 = paste0(dossier_destination,"/",str_split(FLORE$photo3, "/", simplify = TRUE)[,2])
FLORE$photo4 = paste0(dossier_destination,"/",str_split(FLORE$photo4, "/", simplify = TRUE)[,2])
FLORE$photo5 = paste0(dossier_destination,"/",str_split(FLORE$photo5, "/", simplify = TRUE)[,2])

for(i in 1:nrow(FLORE)){
  cat(FLORE$photo1[i])
  if(FLORE$photo1[i] %in% paste0("DCIM_RENOM/",FILES)){
    file.rename(as.character(FLORE$photo1[i]),paste0("DCIM_RENOM/",FLORE$lb_nom[i],FLORE$id[i],".jpg"))
  }
  if(FLORE$photo2[i] %in% paste0("DCIM_RENOM/",FILES)){
    file.rename(as.character(FLORE$photo2[i]),paste0("DCIM_RENOM/",FLORE$lb_nom[i],FLORE$id[i],"_2.jpg"))
  }
  if(FLORE$photo3[i] %in% paste0("DCIM_RENOM/",FILES)){
    file.rename(as.character(FLORE$photo3[i]),paste0("DCIM_RENOM/",FLORE$lb_nom[i],FLORE$id[i],"_3.jpg"))
  }
  if(FLORE$photo4[i] %in% paste0("DCIM_RENOM/",FILES)){
    file.rename(as.character(FLORE$photo4[i]),paste0("DCIM_RENOM/",FLORE$lb_nom[i],FLORE$id[i],"_4.jpg"))
  }
  if(FLORE$photo5[i] %in% paste0("DCIM_RENOM/",FILES)){
    file.rename(as.character(FLORE$photo5[i]),paste0("DCIM_RENOM/",FLORE$lb_nom[i],FLORE$id[i],"_5.jpg"))
  }
}


HAB = read.dbf(paste0(path,"Habitats/RELEVE_HABITAT.dbf"))
HAB$HABLABEL_COR = HAB$HABLABEL %>% str_remove_all("<em>") %>% str_remove_all("</em>")

HAB$id = 1:nrow(HAB)

for(i in 1:nrow(HAB)){
  cat(HAB$PHOTO1[i])
  if(HAB$PHOTO1[i] %in% paste0("DCIM_RENOM/",FILES)){
    file.rename(as.character(HAB$PHOTO1[i]),paste0("DCIM_RENOM/",HAB$HABLABEL_COR[i],HAB$id[i],".jpg"))
  }
  if(HAB$PHOTO2[i] %in% paste0("DCIM_RENOM/",FILES)){
    file.rename(as.character(HAB$PHOTO2[i]),paste0("DCIM_RENOM/",HAB$HABLABEL_COR[i],HAB$id[i],"_2.jpg"))
  }
}

