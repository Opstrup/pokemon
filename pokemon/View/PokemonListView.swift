import SwiftUI

struct PokemonListView: View {
    @ObservedObject private var viewModel = PokemonViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                PokemonList(
                    pokemonList: viewModel.state.pokemonList,
                    isLoading: viewModel.state.isLoading,
                    onScrolledAtBottom: viewModel.fetchPokemons,
                    error: viewModel.state.error
                )
                .onAppear(perform: viewModel.fetchPokemons)
            }
            .navigationBarTitle("Pokédex")
        }
    }
}

struct PokemonList: View {
    let pokemonList: [Pokemon]
    let isLoading: Bool
    let onScrolledAtBottom: () -> Void
    let error: String?
    
    var body: some View {
        VStack {
            if let error = error {
                VStack {
                    Spacer()
                    Text(error)
                }
            }
            
            List {
                ForEach(pokemonList) { pokemon in
                    NavigationLink(destination: PokemonDetailsView(pokemon: pokemon)) {
                        PokemonListRow(pokemon: pokemon).onAppear {
                            if self.pokemonList.last == pokemon {
                                self.onScrolledAtBottom()
                            }
                        }
                    }
                }
                                
                if isLoading {
                    VStack {
                        if pokemonList.isEmpty {
                            Text("Fetching pokemons...")
                        }
                        ProgressView()
                    }
                    .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
                }
            }
            .listStyle(PlainListStyle())
        }
    }
}

struct PokemonListRow: View {
    let pokemon: Pokemon
    
    var body: some View {
        HStack {
            Text(pokemon.name)
        }
        .padding(.vertical, 10)
    }
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView()
        PokemonList(pokemonList: PokemonListDataModel.stubListPokemon.results, isLoading: false, onScrolledAtBottom: {}, error: nil)
        PokemonList(pokemonList: PokemonListDataModel.stubListPokemon.results, isLoading: true, onScrolledAtBottom: {}, error: nil)
        PokemonList(pokemonList: [], isLoading: true, onScrolledAtBottom: {}, error: nil)
        PokemonList(pokemonList: [], isLoading: false, onScrolledAtBottom: {}, error: "Failed to fetch pokemons...")
    }
}
