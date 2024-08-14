//
//  NoteModel.swift
//  fireStudy
//
//  Created by Alexandra on 02.08.2024.
//

import Foundation

struct NotesArray: Codable {
    let notes: [NoteModel]
    let total, skip, limit: Int
}

struct NoteModel: Identifiable, Codable, Equatable {
    var id: String
    let title: String?
    let description: String?
    let category: String?
    let author: DBUser?
//    let images: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case category
        case author
//        case images
    }
    
    static func == (lhs: NoteModel, rhs: NoteModel) -> Bool {
        return lhs.id == rhs.id
    }
}
