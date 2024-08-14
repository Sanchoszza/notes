//
//  FavoriteNoteView.swift
//  fireStudy
//
//  Created by Alexandra on 02.08.2024.
//

import SwiftUI

struct FavoriteNoteView: View {
    
    @StateObject private var viewModel = FavoriteNoteViewModel()
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.note, id: \.id.self) { item in
                    NoteItemViewBuilder(noteId: item.noteId)
                        .contextMenu{
                            Button(NSLocalizedString("removeFromFav", comment: "")) {
                                viewModel.removeFromFavorite(favoriteNoteId: item.id)
                            }
                        }
                    
                }
            }
            .navigationTitle(NSLocalizedString("favorite", comment: ""))
            .onFirstAppear {
                viewModel.addListenerForFavoriteNote()
            }
        }
    }
}

#Preview {
    FavoriteNoteView()
}
