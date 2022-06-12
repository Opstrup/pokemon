import SwiftUI

struct PokemonDetailScene: View {
    @ObservedObject private var viewModel = PokemonDetailsViewModel()
    let pokemon: Pokemon
    
    var body: some View {
        VStack {
            PokemonNameHeaderView(name: pokemon.name)
            
            PokemonDetailsView(
                pokemonDetails: viewModel.state.pokemonDetails,
                isLoading: viewModel.state.isLoading,
                error: viewModel.state.error
            )
            
            Spacer()
        }
        .onAppear(perform: {
            viewModel.fetchPokemonDetails(pokemonDetailsURL: URL(string: pokemon.url)!)
        })
    }
}

struct PokemonDetailsView: View {
    let pokemonDetails: PokemonDetailDataModel?
    let isLoading: Bool
    let error: String?
    
    var body: some View {
        if let pokemonDetails = pokemonDetails {
            VStack {
                HStack {
                    PokemonProfilePictureCard(profilePictureURLString: pokemonDetails.sprites.front_default)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Name: \(pokemonDetails.name)")
                        Text("Weight: \(pokemonDetails.weight)")
                        Text("Height: \(pokemonDetails.height)")
                    }
                    .padding(.leading, 12)
                    
                    Spacer()
                }
                .padding(.leading, 30)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Type:")
                        
                        Spacer()
                    }
                    
                    ForEach(pokemonDetails.types) { type in
                        Text("- \(type.type.name.rawValue)")
                    }
                }
                .padding(.leading, 30)
                .padding(.top, 15)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Base stats:")
                        
                        Spacer()
                    }
                    
                    ForEach(pokemonDetails.stats) { stat in
                        Text("- \(stat.stat.name): \(stat.base_stat)")
                    }
                }
                .padding(.leading, 30)
                .padding(.top, 15)
            }
        }
        
        if isLoading {
            VStack {
                Text("Fetching pokemon details...")
                ProgressView()
            }
        }
        
        if let error = error {
            Text(error)
        }
    }
}

struct PokemonProfilePictureCard: View {
    let profilePictureURLString: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.white)
                .shadow(radius: 10)
            
            AsyncImage(url: URL(string: profilePictureURLString), content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
            }, placeholder: {
                ProgressView()
            })
        }
        .frame(width: 100, height: 50)
    }
}

struct PokemonNameHeaderView: View {
    let name: String
    let backgroundColors: [Color] = [.green, .yellow, .red, .blue]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(backgroundColors.randomElement()!)
                .shadow(radius: 10)
            
            Text(name)
                .font(.largeTitle)
        }
        .frame(height: 220)
        .padding()
    }
}

struct PokemonDetailScene_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailsView(pokemonDetails: PokemonDetailDataModel.stubPokemonDetail, isLoading: false, error: nil)
        PokemonDetailsView(pokemonDetails: nil, isLoading: true, error: nil)
        PokemonDetailScene(pokemon: PokemonListDataModel.stubListPokemon.results.first!)
    }
}
