library(foreign)

path =  "C:/Users/Augustin Soulard/Documents/Programmation/R/"

FLORE = read.dbf(paste0(path,"Flore/FloreDocType.dbf"))
# HAB = read.dbf("Flore/FloreDocType.dbf")
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

