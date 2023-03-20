/*************************************
*               ENTREES              *
**************************************/


func entree() -> String {	
  /*
    fonction recuperant une entrée, cependant ne renvoie les commentaires ni les entrées vides
  */
	var recu = ""
	repeat { recu = readLine() ?? "" }
	while recu.hasPrefix("#") || (recu=="");
	if MODE == "scenario" && recu != "" {print(recu)}
	return recu
}

func entree_coord() -> (NomOcean, Int, Int) {
  /*
    fonction qui renvoit des coordonnées de tirs valident pour tirer
  */
	var recu = ""
  var col : Int? = nil
  var lig : Int? = nil
  var ocean : NomOcean? = nil
  var check : Bool
	repeat{
    repeat {recu = entree()
            let coord = recu.split(separator: ",")
            if coord.count == 3{
              lig = Int(coord[1])
              col = Int(coord[2])
              if col == nil || lig == nil{
                print("ERREUR : Données incorrect")
              }
              switch coord[0]{
                case "o1": ocean = NomOcean.atlantique
                case "o2": ocean = NomOcean.pacifique
                case "o3": ocean = NomOcean.indien
                default : 
                  print("ERREUR : Ocean incorrect")
                  ocean = nil
            }}else{
              print("ERREUR : Format incorrect")
              ocean = nil
            }
    }while (col==nil) || (lig==nil) || (ocean==nil);
  check = check_positions_tir(ocean:ocean!, col:col!, lig:lig!)
  if !check{
   print("ERREUR : Hors map") 
  }
  }while !check;
	
  return (ocean!, col!, lig!)
}


func entree_difficulte() -> Int?{
  /*
    fonction permetant de choisir une difficulté. Renvoie le le nombre de tir maximum ou nil si illimité.
  */
	var recu = ""
  var rep : Int? = 0
	repeat { recu = entree().lowercased()
           switch recu{
             case "facile": rep = nil
             case "normal": rep = 65
             case "difficile": rep = 50
             case "extreme": rep = 40
             default:
                print("Incorrect")
                recu = ""
           }}
	while recu=="";
	return rep
}


func entree_ile(ocean:NomOcean) -> [(Int, Int)]{
  /*
    fonction demandant une île pour un océan spécifique.
    Renvoie le tableau associé à l'île
  */
	var recu = ""
	var rep : [(Int, Int)]? = nil
  
    repeat { // demande valide du joueur
      recu = entree()
      let coord = recu.split(separator: ",")
      if coord.count%2 == 1{
        print("ERREUR : Il faut rentrer un nombre pair de coordonnée.")
      }else if coord.count < 8{
        print("ERREUR : Il faut rentrer au moins 4 positions.")
      }else{
        var pos = [(Int,Int)](repeating: (0, 0), count: coord.count/2)
        var i = 0
        var index = 0
        var check = true
        while i < coord.count && check{
          guard let lig = Int(coord[i]) else{
            print("ERREUR : Entrée Invalide")
            check = false
            continue
          }
          i += 1
          
          guard let col = Int(coord[i]) else{
            print("ERREUR : Entrée Invalide")
            check = false
            continue
          }
          i += 1

          if !check_positions_tir(ocean: ocean, col: col, lig: lig){
            print("ERREUR : Hors map")
            check = false
            continue
          }
          
          var k = 0
          while k < index && pos[k] != (col,lig){k += 1}
          if k != index{
            print("ERREUR : Il faut rentrer des coordonnées distinctes")
            check = false
          }else{
            pos[index] = (col, lig)
            index += 1
          }
        }
        
        if check{
          if toutes_contigues(pos:pos){
            rep = pos
          }else{
            print("Ce n'est pas contigues, il faut que l'ile constitue un seul et même bloc")
          }
        }
      }
      
    }while rep==nil ;
    
  return rep!
}


func entree_bateau(taille:Int, iles:[NomOcean:[(Int, Int)]], bateau_existant:[BateauProtocol]) -> BateauProtocol{
  /*
    fonction qui attend l'entrée de l'utilisateur, renvoit un element de type Bateau bien positionné
    donc sans collision avec d'autres bateaux ou des îles.
  */
	var recu : String = ""
  var ocean : String? = nil
  var col : Int? = nil
  var lig : Int? = nil
  var dir : String? = nil
	var rep : BateauProtocol? = nil
  while rep == nil{
    repeat { // demande valide du joueur
      recu = entree()
      let coord = recu.split(separator: ",")
      if coord.count == 4{
        ocean = String(coord[0])
        if ocean != "o1" && ocean != "o2" && ocean != "o3"{
          print("ERREUR : ocean incorrect")
          ocean=nil}
        lig = Int(coord[1])
        col = Int(coord[2])
        dir = String(coord[3])
        if col == nil || lig == nil {
          print("ERREUR : Format incorrect")}
        if dir != "N" && dir != "E" && dir != "S" && dir != "W"{
          print("ERREUR : orientation incorrect")
          dir = nil}
      }else{
        print("ERREUR : Format incorrect")
        ocean = nil // pour ne pas sortir de la boucle
      }
    }while (col==nil) || (lig==nil) || (dir==nil) || (ocean==nil);
    
    rep = creer_bateau(ocean: ocean!, taille:taille, col: col!, lig: lig!, dir: dir!, iles:iles, bateau_existant:bateau_existant)
  }
  return rep!
}


/*************************************
*               CREATION             *
**************************************/

func creer_bateau(ocean : String, taille : Int, col : Int, lig : Int, dir : String, iles : [NomOcean:[(Int, Int)]], bateau_existant : [BateauProtocol]) -> BateauProtocol?{
    /*
  Prend en parametre le numero de l'ocean, la taille du bateau, une colonne et ligne d'origine, 
  une orientation et la position de l'ile sur la carte.
  Renvoit un tableau contenant les positions du bateau ou nil si le bateau depasse de l'ocean, 
  'il touche l'ile ou un autre bateau déjà placé
  */ 
  var (col_max, lig_max) = (0, 0)
  var ocean_pour_bat : NomOcean = NomOcean.atlantique
  switch ocean{
    case "o1" : ocean_pour_bat = NomOcean.atlantique
                (col_max, lig_max) = (7, 6)
    case "o2" : ocean_pour_bat = NomOcean.pacifique
                (col_max, lig_max) = (8, 7)
    case "o3" : ocean_pour_bat = NomOcean.indien
                (col_max, lig_max) = (6, 5)
        
    default : return nil
  }
  
  var x : Int = 0
  var y : Int = 0
  switch dir{
    case "N": y = -1
    case "E": x = 1
    case "S": y = 1
    case "W": x = -1
    default : return nil
  }

  let ile = iles[ocean_pour_bat] ?? []
  var positions_pour_bat : [(Int, Int)] = [(Int, Int)](repeating: (0, 0), count: taille)
  
  var i = 0
  while i < taille {
    if col + x*i < 0 || lig + y*i < 0 {print("Hors de la map")
                                       return nil} // cadre 
    if col + x*i >= col_max || lig + y*i >= lig_max {print("Hors de la map")
                                                     return nil} // cadre aussi
    var indice_ile_pos : Int = 0
    while indice_ile_pos < ile.count{ // si touche ile
      if ile[indice_ile_pos].0 == col + x*i && ile[indice_ile_pos].1 == lig + y*i {
       print("Il y a une ile")
       return nil}
      indice_ile_pos += 1
    }
    var indice_bat : Int = 0
    var ind_bat_pos : Int = 0
    while indice_bat < bateau_existant.count{// si touche bateau
      if bateau_existant[indice_bat].ocean == ocean_pour_bat{ 
        while ind_bat_pos < bateau_existant[indice_bat].taille{
          if bateau_existant[indice_bat].positions[ind_bat_pos].0 == col + x*i && bateau_existant[indice_bat].positions[ind_bat_pos].1 == lig + y*i {
            print("Il y a un autre bateau")
            return nil}  
          ind_bat_pos += 1
        }}
        indice_bat += 1
    }
    positions_pour_bat[i] = (col + x*i, lig + y*i)
    i += 1
  }
  
  return Bateau(ocean_init: ocean_pour_bat, positions_init : positions_pour_bat)
}



func pos_contigues(p1:(Int,Int), p2:(Int,Int)) -> Bool{
  /*
    Vérifie que les deux coordonnées passées en argument sont contigues
  */
  return abs(p1.0 - p2.0) + abs(p1.1 - p2.1) == 1
}

func toutes_contigues(pos:[(Int,Int)]) -> Bool{
  /*
    Vérifie que l'ensemble des positions de l'ile est bien contigues
  */
  var continues = [Bool](repeating: false, count: pos.count)
  continues[0] = true
  var nouvelle_pos = 1
  var tab_pos_contigues = [(Int,Int)?](repeating: nil, count: pos.count)
  tab_pos_contigues[0] = pos[0]
  var indice = 1
  var debut_nouveau = 0 
  
  while nouvelle_pos > 0 && tab_pos_contigues.count > indice{
    nouvelle_pos = 0
    
    for k in debut_nouveau..<indice{ // toutes les pos deja ok
      if let p2 = tab_pos_contigues[k]{
      
        for i in 0..<pos.count{ // toutes les positions encore false
          if continues[i]{continue} // la position est deja considere comme ok
          if pos_contigues(p1: pos[i], p2: p2){
            continues[i] = true
            tab_pos_contigues[indice + nouvelle_pos] = pos[i]
            nouvelle_pos += 1
          }
        }
      }
      
    }
    debut_nouveau = indice
    indice += nouvelle_pos
  }
  
  
  return tab_pos_contigues.count == indice
}


func tableau_bateau() -> [BateauProtocol]{
  /*
    Fonction qui demande à l'utilisateur de rentrer ses bateaux et renvoit un tableau de bateaux
  */
  print("\nPlacez le bateau de taille 1:")
  let bat1 : BateauProtocol = entree_bateau(taille: 1, iles:iles, bateau_existant: [])
  print("\nPlacez le bateau de taille 2:")
  let bat2 = entree_bateau(taille: 2, iles:iles, bateau_existant: [bat1])
  print("\nPlacez le premier bateau de taille 3:")
  let bat3 = entree_bateau(taille: 3, iles:iles, bateau_existant: [bat1, bat2])
  print("\nPlacez le deuxime bateau de taille 3:")
  let bat4 = entree_bateau(taille: 3, iles:iles, bateau_existant: [bat1, bat2, bat3])
  print("\nPlacez le bateau de taille 4:")
  let bat5 = entree_bateau(taille: 4, iles:iles, bateau_existant: [bat1, bat2, bat3, bat4])
  return [bat1, bat2, bat3, bat4, bat5]
}


func check_positions_tir(ocean:NomOcean, col:Int, lig:Int) -> Bool{
  /*
    Vérifie que les deux coordonnées passées en argument sont des coordonnées valables de l'océan passé en parametre
  */
  if lig < 0 || col < 0{
    return false
  }
  switch ocean{
    case .atlantique : return lig < 6 && col < 7
    case .pacifique : return lig < 7 && col < 8
    case .indien : return lig < 5 && col < 6
  }
}
