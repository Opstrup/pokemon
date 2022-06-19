import Combine
import Foundation

class PokemonDetailsViewModel: ObservableObject {
    @Published private(set) var state = State()
    private var cancellable: Set<AnyCancellable> = []
    
    func fetchPokemonDetails (pokemonDetailsURL: URL) {
        PokemonAPI.fetchPokemonDetails(pokemonDetailsURL)
            .sink(receiveCompletion: onReceivePokemonDetails,
                  receiveValue: onReceivePokemonDetails)
            .store(in: &cancellable)
    }
    
    struct State {
        var pokemonDetails: PokemonDetailsDataModel?
        var isLoading = true
        var error: String? = nil
    }
    
    private func onReceivePokemonDetails(_ completion: Subscribers.Completion<Error>) {
            switch completion {
            case .finished:
                break
            case .failure:
                self.state.error = "Failed to fetch Pokemon details..."
                break
            }
            self.state.isLoading = false
        }
    
    private func onReceivePokemonDetails(_ pokemonDetails: PokemonDetailsDataModel) {
        self.state.pokemonDetails = pokemonDetails
    }
}
