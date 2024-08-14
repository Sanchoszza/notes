//
//  UserInfo.swift
//  fireStudy
//
//  Created by Alexandra on 12.08.2024.
//

import Foundation

struct UserInfo: Identifiable, Codable, Equatable {
    var id: String
    let name: String?
    let birthday: Date?
    let surname: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case birthday = "birthday"
        case surname = "surname"
    }
    
//    init(from decoder: any Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decode(String.self, forKey: .id)
//        self.name = try container.decode(String.self, forKey: .name)
//        self.birthday = try container.decode(Date.self, forKey: .birthday)
//        self.surname = try container.decode(String.self, forKey: .surname)
//    }
//    
//    func encode(to encoder: any Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(self.id, forKey: .id)
//        try container.encode(self.name, forKey: .name)
//        try container.encode(self.birthday, forKey: .birthday)
//        try container.encode(self.surname, forKey: .surname)
//    }
    
    static func == (lhs: UserInfo, rhs: UserInfo) -> Bool {
        return lhs.id == rhs.id
    }
}
