/**************************************
          Le fichier JEU
**************************************/

/*************************************
*          TYPE ABSTRAIT             *
**************************************/

protocol JeuProtocol{
  
  init(joueurs:[JoueurProtocol], tir_max:Int?) 
  /*
    init : {Joueur} x (Int | Vide) -> Jeu
    premier parametre : tableau contenant les joueurs
    deuxieme parametre: nombre de missile max ou nil si infini
  */
  
  var joueurs : [JoueurProtocol] {get}
  /*
    joueurs : Jeu -> {Joueur}
    Tableau contenant l'ensemble des joueurs de la partie.
    J = init(noms, iles, bat, tir) => joueurs.count == bat.count == noms.count
  */

  var joueur_tour : Int {get}
  /*
    joueur_tour : Jeu -> Int
    Indique le joueur qui doit effectuer le prochain tir
    init(noms, iles, bat, tir) => joueur_tour == 0
  */

  var joueur : JoueurProtocol {get}
  /*
    joueur : Jeu -> Joueur
    Copie du joueur qui doit jouer, permet de recuperer les info comme son nom ou nb_tir plus facilement
  */

  var terminer : Bool {get} 
  /*
    terminer : Jeu -> Bool
    terminer == true  => il existe un joueur j tel que j.est_gagne == true ou pour tout joueur j, j.nb_tir >= tir_max
  */
  
  var tir_max : Int? {get} 
  /*
    tir_max : Jeu -> (Int | Vide)
    Nombre de tir maximum par joueur
    J = init(iles, bat, tir) => tir_max == tir
    tir_max == Vide => La difficulté choisit est Facile
  */
  
  mutating func tirer(ocean:NomOcean, col:Int, lig:Int) -> ResTir 
  /*
    tirer : Jeu x NomOcean x Int x Int -> Restir
    Precondition : 
      (col, lig) appartient à l'océan en question, Le tir doit donc être valide.
    Postcondition :
      Permet d'effectuer un tir sur le joueur cible de la part du joueur qui tire
      tirer(o,c,l) == Restir.touche => le joueur cible avait un bateau non touche sur l'ocean o, la colonne c et la ligne c
                   == Restir.coule => idem mais la case touche etait la derniere du bateau
                   == Restir.en_vue => le joueur cible a un bateau sur la mm ligne ou colonne
                   == Restir.eau => sinon
      tirer(o,c,l) => joueur_tour passe à l'autre joueur                                 
  */
  
  func afficher_jeu() 
  /*
    Affiche les plans de jeu et de tir du joueur qui doit effectuer le prochain tir
    Les plans de jeu correspondent à ses océans alors que les plans de tir correspondent aux océans de la cible
  */
}




/*************************************
*           TYPE CONCRET             *
**************************************/


struct Jeu:JeuProtocol{

  public private (set) var joueurs : [JoueurProtocol]
  /*
    joueurs : Jeu -> {Joueur}
    Tableau contenant l'ensemble des joueurs de la partie.
    J = init(noms, iles, bat, tir) => joueurs.count == bat.count == noms.count
  */

  public private (set) var tir_max : Int?
  /*
    tir_max : Jeu -> (Int | Vide)
    Nombre de tir maximum par joueur
    J = init(iles, bat, tir) => tir_max == tir
    tir_max == Vide => La difficulté choisit est Facile
  */

  public private (set) var joueur_tour : Int
  /*
    joueur_tour : Jeu -> Int
    Indique le joueur qui doit effectuer le prochain tir
    init(noms, iles, bat, tir) => joueur_tour == 0
  */

  private var joueur_cible : Int { 
    return (self.joueur_tour + 1) % 2
  }

  public var joueur : JoueurProtocol{
  /*
    joueur : Jeu -> Joueur
    Copie du joueur qui doit jouer, permet de recuperer les info comme son nom ou nb_tir plus facilement
  */
    return self.joueurs[joueur_tour]
  }

  public var terminer : Bool{
  /*
    terminer : Jeu -> Bool
    terminer == true  => il existe un joueur j tel que j.est_gagne == true ou pour tout joueur j, j.nb_tir >= tir_max
  */
    var j = 0
    while j < self.joueurs.count{ // il existe un joueur j tel que j.est_gagne == true
      if joueurs[j].est_perdu{return true}
      j += 1
    }

    guard let tir_m = self.tir_max else{ // si il n'y a pas de limite de tir
      return false
    }
    
    j = 0
    while j < self.joueurs.count{
      if joueurs[j].nb_tir < tir_m{ // si il reste des tirs au joueur
        return false
      }
      j += 1
    }
    return true
  }

  init(joueurs:[JoueurProtocol], tir_max:Int?){
  /*
    init : {Joueur} x (Int | Vide) -> Jeu
    premier parametre : tableau contenant les joueurs
    deuxieme parametre: nombre de missile max ou nil si infini
  */
    self.tir_max = tir_max
    self.joueur_tour = 0
    self.joueurs = joueurs
    
  }

  public mutating func tirer(ocean:NomOcean, col:Int, lig:Int) -> ResTir{
  /*
    tirer : Jeu x NomOcean x Int x Int -> Restir
    Precondition : 
      (col, lig) appartient à l'océan en question, Le tir doit donc être valide.
    Postcondition :
      Permet d'effectuer un tir sur le joueur cible de la part du joueur qui tire
      tirer(o,c,l) == Restir.touche => le joueur cible avait un bateau non touche sur l'ocean o, la colonne c et la ligne c
                   == Restir.coule => idem mais la case touche etait la derniere du bateau
                   == Restir.en_vue => le joueur cible a un bateau sur la mm ligne ou colonne
                   == Restir.eau => sinon
      tirer(o,c,l) => joueur_tour passe à l'autre joueur                                 
  */
    let resultat_tir = joueurs[self.joueur_cible].tirer(ocean:ocean, col:col, lig:lig)
    joueurs[self.joueur_tour].nb_tir += 1
    self.joueur_tour = (self.joueur_tour + 1) % 2
    return resultat_tir
  }

  public func afficher_jeu(){
  /*
    Affiche les plans de jeu et de tir du joueur qui doit effectuer le prochain tir
    Les plans de jeu correspondent à ses océans alors que les plans de tir correspondent aux océans de la cible
  */
    let j1 = joueurs[self.joueur_tour]
    let j2 = joueurs[self.joueur_cible]
    print("============== PLAN JEU ================")
    j1.espace_jeu.afficher(ocean:NomOcean.atlantique, inconnu:false)
    j1.espace_jeu.afficher(ocean:NomOcean.pacifique, inconnu:false)
    j1.espace_jeu.afficher(ocean:NomOcean.indien, inconnu:false)
    print("\n\n============== PLAN TIR ================")
    j2.espace_jeu.afficher(ocean:NomOcean.atlantique, inconnu:true)
    j2.espace_jeu.afficher(ocean:NomOcean.pacifique, inconnu:true)
    j2.espace_jeu.afficher(ocean:NomOcean.indien, inconnu:true)
  }
}
