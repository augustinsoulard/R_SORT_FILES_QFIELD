
#########################TEST FONCTION SEARCH
search_match_BDD <- function(texte){
  # Utilisation de str_split avec un motif pour diviser le texte
  texte_split <- strsplit(texte, " ")[[1]]  # Utilisation de [[1]] pour extraire le vecteur de chaînes
  
  # Ajouter '.*' à chaque élément de texte_split
  texte_split <- paste0(texte_split, '.*')
  
  # Combiner les éléments de texte_split en une seule chaîne de caractères
  texte_pour_grep <- paste(texte_split, collapse = "")
  
  # Utilisation de grep pour trouver les correspondances dans la base de données
  resultats_grep <- baseflor_bryo[grep(texte_pour_grep, baseflor_bryo$NOM_SCIENTIFIQUE, ignore.case = TRUE), ]
  
  return(resultats_grep)
}

# Appel de la fonction avec l'exemple "Que ile"
search_match_BDD("Que ile")
baseflor_bryo[grep("Que.*ile.*", baseflor_bryo$NOM_VALIDE, ignore.case = TRUE), ]
