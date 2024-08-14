//
//  NoteItemView.swift
//  fireStudy
//
//  Created by Alexandra on 02.08.2024.
//

import SwiftUI

struct NoteItemView: View {
    
    let note: NoteModel
    @State private var fillStar: Bool = false
    @StateObject private var viewModel = AllNotesViewModel()
    @StateObject private var favoriteViewModel = FavoriteNoteViewModel()
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 12) {
                Text(note.title ?? NSLocalizedString("title", comment: ""))
                    .multilineTextAlignment(.leading)
                    .fontWeight(.medium)
                Spacer()
                Image(systemName: fillStar ? "star.fill" : "star")
                    .foregroundColor(fillStar ? Color.yellow : Color.gray)
                    .onTapGesture {
                        Task {
                            try await toggleFavorite()
                        }
                    }
            }
            .padding(.horizontal)
            
            Text(note.description ?? NSLocalizedString("description", comment: ""))
                .multilineTextAlignment(.leading)
                .font(.callout)
        }
        .onAppear {
            Task {
                try await checkIsFavorite()
            }
        }
    }
    
    private func checkIsFavorite() async throws {
        do {
            let authDataResult = try AuthManager.shared.getAuthUser()
            let isFavorite = try await UserManager.shared.isNoteFavorite(userId: authDataResult.uid, noteId: note.id)
            fillStar = isFavorite
        } catch {
            print("Error in checkIsFavorite")
        }
    }
    
    private func toggleFavorite() async throws {
        do {
            let authDataResult = try AuthManager.shared.getAuthUser()
            if fillStar {
                if let favoriteNote = try? await UserManager.shared.getUserFavoriteNoteById(userId: authDataResult.uid, noteId: note.id) {
                    favoriteViewModel.removeFromFavorite(favoriteNoteId: favoriteNote.id)
                }
            } else {
                viewModel.addUserFavoriteNote(noteId: note.id)
            }
            fillStar.toggle()
        } catch {
            print("Error in toggleFavorite")
        }
    }
}

//#Preview {
//    NoteItemView(note: NoteModel(id: "1", title: "title", description: "description", category: "category", author: "author"))
//}
