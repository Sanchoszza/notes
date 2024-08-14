//
//  FavoriteViewViewModel.swift
//  fireStudy
//
//  Created by Alexandra on 26.07.2024.
//

import Foundation
import Combine

@MainActor
final class FavoriteViewViewModel: ObservableObject {
    
    @Published private(set) var userFavoriteProducts: [UserFavoriteProduct] = []
    private var cancellables = Set<AnyCancellable>()
    
    func addListenerFOrFavorites() {
        guard let authDataResult = try? AuthManager.shared.getAuthUser() else { return }
        
        UserManager.shared.addListenerForAllUserFavoriteProducts(userId: authDataResult.uid)
            .sink { completion in
                
            } receiveValue: { [weak self] products in
                self?.userFavoriteProducts = products
            }
            .store(in: &cancellables)
        
//        UserManager.shared.addListenerForAllUserFavoriteProducts(userId: authDataResult.id) { [weak self] products in
//            self?.userFavoriteProducts = products
//        }
    }
    
    
    func removeFromFavorite(favoriteProductid: String) {
        Task {
            let authDataResult = try AuthManager.shared.getAuthUser()
            try? await UserManager.shared.removeUserFavoriteProduct(userId: authDataResult.uid ,favoriteProductId: favoriteProductid)
//            getFavorites()
        }
    }
}
