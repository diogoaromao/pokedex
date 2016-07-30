//
//  Pokemon.swift
//  Pokedex
//
//  Created by Diogo Romão on 24/07/16.
//  Copyright © 2016 diogoaromao. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonUrl: String!
    
    var description: String {
        get {
            if _description == nil {
                return ""
            }
            return _description
        }
    }
    
    var type: String {
        get {
            if _type == nil {
                return ""
            }
            return _type
        }
    }
    
    var defense: String {
        get {
            if _defense == nil {
                return ""
            }
            return _defense
        }
    }
    
    var height: String {
        get {
            if _height == nil {
                return ""
            }
            return _height
        }
    }
    
    var weight: String {
        get {
            if _weight == nil {
                return ""
            }
            return _weight
        }
    }
    
    var attack: String {
        get {
            if _attack == nil {
                return ""
            }
            return _attack
        }
    }
    
    var nextEvolutionText: String {
        get {
            if _nextEvolutionText == nil {
                return ""
            }
            return _nextEvolutionText
        }
    }
    
    var nextEvolutionId: String {
        get {
            if _nextEvolutionId == nil {
                return ""
            }
            return _nextEvolutionId
        }
    }
    
    var nextEvolutionLevel: String {
        get {
            if _nextEvolutionLevel == nil {
                return ""
            }
            return _nextEvolutionLevel
        }
    }
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
            return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKE)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        
        let url = NSURL(string: _pokemonUrl)!
        Alamofire.request(.GET, url).responseJSON { (response: Response<AnyObject, NSError>) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                print(self._weight)
                print(self._height)
                print(self._attack)
                print(self._defense)
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    if let name = types[0]["name"] {
                        self._type = name.capitalizedString
                    }
                    
                    if types.count > 1 {
                        for x in 1 ..< types.count {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                
                print(self._type)
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
                    
                    if let url = descArr[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        Alamofire.request(.GET, nsurl).responseJSON { (response: Response<AnyObject, NSError>) in
                            if let descriptionDict = response.result.value as? Dictionary<String, AnyObject> {
                                if let description = descriptionDict["description"] as? String {
                                    self._description = description
                                    print(self._description)
                                }
                            }
                            
                            completed()
                        }
                    }
                } else {
                    self._description = "";
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0{
                    if let to = evolutions[0]["to"] as? String {
                        if to.rangeOfString("mega") == nil {
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionId = num
                                self._nextEvolutionText = to
                                
                                if let level = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLevel = "\(level)"
                                }
                                
                                print(self._nextEvolutionId)
                                print(self._nextEvolutionText)
                                print(self._nextEvolutionLevel)
                                
                            }
                        }
                    }
                    
                }
            }
        }
    }
}