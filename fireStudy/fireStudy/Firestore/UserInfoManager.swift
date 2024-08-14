//
//  UserInfoManager.swift
//  fireStudy
//
//  Created by Alexandra on 12.08.2024.
//

import Foundation
import FirebaseFirestore
import Combine

final class UserInfoManager {
    
    static let shared = UserInfoManager()
    private init() { }
    
    private let userInfoCollection = Firestore.firestore().collection("user_info")
    
    private func userInfoDocument(userInfiId: String) -> DocumentReference {
        userInfoCollection.document(userInfiId)
    }
    
    func uploadInfo(info: UserInfo) async throws {
        try userInfoDocument(userInfiId: info.id).setData(from: info, merge: false)
    }
    
    func getInfo(userInfoId: String) async throws -> UserInfo {
        try await userInfoDocument(userInfiId: userInfoId).getDocument(as: UserInfo.self)
    }
    
    private func getAllUserInfoQuery() -> Query {
        userInfoCollection
    }
    
    func addUserInfo(info: UserInfo) async throws {
        let document = userInfoCollection.document()
        let documentId = document.documentID
        
        var infoWithId = info
        infoWithId.id = documentId
        
        try document.setData(from: infoWithId, merge: false)
    }
}
