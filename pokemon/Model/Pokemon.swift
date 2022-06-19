import Foundation

struct Pokemon: Codable, Identifiable, Equatable {
    var id: String { name }
    let name: String
    let url: String
}

struct PokemonListDataModel: Codable {
    let count: Int
    let next: String?
    let previous: String?
    var results: [Pokemon] = []
}

extension PokemonListDataModel {
    static let stubListPokemon: PokemonListDataModel = PokemonListDataModel(count: 1126,
                                                          next: "https://pokeapi.co/api/v2/pokemon?offset=5&limit=5",
                                                          previous: nil,
                                                          results: [
                                                            Pokemon(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"),
                                                            Pokemon(name: "ivysaur", url: "https://pokeapi.co/api/v2/pokemon/2/"),
                                                            Pokemon(name: "venusaur", url: "https://pokeapi.co/api/v2/pokemon/3/"),
                                                            Pokemon(name: "charmander", url: "https://pokeapi.co/api/v2/pokemon/4/"),
                                                            Pokemon(name: "charmeleon", url: "https://pokeapi.co/api/v2/pokemon/5/")
                                                          ])
}

struct PokemonDetailsDataModel: Codable {
    let name: String
    let weight: Int
    let height: Int
    let stats: [PokemonStats]
    let types: [PokemonType]
    let sprites: Sprites
    
    struct Sprites: Codable {
        let front_default: String
    }
    
    struct PokemonStats: Codable, Identifiable {
        var id: String { stat.name }
        let base_stat: Int
        let effort: Int
        let stat: Stat
        
        struct Stat: Codable {
            let name: String
            let url: String
        }
    }
    
    struct PokemonType: Codable, Identifiable {
        var id: Int { slot }
        let slot: Int
        let type: PokemonElementType
        
        struct PokemonElementType: Codable {
            let name: ElementType
            let url: String
        }
        
        enum ElementType: String, CodingKey, Codable {
            case normal
            case fire
            case water
            case grass
            case electric
            case ice
            case fighting
            case poison
            case ground
            case flying
            case psychic
            case bug
            case rock
            case ghost
            case dark
            case dragon
            case steel
            case fairy
        }
    }
}

extension PokemonDetailsDataModel {
    static let stubPokemonDetail: PokemonDetailsDataModel = PokemonDetailsDataModel(name: "bulbasaur", weight: 69, height: 7, stats: [
        PokemonStats(base_stat: 45, effort: 0, stat: PokemonStats.Stat(name: "hp", url: "https://pokeapi.co/api/v2/stat/1/")),
        PokemonStats(base_stat: 49, effort: 0, stat: PokemonStats.Stat(name: "attack", url: "https://pokeapi.co/api/v2/stat/2/")),
        PokemonStats(base_stat: 49, effort: 0, stat: PokemonStats.Stat(name: "defense", url: "https://pokeapi.co/api/v2/stat/3/")),
        PokemonStats(base_stat: 65, effort: 0, stat: PokemonStats.Stat(name: "special-attack", url: "https://pokeapi.co/api/v2/stat/4/")),
        PokemonStats(base_stat: 65, effort: 0, stat: PokemonStats.Stat(name: "special-defense", url: "https://pokeapi.co/api/v2/stat/5/")),
        PokemonStats(base_stat: 45, effort: 0, stat: PokemonStats.Stat(name: "speed", url: "https://pokeapi.co/api/v2/stat/6/"))
    ], types: [
        PokemonType(slot: 1, type: PokemonType.PokemonElementType(name: PokemonType.ElementType.grass, url: "https://pokeapi.co/api/v2/type/12/")),
        PokemonType(slot: 1, type: PokemonType.PokemonElementType(name: PokemonType.ElementType.poison, url: "https://pokeapi.co/api/v2/type/4/"))
    ], sprites: Sprites(front_default: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"))
}
