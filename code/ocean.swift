/**************************************
          Le fichier OCEAN
**************************************/

/*************************************
*          TYPE ABSTRAIT             *
**************************************/

protocol OceanProtocol{
  
  init(nom:NomOcean, ile:[(Int, Int)])
  /*
    init : NomOcean x {(Int x Int)} -> Ocean
  */
  
  var nom : NomOcean {get} 
  /*
    nom : Ocean -> NomOcean 
    init(nomocean, ile) => nom == nomocean
  */
  
  var dimension : (Int, Int) {get} 
  /*
    dimension : Ocean -> (Int x Int)
    couple d'entier (colonne, ligne) compris entre 5 et 8
    init(NomOcean.indien) => dimension == (5,6)
    init(NomOcean.pacifique) => dimension == (7,8)
    init(NomOcean.atlantique) => dimension == (6,7)
  */
  
  var plateau : [[CaseOcean]] {get}
  /*
    plateau : Ocean -> {CaseOcean}
    plateau.count = dimension.0, plateau[0].count = dimension.1
  */
  
  mutating func modifier(col:Int, lig:Int, valeur:CaseOcean) 
  /* 
    modifier : Ocean x Int x Int  x CaseOcean -> ()
    Precondition:  
      Prend une colonne, une ligne (valide, change en fonction de l'ocean)
    Postcondition:
      modifier(col, lig, valeur) => plateau[col][lig] = valeur
  */
}


enum CaseOcean{
  case eau
  case vue
  case mort
  case ile
  case bateau
  case rater
}


enum NomOcean{
  case indien
  case pacifique
  case atlantique
}

/*************************************
*           TYPE CONCRET             *
**************************************/

struct Ocean : OceanProtocol{

  
  public private (set) var nom : NomOcean
  /*
    nom : Ocean -> NomOcean 
    init(nomocean, ile) => nom == nomocean
  */

  public private (set) var dimension : (Int, Int)
  /*
    dimension : Ocean -> (Int x Int)
    couple d'entier (colonne, ligne) compris entre 5 et 8
    init(NomOcean.indien) => dimension == (5,6)
    init(NomOcean.pacifique) => dimension == (7,8)
    init(NomOcean.atlantique) => dimension == (6,7)
  */
  
  public private (set) var plateau : [[CaseOcean]]
  /*
    plateau : Ocean -> {CaseOcean}
    plateau.count = dimension.0, plateau[0].count = dimension.1
  */

  
  init(nom:NomOcean, ile:[(Int,Int)]){
  /*
    init : NomOcean x {(Int x Int)} -> Ocean
  */
    self.nom = nom
    self.dimension = (0, 0)
    switch nom{
      case .atlantique : dimension = (6,7)
      case .pacifique : dimension = (7,8)
      case .indien : dimension = (5,6)
    }
    self.plateau = [[CaseOcean]](repeating: [CaseOcean](repeating: CaseOcean.eau, count: dimension.1), count: dimension.0)

    // Invariant : Pour toute les colonnes et lignes déjà traité, plateau[lig][col] == CaseOcean.ile
    for (col, lig) in ile{
      self.plateau[lig][col] = CaseOcean.ile
    }
  }

  
  public mutating func modifier(col:Int, lig:Int, valeur:CaseOcean){
  /* 
    modifier : Ocean x Int x Int  x CaseOcean -> ()
    Precondition:  
      Prend une colonne, une ligne (valide, change en fonction de l'ocean)
    Postcondition:
      modifier(col, lig, valeur) => plateau[col][lig] = valeur
  */
    if self.plateau[lig][col] != CaseOcean.mort{
        self.plateau[lig][col] = valeur
    }
  }
}
