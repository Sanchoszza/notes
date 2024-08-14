//
//  AllNotesViewModel.swift
//  fireStudy
//
//  Created by Alexandra on 02.08.2024.
//

import Foundation
import FirebaseFirestore

@MainActor
final class AllNotesViewModel: ObservableObject {
    
    @Published private(set) var note: [NoteModel] = []
    private var lastDocument: DocumentSnapshot? = nil
    
    func getNote() {
        Task {
            let (newNote, lastDocument) = try await NotesManager.shared.getAllNotes(lastDocument: lastDocument)
            self.note.append(contentsOf: newNote)
            if let lastDocument {
                self.lastDocument = lastDocument
            }
        }
    }
    
    func addUserFavoriteNote(noteId: String) {
        Task {
            let authDataResult = try AuthManager.shared.getAuthUser()
            try await UserManager.shared.addUserFavoriteNote(userId: authDataResult.uid, noteId: noteId)
        }
    }
    
    func removeFromFavorite(favoriteNoteId: String) {
        Task {
            let authDataResult = try AuthManager.shared.getAuthUser()
//            let favoriteNote = try await UserManager.shared.getUserFavoriteNoteById(userId: authDataResult.uid, noteId: favoriteNoteId)
            try? await UserManager.shared.removeUserFavoriteNote(userId: authDataResult.uid, favoriteNoteId: favoriteNoteId)
            print("Removed!!!")
        }
    }
    
    func isFavorite(noteId: String) -> Bool {
        var isFav: Bool = false
        Task {
            let authDataResult = try AuthManager.shared.getAuthUser()
            isFav = try await UserManager.shared.isNoteFavorite(userId: authDataResult.uid, noteId: noteId)
        }
        return isFav
    }
}
