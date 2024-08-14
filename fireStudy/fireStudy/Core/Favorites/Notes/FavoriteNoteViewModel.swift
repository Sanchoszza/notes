//
//  FavoriteNoteViewModel.swift
//  fireStudy
//
//  Created by Alexandra on 02.08.2024.
//

import Foundation
import Combine

@MainActor
final class FavoriteNoteViewModel: ObservableObject {
    @Published private(set) var note: [UserFavoriteNote] = []
    private var cancellables = Set<AnyCancellable>()
    
    func addListenerForFavoriteNote() {
        guard let authDataResult = try? AuthManager.shared.getAuthUser() else { return }
        
        UserManager.shared.addListenerForAllUserFavoriteNotes(userId: authDataResult.uid)
            .sink { completion in
                
            } receiveValue: { [weak self] notes in
                self?.note = notes
            }
            .store(in: &cancellables)

    }
    
    func removeFromFavorite(favoriteNoteId: String) {
        Task {
            let authDataResult = try AuthManager.shared.getAuthUser()
            try? await UserManager.shared.removeUserFavoriteNote(userId: authDataResult.uid, favoriteNoteId: favoriteNoteId)
        }
    }
}
