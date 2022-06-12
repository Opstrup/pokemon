import Combine
import Foundation

enum PokemonAPI {
    private static let pageSize = 20
    private static let baseURL = "https://pokeapi.co/api/v2/pokemon"
    private static let initUrl = URL(string:"\(baseURL)?limit=\(pageSize)&offset=0")!
    
    static func fetchPokemons(_ nextPageURL: URL = initUrl) -> AnyPublisher<PokemonListDataModel, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: URLRequest(url: nextPageURL))
            .tryMap { try JSONDecoder().decode(PokemonListDataModel.self, from: $0.data) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func fetchPokemonDetails(_ pokemonDetailsURL: URL) -> AnyPublisher<PokemonDetailDataModel, Error> {
        URLSession.shared
            .dataTaskPublisher(for: URLRequest(url: pokemonDetailsURL))
            .tryMap { try JSONDecoder().decode(PokemonDetailDataModel.self, from: $0.data) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
