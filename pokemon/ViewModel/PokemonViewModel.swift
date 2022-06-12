import Combine
import Foundation

class PokemonViewModel: ObservableObject {
    @Published private(set) var state = State()
    private var cancellable: Set<AnyCancellable> = []
        
    func fetchPokemons() {
        if let nextPageURL = self.state.nextPageURL {
            PokemonAPI.fetchPokemons(nextPageURL)
                .sink(receiveCompletion: onReceiveMorePokemons,
                      receiveValue: onReceiveMorePokemons)
                .store(in: &cancellable)
        } else {
            PokemonAPI.fetchPokemons()
                .sink(receiveCompletion: onReceiveMorePokemons,
                      receiveValue: onReceiveMorePokemons)
                .store(in: &cancellable)
        }
    }
    
    struct State {
        var pokemonList: PokemonList = []
        var isLoading = true
        var nextPageURL: URL?
        var error: String?
    }
    
    private func onReceiveMorePokemons(_ completion: Subscribers.Completion<Error>) {
            switch completion {
            case .finished:
                break
            case .failure:
                self.state.isLoading = false
                self.state.error = "Failed to fetch pokemons..."
                break
            }
        }
    
    private func onReceiveMorePokemons(_ newPokemonListData: PokemonListDataModel) {
        self.state.pokemonList += newPokemonListData.results
        self.state.isLoading = newPokemonListData.next != nil
        
        if let nextPageURLString = newPokemonListData.next {
            self.state.nextPageURL = URL(string: nextPageURLString)
        }
    }
}
