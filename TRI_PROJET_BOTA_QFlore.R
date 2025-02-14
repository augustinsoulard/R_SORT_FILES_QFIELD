# Définir le dossier de travail
# Qflore_path = "//SERVEUR/Etudes/Environnement/Venelles/855-EE-PLU-LA_CRAU/Cartographie/BOTA" ######<=========MODIFIER
Qflore_path = "D:/Agence_MTDA/Etudes/855 La Crau/Cartographie/BOTA"
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
eunis = st_read("tables.gpkg", layer = "eunis")

#AJouter les données de typologie dans habitat
typologies_habitat$fid = as.character(1:nrow(typologies_habitat))
habitat = left_join(habitat,typologies_habitat, by = c("Nom"="fid"))

#Joindre les tables EUNIS
habitat = habitat %>% left_join(eunis %>% select(LB_CODE,LB_NOM_1 = LB_HAB_FR), by = c("EUNIS_1"="LB_CODE"))
habitat = habitat %>% left_join(eunis %>% select(LB_CODE,LB_NOM_2 = LB_HAB_FR), by = c("EUNIS_2"="LB_CODE"))
habitat = habitat %>% left_join(eunis %>% select(LB_CODE,LB_NOM_3 = LB_HAB_FR), by = c("EUNIS_3"="LB_CODE"))


# Créer le nom des habitats
construct_label <- function(habitat) {
  
  # Construction de la partie EUNIS
  eunis_part <- paste0(
    ifelse(!is.na(habitat$EUNIS_1) & habitat$EUNIS_1 != "", habitat$EUNIS_1, ""),
    ifelse(!is.na(habitat$EUNIS_2) & habitat$EUNIS_2 != "", paste0("x", habitat$EUNIS_2), ""),
    ifelse(!is.na(habitat$EUNIS_3) & habitat$EUNIS_3 != "", paste0("x", habitat$EUNIS_3), "")
  )
  
  # Construction de la partie label
  label_part <- paste0(
    ifelse(!is.na(habitat$LB_NOM_1) & habitat$LB_NOM_1 != "", habitat$LB_NOM_1, ""),
    ifelse(!is.na(habitat$LB_NOM_2) & habitat$LB_NOM_2 != "", paste0(" x ", habitat$LB_NOM_2), ""),
    ifelse(!is.na(habitat$LB_NOM_3) & habitat$LB_NOM_3 != "", paste0(" x ", habitat$LB_NOM_3), "")
  )
  
  # Construction du résultat final
  if (is.na(habitat$Nom.y) | habitat$Nom.y == "") {
    result <- paste0(eunis_part, "-", label_part)
  } else {
    result <- paste0(ifelse(eunis_part != "", paste0(eunis_part, "-"), ""), habitat$Nom.y)
  }
  
  return(result)
}


# Appliquer la fonction
habitat <- habitat %>%
  rowwise() %>%
  mutate(NomHabitat = construct_label(cur_data()))


# Gestion des dossiers
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
  left_join(divers_l %>% select(uuid, Nomdivers_l = Nom), by = c("Reference"="uuid")) %>%
  left_join(flore_p %>% select(uuid, Nomflore_p = Nom),  by = c("Reference"="uuid")) %>%
  left_join(habitat %>% select(uuid, NomHabitat),  by = c("Reference"="uuid"))

# Fusionner les 3 colonnes en une seule colonne "valeur"
photo_joint <- photo_joint %>%
  mutate(Nomtotal = coalesce(Nomdivers_l, Nomflore_p, NomHabitat))
photo_joint$Nomtotal = paste0(photo_joint$Nomtotal,'_',1:nrow(photo_joint))

# Appeler la fonction pour copier les fichiers
photo_joint$Photo = paste0(dossier_destination,"/",str_split(photo_joint$Photo, "/", simplify = TRUE)[,2])

for(i in 1:nrow(photo_joint)){
  cat(photo_joint$Photo[i])
  if(photo_joint$Photo[i] %in% paste0("DCIM_RENOM/",FILES)){
    file.rename(as.character(photo_joint$Photo[i]),paste0("DCIM_RENOM/",photo_joint$Nomtotal[i],".jpg"))
  }
}

