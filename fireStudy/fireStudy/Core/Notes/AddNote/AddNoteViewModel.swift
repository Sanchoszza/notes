//
//  AddNoteViewModel.swift
//  fireStudy
//
//  Created by Alexandra on 02.08.2024.
//

import Foundation
import SwiftUI

@MainActor
final class AddNoteViewModel: ObservableObject {
    
    @Published var noteTitle: String = ""
    @Published var noteContent: String = ""
    @Published var noteCategory: [String] = []
    @Published var noteAuthor: DBUser? = nil
//    @Published private(set) var user: DBUser? = nil
    
    @Published private(set) var notes: [NoteModel] = []
    
    func addNewNote() {
        Task {
            do {
                let authDataResult = try AuthManager.shared.getAuthUser()
                
                let currentUser = try await UserManager.shared.getUser(userId: authDataResult.uid)
                self.noteAuthor = currentUser

                let newNote = NoteModel(
                    id: "",
                    title: noteTitle,
                    description: noteContent,
                    category: noteCategory.joined(separator: ", "),
                    author: noteAuthor)

                try await NotesManager.shared.addNote(note: newNote)

                noteTitle = ""
                noteContent = ""
                noteCategory = []
                
            } catch {
                print("Failed to add note: \(error)")
            }
        }
    }
    
    func addUserPreference(text: String) {
        noteCategory.append(text)
    }
    
    func removeUserPreference(text: String) {
        noteCategory.removeAll { $0 == text }
    }
}
