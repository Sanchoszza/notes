//
//  FavoriteView.swift
//  fireStudy
//
//  Created by Alexandra on 25.07.2024.
//

import SwiftUI
import Combine


struct FavoriteView: View {
    
    @StateObject private var viewModel = FavoriteViewViewModel()
    @State private var didApear: Bool = false
    
    var body: some View {
        List {
            ForEach(viewModel.userFavoriteProducts, id: \.id.self) { item in
                ProductCellViewBuilder(productId: String(item.productId))
                    .contextMenu{
                        Button("Remove from favorites") {
                            viewModel.removeFromFavorite(favoriteProductid: item.id)
                        }
                    }
                
            }
        }
        .navigationTitle("Favorites")
        .onFirstAppear {
            viewModel.addListenerFOrFavorites()
        }
    }
}

#Preview {
    NavigationStack {
        FavoriteView()
    }
    
}


