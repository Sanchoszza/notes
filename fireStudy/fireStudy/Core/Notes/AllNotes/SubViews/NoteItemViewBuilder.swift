//
//  NoteItemViewBuilder.swift
//  fireStudy
//
//  Created by Alexandra on 02.08.2024.
//

import SwiftUI

struct NoteItemViewBuilder: View {
    let noteId: String
    @State private var note: NoteModel? = nil
    
    var body: some View {
        ZStack {
            if let note {
                NoteItemView(note: note)
            }
        }
        .task {
            self.note = try? await NotesManager.shared.getNote(noteId: noteId)
        }
    }
}

#Preview {
    NoteItemViewBuilder(noteId: "1")
}
