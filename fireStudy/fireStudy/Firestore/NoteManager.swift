//
//  NoteManager.swift
//  fireStudy
//
//  Created by Alexandra on 02.08.2024.
//

import Foundation
import FirebaseFirestore
import Combine

final class NotesManager {
    
    static let shared = NotesManager()
    private init() { }
    
    private let notesCollection = Firestore.firestore().collection("notes")
    
    private func noteDocument(noteId: String) -> DocumentReference {
        notesCollection.document(noteId)
    }
    
    func uploadNote(note: NoteModel) async throws {
        try noteDocument(noteId: note.id).setData(from: note, merge: false)
    }
    
    func getNote(noteId: String) async throws -> NoteModel {
        try await noteDocument(noteId: noteId).getDocument(as: NoteModel.self)
    }
    
    private func getAllNotesQuery() -> Query {
        notesCollection
    }
    
    func getAllNotes(lastDocument: DocumentSnapshot?) async throws -> (products: [NoteModel], lasDocument: DocumentSnapshot?) {
        var query: Query = getAllNotesQuery()
        
        return try await query.startOptionally(afterDocument: lastDocument)
            .getDocumentsWithSnapshot(as: NoteModel.self)
    }
    
    func addNote(note: NoteModel) async throws {
        let document = notesCollection.document()
        let documentId = document.documentID

        var noteWithId = note
        noteWithId.id = documentId

        try document.setData(from: noteWithId, merge: false)
    }
}
