/**************************************
          Le fichier MAIN
**************************************/

import Foundation
let MODE = ProcessInfo.processInfo.environment["MODE"]
let PRINT = ProcessInfo.processInfo.environment["PRINT"] // si "cacher" n'affiche pas les plans de jeu

/*************************************
*         DEBUT DU PROGRAMME         *
**************************************/

/* Nom des Joueurs */
print("Nom du joueur 1 :")
let nom_j1 : String = entree()
print("Nom du joueur 2 :")
let nom_j2 : String = entree()
print(nom_j1 + " et " + nom_j2 + " vont s'affronter.\n")
let noms = [nom_j1, nom_j2]

/* Difficulté */
print("\nChoix de la difficulté (Facile, Normal, Difficile, Extreme)")
let tir_max : Int? = entree_difficulte()

/* On affiche le resultat du placement pour faciliter la prochaine étape */
var plan = PlanJeu(iles:[NomOcean.atlantique:[], NomOcean.pacifique:[], NomOcean.indien:[]], bateau_init:[])
plan.afficher(ocean:NomOcean.atlantique)
plan.afficher(ocean:NomOcean.pacifique)
plan.afficher(ocean:NomOcean.indien)

/* Placement des iles */
var iles : [NomOcean:[(Int, Int)]] = [:]
print("\n\nCONSIGNE pour le placement des îles : ( lig1, col1, lig2, col2, ..., lign, coln )\nNombre paire de valeur attendu formant un couple de position. Les positions doivent former une seule et même ile contigue. Au moins 4 positions.")
print("\nPlacez l'ile de l'océan atlantique :")
iles[NomOcean.atlantique] = entree_ile(ocean: NomOcean.atlantique)
print("\nPlacez l'ile de l'océan pacifique :")
iles[NomOcean.pacifique] = entree_ile(ocean: NomOcean.pacifique)
print("\nPlacez l'ile de l'océan indien:")
iles[NomOcean.indien] = entree_ile(ocean: NomOcean.indien)


/* On affiche le resultat du placement pour faciliter la prochaine étape */
plan = PlanJeu(iles:iles, bateau_init:[])
plan.afficher(ocean:NomOcean.atlantique)
plan.afficher(ocean:NomOcean.pacifique)
plan.afficher(ocean:NomOcean.indien)

/* Placement des bateaux */
print("\n\nJoueur 1 : Placez vos bateaux\n(ocean(o1,o2,o3), ligne, colonne, orientation(N,E,S,W))\n")
let j1 = Joueur(nom:nom_j1, iles:iles, bateaux_init:tableau_bateau())

print("\n\nJoueur 2 : Placez vos bateaux\n(ocean(o1,o2,o3), ligne, colonne, orientation(N,E,S,W))\n")
let j2 = Joueur(nom:nom_j2, iles:iles, bateaux_init:tableau_bateau())

var jeu = Jeu(joueurs:[j1,j2], tir_max:tir_max)


/*************************************
*         BOUCLE PRINCIPALE         *
**************************************/

while !jeu.terminer{
  
    print("\n\n\n\n\n    Au tour du joueur", jeu.joueur.nom, "\n")
    if PRINT != "cacher"{
      jeu.afficher_jeu()
    }

    if let tm = tir_max{ // Si la difficulté choisit est differente de Facile
      print("\nIl reste "+String(tm - jeu.joueur.nb_tir)+" missile(s).")
    }

    /* Demande de tir */
    print("\nEn quel position veux-tu tirer : Ocean (o1,o2,o3), Ligne, Colonne :")
    let (ocean, col, lig) = entree_coord()

    /* Réponse en fonction du tir */
    print("\n")
    switch jeu.tirer(ocean:ocean, col:col, lig:lig){
      case .touche: print("TOUCHÉ !")
      case .en_vue: print("EN VUE : Dommage tu as raté mais il y a un bateau sur la même ligne ou colonne.")
      case .coule: print("COULÉ !! Bravo Amiral!\nTu te rapproches de la victoire")
      case .ile: print("Euh amiral c'est une bataille navale !!! Et les bateaux ils sont sur l'eau pas sur les ILES !!")
      case .eau: print("EAU : rien à l'horizon...")
    } 
  
}
print("\n\n\n")
if jeu.joueurs[0].est_perdu{
  print("PARTIE terminé ", noms[1], " a triomphé de ", noms[0], " !")
}else if jeu.joueurs[1].est_perdu{
  print("PARTIE terminé ", noms[0], " a triomphé de ", noms[1])
}else{
  print("PARTIE terminé égalité")
}
