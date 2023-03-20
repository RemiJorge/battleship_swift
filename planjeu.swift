/**************************************
          Le fichier PLANJEU
**************************************/

/*************************************
*          TYPE ABSTRAIT             *
**************************************/

protocol PlanJeuProtocol{ 
  
  init(iles:[NomOcean:[(Int, Int)]], bateau_init:[BateauProtocol])
  /* 
    init: {(Int x Int)} x {Bateau} -> PlanJeu
  */
  
  var oceans : [NomOcean:OceanProtocol] {get}
  /*
    Dictionnaire associant le nom de l'ocean à son type
    init(iles, bat) => oceans[k] == Ocean avec Ocean.plateau contenant les iles et les bateaux correspondant 
  */ 
  
  mutating func modifier(ocean:NomOcean, col:Int, lig:Int, valeur:CaseOcean) 
  /* 
    Prend en parametre un nom d'océan, une colonne, une ligne et une valeur.
    Modifie la case (col, lig) associé à l'ocean, par la valeur donnée
    modifier : PlanJeu x NomOcean x Inr x Int x CaseOcean -> PlanJeu 
    modfifier(pj, o, c, l, v) => pj.oceans[o][col][lig] == valeur
  */
  
  func afficher(ocean:NomOcean, inconnu:Bool) 
  /* 
    Prend un nom d'ocean, un booléen indiquant si on affiche l'espace de tir ou de jeu
    Affiche à l'écran l'espace de tir ou de jeu de l'ocean correspondant.
  */

}


/*************************************
*           TYPE CONCRET             *
**************************************/

struct PlanJeu : PlanJeuProtocol{

  
  public private (set) var oceans : [NomOcean:OceanProtocol]
  /*
    Dictionnaire associant le nom de l'ocean à son type
    init(iles, bat) => oceans[k] == Ocean avec Ocean.plateau contenant les iles et les bateaux correspondant 
  */ 

  
  init(iles:[NomOcean:[(Int, Int)]], bateau_init:[BateauProtocol] = []){
  /* 
    init: {(Int x Int)} x {Bateau} -> PlanJeu
  */
    
    self.oceans = [NomOcean:OceanProtocol]()
    for (nom, ile) in iles{
      self.oceans[nom] = Ocean(nom:nom, ile:ile)
    }

    for bat in bateau_init{
      if var oce = self.oceans[bat.ocean]{
        for (col, lig) in bat.positions{
          oce.modifier(col:col, lig:lig, valeur:CaseOcean.bateau)
          self.oceans[bat.ocean] = oce
        }
      }
    }
    
  }

  
  public mutating func modifier(ocean:NomOcean, col:Int, lig:Int, valeur:CaseOcean){
  /* 
    Prend en parametre un nom d'océan, une colonne, une ligne et une valeur.
    Modifie la case (col, lig) associé à l'ocean, par la valeur donnée
    modifier : PlanJeu x NomOcean x Inr x Int x CaseOcean -> PlanJeu 
    modfifier(pj, o, c, l, v) => pj.oceans[o][col][lig] == valeur
  */
    if var oce = self.oceans[ocean]{
      oce.modifier(col:col, lig:lig, valeur:valeur)
      self.oceans[ocean] = oce
    }
  }

  
  public func afficher(ocean:NomOcean, inconnu:Bool=false){
  /* 
    Prend un nom d'ocean, un booléen indiquant si on affiche l'espace de tir ou de jeu
    Affiche à l'écran l'espace de tir ou de jeu de l'ocean correspondant.
  */
  /*
    caractere utile :  ║ ᆖ ═ ╔ ╗ ╚ ╝ ╠ ╣ ╦ ╩ ╬ ╳ ╟ ╢ ╤ ╧ ─ │ ┼
                    : ┏━─ ⏹■ ▇ █
  */

    switch ocean{
      case .pacifique: print("\nOCEAN PACIFIQUE\n")
      case .atlantique: print("\nOCEAN ATLANTIQUE\n")
      case .indien: print("\nOCEAN INDIEN\n")
    }
    guard let oce = oceans[ocean] else{
      return
    }
    let t = oce.plateau
    let (ligne, colonne) = (oce.dimension.0, oce.dimension.1)

    var numero_col = "    0"
    for i in 1..<colonne{numero_col += "   " + String(i)}
    print(numero_col)
    
    var haut_tableau = "  ╔═══"
    for _ in 1..<colonne{haut_tableau += "╤═══"}
    print(haut_tableau + "╗")
    
    for i in 0..<ligne{
      var milieu = String(i) + " ║"
      for j in 0..<colonne{
        switch t[i][j]{
          case .ile : milieu += "███"
          case .bateau : if !inconnu{milieu += " □ "}else{milieu += " ? "}
          case .mort : milieu += " ╳ "
          case .vue : if inconnu{milieu += " + "}else{milieu += "   "}
          case .rater : if inconnu{milieu += " 🞄 "}else{milieu += "   "}
          default : if inconnu{milieu += " ? "}else{milieu += "   "}
          
        }
        
        if j != colonne-1{
          if t[i][j] == CaseOcean.ile &&  t[i][j+1] == CaseOcean.ile{
          milieu += "█"
          }else{
          milieu += "│"}
        }
      }
      
      print(milieu + "║")

      if i != ligne-1{
        var milieu = "  ╟"
        if t[i][0] == CaseOcean.ile  && t[i+1][0] == CaseOcean.ile{
          milieu += "███"
        }else{
          milieu += "───"
        }
        for j in 1..<colonne{
          if t[i][j] == CaseOcean.ile  && t[i+1][j] == CaseOcean.ile{
            if t[i][j-1] == CaseOcean.ile  && t[i+1][j-1] == CaseOcean.ile{
              milieu += "████"
            }else{
             milieu += "┼███"
            }
          }else{
             milieu += "┼───"
          } 
         }
        print(milieu + "╢")
      }
    }

    var bas_tableau = "  ╚═══"
    for _ in 1..<colonne{bas_tableau += "╧═══"}
    print(bas_tableau + "╝")
    
  }

  
}
