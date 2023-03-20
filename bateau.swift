/**************************************
          Le fichier BATEAU
**************************************/

/*************************************
*            TYPE ABSTRAIT           *
**************************************/

protocol BateauProtocol{
    
  init(ocean_init : NomOcean, positions_init:[(Int, Int)])
  /*
    init : NomOcean x {(Int x Int)} -> Bateau
  */

  var taille : Int {get}
  /*
    taille : Bateau -> Int
    La taille du bateau, comprise entre 1 et 4
    init(oce, pos) => taille == pos.count
  */

  var ocean : NomOcean {get}
  /*
    ocean : Bateau -> NomOcean
    Nom de l'ocean sur lequel est placé le bateau
    init(oce, pos) => ocean == oce
  */
  
  var positions : [(Int, Int)] {get}
  /*
    positions : Bateau -> {(Int x Int)}
    Liste des positions du bateau
    init(oce, pos) => positions == pos 
  */
  
  var positions_touchees : [(Int, Int)?] {get}
  /* 
    positions_touchees : Bateau -> {(Int x Int) | Vide}
    Une liste des positions touchées, chaque indice de la liste correspont à l'indice associé dans la liste des positions.
    init(oce, pos) => positions_touchees == [nil, nil,...,nil] et positions_touchees.count == taille
  */

  var positions_restantes : [(Int, Int)?] {get}
  /*
    positions_restantes : Bateau -> {(Int x Int) | Vide}
    Une liste des positions restantes, chaque indice de la liste correspont à l'indice associé dans la liste des positions.
    init(oce, pos) => positions_restantes == positions
  */

  var nb_pos_touche : Int {get}
  /*
    nb_pos_touche : Bateau -> Int
    nombre de position touchées comprise entre 0 et self.taille
  */
  
  var est_coule : Bool {get} 
  /*
    est_coule : Bateau -> Bool
    est_coule == true <=> nb_pos_touche == taille
  */
  
  mutating func toucher(col:Int, lig:Int) 
  /* 
    toucher : Bateau x Int x Int -> ()
    Precondition : (col, lig) n'appartient pas a positions_touchees mais appartient à positions
    Postcondition : Touche(b, col, lig) => (col, lig) appartient a positions_touchees,
                                           (col, lig) n'appartient pas a positions_restantes,
                                            nb_pos_touche += 1
  */

}


/**************************************
*            TYPE CONCRET            *
**************************************/

struct Bateau : BateauProtocol{
  
  public private (set) var taille : Int 
  /*
    taille : Bateau -> Int
    La taille du bateau, comprise entre 1 et 4
    init(oce, pos) => taille == pos.count
  */

  public private (set) var ocean : NomOcean
  /*
    ocean : Bateau -> NomOcean
    Nom de l'ocean sur lequel est placé le bateau
    init(oce, pos) => ocean == oce
  */
  
  public private (set) var positions : [(Int, Int)] 
  /*
    positions : Bateau -> {(Int x Int)}
    Liste des positions du bateau
    init(oce, pos) => positions == pos 
  */
  
  public private (set) var positions_touchees : [(Int, Int)?]
  /* 
    positions_touchees : Bateau -> {(Int x Int) | Vide}
    Une liste des positions touchées, chaque indice de la liste correspont à l'indice associé dans la liste des positions.
    init(oce, pos) => positions_touchees == [nil, nil,...,nil] et positions_touchees.count == taille
  */

  public private (set) var positions_restantes : [(Int, Int)?]
  /*
    positions_restantes : Bateau -> {(Int x Int) | Vide}
    Une liste des positions restantes, chaque indice de la liste correspont à l'indice associé dans la liste des positions.
    init(oce, pos) => positions_restantes == positions
  */
  
  public var nb_pos_touche : Int 
  /*
    nb_pos_touche : Bateau -> Int
    nombre de position touchées comprise entre 0 et self.taille
  */
  
  public var est_coule : Bool{ 
  /*
    est_coule : Bateau -> Bool
    est_coule == true <=> nb_pos_touche == taille
  */
    return self.taille == self.nb_pos_touche
  }

  init(ocean_init : NomOcean, positions_init:[(Int, Int)]){
  /*
    init : NomOcean x {(Int x Int)} -> Bateau
  */
    self.taille = positions_init.count
    self.positions = positions_init
    self.positions_restantes = positions_init
    self.positions_touchees = [(Int, Int)?](repeating: nil, count: self.taille) 
    self.nb_pos_touche = 0
    self.ocean = ocean_init
  }

  public mutating func toucher(col:Int, lig:Int){
  /* 
    toucher : Bateau x Int x Int -> ()
    Precondition : (col, lig) n'appartient pas a positions_touchees mais appartient à positions
    Postcondition : Touche(b, col, lig) => (col, lig) appartient a positions_touchees,
                                           (col, lig) n'appartient pas a positions_restantes,
                                            nb_pos_touche += 1
  */

    var i = 0
    // Invariant : pour tout k, tel que 0<= k < i, positions[k] != (col, lig)
    while i < self.taille && self.positions[i] != (col, lig){
      i += 1
    }
    self.positions_touchees[i] = (col, lig)
    self.positions_restantes[i] = nil
    self.nb_pos_touche += 1
  }
}


