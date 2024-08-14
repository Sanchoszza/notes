//
//  AllNotesView.swift
//  fireStudy
//
//  Created by Alexandra on 02.08.2024.
//

import SwiftUI

struct AllNotesView: View {
    
    @StateObject private var viewModel = AllNotesViewModel()
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.note) { note in
                    NoteItemView(note: note)
                        .contextMenu{
                            Button(NSLocalizedString("addToFav", comment: "")) {
                                viewModel.addUserFavoriteNote(noteId: note.id)
                            }
                        }
                    if note == viewModel.note.last {
                        Text(NSLocalizedString("endOfList", comment: ""))
                            .onAppear {
                                viewModel.getNote()
                            }
                    }
                }
            }
        }
        .navigationTitle(NSLocalizedString("notes", comment: ""))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    AddNoteView()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.headline)
                }
            }
        }
        .onAppear {
            viewModel.getNote()
        }
    }
}

#Preview {
    AllNotesView()
}
