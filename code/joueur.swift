/*************************************
*          TYPE ABSTRAIT             *
**************************************/

protocol JoueurProtocol{

  init(nom:String, iles:[NomOcean:[(Int, Int)]], bateaux_init : [BateauProtocol])
  /*
    init: String x {(Int x Int)} x {Bateau} -> Joueur
  */
    
  var bateaux : [BateauProtocol] {get}
  /*
    bateaux : Joueur -> {Bateau}
    init(noms, iles, bat) => bateaux == bat
  */

  var nb_coule : Int {get}
  /* 
    nb_coule : Joueur -> Int
    Le nombre de bateaux coulé du joueur, if tirer(col,lig)==ResTir.coule alors nb_coule+=1
  */
  
  var nb_tir : Int {get set} 
  /* 
    nb_tir : Joueur -> Int
    Le nombre de fois que le joueur a tirer
  */
  
  var nom : String {get}
  /*
    nom : Joueur -> String
    Le nom du joueur
  */

  var est_perdu : Bool {get} 
  /*
    est_perdu : Joueur -> Bool
    Si True, un autre joueur a gagné, nb_coule==bateaux.count <=> est_perdu==true
  */

  var espace_jeu : PlanJeuProtocol {get}
  /*
    espace_jeu : Joueur -> PlanJeu
    L'espace jeu du joueur, il contient les trois océans du joueur
  */
  
  func en_vue (ocean:NomOcean, col:Int, lig:Int) -> Bool 
  /*
    en_vue : Joueur x NomOcean x Int x Int -> Bool
    Nous indique si il y a un bateau en vue de la position (col,lig) qu'on lui donne en argument.
    en_vue(col,lig) => si il existe un bateau pour lequel il existe un couple (col1,lig1) 
    dans positions_restantes tel que col==col1 ou lig==lig1 alors on renvoit true, sinon false.
  */
  
  mutating func tirer (ocean:NomOcean, col:Int, lig:Int) -> ResTir  
  /* 
    tirer : Joueur x NomOcean x Int x Int -> Restir
    Nous permet de tirer sur la position (col,lig) qu'on lui donne en argument.
    Precondition:
      (col, lig) appartient à l'ocean NomOcean. Le tir est donc coherent.
    Postcondition:
      tirer(col,lig) => 
      Si il existe un bateau pour lequel il existe un couple (col1,lig1) dans positions_restantes 
      tel que col==col1 et lig==lig1 alors :
                On touche le bateau (bateau.toucher(col,lig)):
                Si le bateau est coulé:
                      nb_coule+=1
                      On renvoit ResTir.coule
                Sinon :
                      On renvoit ResTir.touche
      Sinon si on touche une ile on renvoit Restir.ile
      Sinon on regarde si il y a un bateau en vue avec en_vue(col,lig):
                 Si un tel bateau existe on renvoit ResTir.en_vue
                 Sinon on renvoit Restir.eau
  */

}



/*************************************
*           TYPE CONCRET             *
**************************************/

struct Joueur : JoueurProtocol{

  public private (set) var bateaux : [BateauProtocol]
  /*
    bateaux : Joueur -> {Bateau}
    init(noms, iles, bat) => bateaux == bat
  */
  
  public private (set) var nb_coule : Int
  /* 
    nb_coule : Joueur -> Int
    Le nombre de bateaux coulé du joueur, if tirer(col,lig)==ResTir.coule alors nb_coule+=1
  */

  public var nb_tir : Int
  /* 
    nb_tir : Joueur -> Int
    Le nombre de fois que le joueur a tirer
  */

  public private(set) var espace_jeu : PlanJeuProtocol
  /*
    espace_jeu : Joueur -> PlanJeu
    L'espace jeu du joueur, il contient les trois océans du joueur
  */
  
  private var taille_jeu : Int  // Nombre de bateaux initiaux

  private var positions_iles : [NomOcean:[(Int, Int)]] // Posiiton des iles sur les oceans
  
  public var est_perdu : Bool{
  /*
    est_perdu : Joueur -> Bool
    Si True, un autre joueur a gagné, nb_coule==bateaux.count <=> est_perdu==true
  */
    return self.nb_coule == self.taille_jeu
  }

  public private (set) var nom : String
  /*
    nom : Joueur -> String
    Le nom du joueur
  */
  
  init(nom:String, iles:[NomOcean:[(Int, Int)]], bateaux_init:[BateauProtocol]){  
  /*
    init: String x {(Int x Int)} x {Bateau} -> Joueur
  */
    self.nom = nom
    self.bateaux = bateaux_init
    self.nb_coule = 0
    self.nb_tir = 0
    self.taille_jeu = bateaux_init.count
    self.positions_iles = iles
    self.espace_jeu = PlanJeu(iles:iles, bateau_init:bateaux_init)
  }

  
  public mutating func tirer(ocean:NomOcean, col:Int, lig:Int) -> ResTir{
    /* 
    tirer : Joueur x NomOcean x Int x Int -> Restir
    Nous permet de tirer sur la position (col,lig) qu'on lui donne en argument.
    Precondition:
      (col, lig) appartient à l'ocean NomOcean. Le tir est donc coherent.
    Postcondition:
      tirer(col,lig) => 
      Si il existe un bateau pour lequel il existe un couple (col1,lig1) dans positions_restantes 
      tel que col==col1 et lig==lig1 alors :
                On touche le bateau (bateau.toucher(col,lig)):
                Si le bateau est coulé:
                      nb_coule+=1
                      On renvoit ResTir.coule
                Sinon :
                      On renvoit ResTir.touche
      Sinon si on touche une ile on renvoit Restir.ile
      Sinon on regarde si il y a un bateau en vue avec en_vue(col,lig):
                 Si un tel bateau existe on renvoit ResTir.en_vue
                 Sinon on renvoit Restir.eau
  */
    
    if let nv = self.check_pos(ocean:ocean, col:col, lig:lig){  // On rentre dans ce if si il y a un bateau EN VIE (NON TOUCHE) la ou on a tirer
      self.espace_jeu.modifier(ocean:ocean, col:col, lig:lig, valeur:CaseOcean.mort)
      self.bateaux[nv].toucher(col:col, lig:lig)
      if self.bateaux[nv].est_coule{
        self.nb_coule += 1
        return ResTir.coule
      }
      return ResTir.touche
    }
    if self.ile_touche(ocean: ocean, col: col, lig: lig){
      return ResTir.ile
    }
    if self.en_vue(ocean:ocean, col:col, lig:lig){  // Si il n'y a pas de bateaux non touché on regarde si il y en a un en vue
      self.espace_jeu.modifier(ocean:ocean, col:col, lig:lig, valeur:CaseOcean.vue)
      return ResTir.en_vue
    }
    self.espace_jeu.modifier(ocean:ocean, col:col, lig:lig, valeur:CaseOcean.rater)
    return ResTir.eau
  }
  
  
  private func check_pos(ocean:NomOcean, col:Int, lig:Int) -> Int?{  
  // Fonction qui renvoit l'indice du Bateau  si un bateau est touché, nil sinon
    var i : Int = 0
    while i < self.taille_jeu{
      var j : Int = 0
      if self.bateaux[i].ocean == ocean{
        while j < self.bateaux[i].taille{
          if let nv = self.bateaux[i].positions_restantes[j]{
            if nv == (col, lig){return i}
          }
          j += 1
        }
      }
      i += 1}
    return nil
  }

  private func ile_touche(ocean:NomOcean, col:Int, lig:Int) -> Bool{
    // Cette fonction verifie si la case donnée en argument est une ile sur l'ocean donné en argument
    let ile = positions_iles[ocean] ?? []
    var i = 0
    while i < ile.count{
      if (col, lig) == ile[i]{
        return true
      }
      i += 1
    }
    return false
  }
  
  public func en_vue(ocean:NomOcean, col:Int, lig:Int) -> Bool{
  /*
    en_vue : Joueur x NomOcean x Int x Int -> Bool
    Nous indique si il y a un bateau en vue de la position (col,lig) qu'on lui donne en argument.
    en_vue(col,lig) => si il existe un bateau pour lequel il existe un couple (col1,lig1) 
    dans positions_restantes tel que col==col1 ou lig==lig1 alors on renvoit true, sinon false.
  */
    var i : Int = 0
    while i < self.taille_jeu{
      var j : Int = 0
      if self.bateaux[i].ocean == ocean{
        while j < self.bateaux[i].taille{
          if let nv = self.bateaux[i].positions_restantes[j]{
            if nv.0 == col && !cacher_par_ile_colonne(ocean:ocean, col_tir:col, lig_tir:lig, lig_bat:nv.1){
               return true}
            else if nv.1 == lig && !cacher_par_ile_ligne(ocean: ocean, col_tir: col, lig_tir: lig, col_bat: nv.0){
                return true}}
          j += 1
        }
      }
      i += 1
    }
    return false
  }

  private func cacher_par_ile_colonne(ocean:NomOcean, col_tir: Int, lig_tir:Int, lig_bat:Int) -> Bool{
    //Renvoit true si il y a une ile sur la meme colonne et entre le tir et le bateau, false sinon
    let ile = positions_iles[ocean] ?? []
    var i = 0
    while i < ile.count{
      if ile[i].0 == col_tir{ // si la case de l'ile est sur la meme colonne
        if lig_tir <= ile[i].1 && ile[i].1 < lig_bat {return true} // si la case de l'ile est entre le bateau et le tir
        else if lig_bat < ile[i].1  && ile[i].1 <= lig_tir{return true}
      }
      i += 1
    }
    return false
  }

  private func cacher_par_ile_ligne(ocean:NomOcean, col_tir: Int, lig_tir:Int, col_bat:Int) -> Bool{
  //Renvoit true si il y a une ile sur la meme ligne et entre le tir et le bateau, false sinon
  let ile = positions_iles[ocean] ?? []
  var i = 0
  while i < ile.count{
    if ile[i].1 == lig_tir{ // si la case de l'ile est sur la meme ligne
      if col_tir <= ile[i].0 && ile[i].0 < col_bat {return true} // si la case de l'ile est entre le bateau et le tir
      else if col_bat < ile[i].0 &&  ile[i].0 <= col_tir{return true}
    }
    i += 1
  }
  return false
}
  
}


// Restir est le type de réponses possibles après un tir dans le jeu
enum ResTir{  

  case touche  
  
  case en_vue
  
  case eau    
  
  case coule 

  case ile
}
