#Téléchargement e tchargement des librairies
if(!require("tidyverse")){install.packages("tidyverse")} ; library("tidyverse")

# Definition du repertoire de fichiers
WD = dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(WD)

#Téléchargement des scripts de l'environnement
url_enjeu_paca = "https://raw.githubusercontent.com/augustinsoulard/ENJEU_FLORE/main/ENJEU_PACA_AUGUSTIN_SOULARD/workflow/Creation_method_enjeu_paca.R"
download.file(url_enjeu_paca, destfile = "Creation_method_enjeu_paca.R" , mode = "wb")



#Téléchargement des données de l'environnement

