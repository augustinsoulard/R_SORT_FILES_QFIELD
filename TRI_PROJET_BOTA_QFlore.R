# Définir le dossier de travail
Qflore_path = "//SERVEUR/Etudes/Environnement/Venelles/855-EE-PLU-LA_CRAU/Cartographie/BOTA" ######<=========MODIFIER
#############################################################################################
setwd(Qflore_path)

# Chargement des librairies
if(!require("foreign")){install.packages("foreign")} ; library("foreign")
if(!require("tidyverse")){install.packages("tidyverse")} ; library("tidyverse")
if(!require("sf")){install.packages("sf")} ; library("sf")

# Spécifier le chemin vers votre geopackage
gpkg <- "donnees.gpkg"

# (Optionnel) Afficher la liste des couches disponibles dans le geopackage
print(st_layers(gpkg))

# Lire la couche "habitat" du geopackage
habitat = st_read(gpkg, layer = "habitat")
typologies_habitat = st_read(gpkg, layer = "typologies_habitat")
divers_l = st_read(gpkg, layer = "divers_l")
flore_p  = st_read(gpkg, layer = "flore_p")
photo = st_read(gpkg, layer = "photo")

left_join(habitat,typologies_habitat$Nom)

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

###Joindre les noms à photo

# Jointure de chaque table sur photo
photo_joint <- photo %>%
  left_join(divers_l %>% select(ID, valeur_divers), by = "ID") %>%
  left_join(flore_p %>% select(ID, valeur_flore),  by = "ID") %>%
  left_join(habitat %>% select(ID, valeur_habitat),  by = "ID")

# Fusionner les 3 colonnes en une seule colonne "valeur"
photo_joint <- photo_joint %>%
  mutate(valeur = coalesce(valeur_divers, valeur_flore, valeur_habitat))

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



HAB = read.dbf("Habitats/RELEVE_HABITAT.dbf")

HAB$photo1 = paste0(dossier_destination,"/",str_split(HAB$photo1, "/", simplify = TRUE)[,2])
HAB$photo2 = paste0(dossier_destination,"/",str_split(HAB$photo2, "/", simplify = TRUE)[,2])
HAB$photo3 = paste0(dossier_destination,"/",str_split(HAB$photo3, "/", simplify = TRUE)[,2])
HAB$photo4 = paste0(dossier_destination,"/",str_split(HAB$photo4, "/", simplify = TRUE)[,2])
HAB$photo5 = paste0(dossier_destination,"/",str_split(HAB$photo5, "/", simplify = TRUE)[,2])


######################Création de hablegend
HAB$hablegend = NA_character_
HAB$eunis1 = as.character(HAB$eunis1)
HAB$eunis2 = as.character(HAB$eunis2)
HAB$hablabel = as.character(HAB$hablabel)

left_until_dash <- function(x) {
  if (is.na(x)){return("")} else{
    y = str_sub(x, 1, str_locate(x, "-")[1] - 1)
    return(y)
  }
}

# Fonction pour obtenir la partie droite d'une chaîne après le premier tiret
right_after_dash <- function(x) {
  if (is.na(x)) return("")
  str_sub(x, str_locate(x, "-")[1] + 1, str_length(x))
}

for(i in 1:nrow(HAB)){
  if(is.na(HAB$eunis1[i])){
    HAB$hablegend[i]  = HAB$hablabel[i]
  } else {
    if(is.na(HAB$eunis2[i])){
      if(is.na(HAB$hablabel[i])){
        HAB$hablegend[i] = HAB$eunis1[i]
      } else{
        HAB$hablegend[i] = paste0(left_until_dash(HAB$eunis1[i]),'-',hablabel[i])
      }
      
    }else{
      if(is.na(HAB$hablabel[i])){
        HAB$hablegend[i] = paste0(left_until_dash(HAB$eunis1[i]),'x',left_until_dash(HAB$eunis2[i]),'-',
                               right_after_dash(HAB$eunis1[i]),' x ',right_after_dash(HAB$eunis2[i]))
      } else{
        HAB$hablegend[i] = paste0(left_until_dash(HAB$eunis1[i]),'x',left_until_dash(HAB$eunis2[i]),'-',
                                  HAB$hablabel[i])
      }
    }
  }
}

HAB$hablegend = str_replace_all(HAB$hablegend, "<em>|</em>", "")


############################################

HAB$id = 1:nrow(HAB)

for(i in 1:nrow(HAB)){
  if(HAB$photo1[i] %in% paste0("DCIM_RENOM/",FILES)){
    file.rename(as.character(HAB$photo1[i]),paste0("DCIM_RENOM/",HAB$hablegend[i],HAB$id[i],".jpg"))
  }
  if(HAB$photo2[i] %in% paste0("DCIM_RENOM/",FILES)){
    file.rename(as.character(HAB$photo2[i]),paste0("DCIM_RENOM/",HAB$hablegend[i],HAB$id[i],"_2.jpg"))
  }
  if(HAB$photo3[i] %in% paste0("DCIM_RENOM/",FILES)){
    file.rename(as.character(HAB$photo3[i]),paste0("DCIM_RENOM/",HAB$hablegend[i],HAB$id[i],"_2.jpg"))
  }
  if(HAB$photo4[i] %in% paste0("DCIM_RENOM/",FILES)){
    file.rename(as.character(HAB$photo4[i]),paste0("DCIM_RENOM/",HAB$hablegend[i],HAB$id[i],"_2.jpg"))
  }
  if(HAB$photo5[i] %in% paste0("DCIM_RENOM/",FILES)){
    file.rename(as.character(HAB$photo5[i]),paste0("DCIM_RENOM/",HAB$hablegend[i],HAB$id[i],"_2.jpg"))
  }
}











#### HABITATS_POLYGONES
HAB = read.dbf("Habitats/HABITATS_POLYGONES.dbf")

HAB$photo1 = paste0(dossier_destination,"/",str_split(HAB$photo1, "/", simplify = TRUE)[,2])
HAB$photo2 = paste0(dossier_destination,"/",str_split(HAB$photo2, "/", simplify = TRUE)[,2])
HAB$photo3 = paste0(dossier_destination,"/",str_split(HAB$photo3, "/", simplify = TRUE)[,2])
HAB$photo4 = paste0(dossier_destination,"/",str_split(HAB$photo4, "/", simplify = TRUE)[,2])
HAB$photo5 = paste0(dossier_destination,"/",str_split(HAB$photo5, "/", simplify = TRUE)[,2])


HAB$HABLABEL_COR = HAB$hablabel %>% str_remove_all("<em>") %>% str_remove_all("</em>")

HAB$id = 1:nrow(HAB)

for(i in 1:nrow(HAB)){
  if(HAB$photo1[i] %in% paste0("DCIM_RENOM/",FILES)){
    file.rename(as.character(HAB$photo1[i]),paste0("DCIM_RENOM/",HAB$HABLABEL_COR[i],HAB$id[i],".jpg"))
  }
  if(HAB$photo2[i] %in% paste0("DCIM_RENOM/",FILES)){
    file.rename(as.character(HAB$photo2[i]),paste0("DCIM_RENOM/",HAB$HABLABEL_COR[i],HAB$id[i],"_2.jpg"))
  }
}

