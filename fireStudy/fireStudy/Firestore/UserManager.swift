//
//  UserManager.swift
//  fireStudy
//
//  Created by Alexandra on 23.07.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

struct Movie: Codable {
    let id: String
    let title: String
    let isPopular: Bool
}

struct FavoriteCategory: Codable {
    let id: String
    let title: String
    let isPopular: Bool
}

struct DBUser: Codable {
    let userId: String
    let isAnonymous: Bool?
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
    let isPremium: Bool?
    let preferences: [String]?
    let favoriteMovie: Movie?
    let favoriteCategory: FavoriteCategory?
    let profileImagePath: String?
    let profileImagePathUrl: String?
    let userInfo: UserInfo?

    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.isAnonymous = auth.isAnonymous
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.dateCreated = Date()
        self.isPremium = false
        self.preferences = nil
        self.favoriteMovie = nil
        self.favoriteCategory = nil
        self.profileImagePath = nil
        self.profileImagePathUrl = nil
        self.userInfo = nil
    }
    
    init(
        userId: String,
        isAnonymous: Bool? = nil,
        email: String? = nil,
        photoUrl: String? = nil,
        dateCreated: Date? = nil,
        isPremium: Bool? = nil,
        preferences: [String]? = nil,
        favoriteMovie: Movie? = nil,
        favoriteCategory: FavoriteCategory? = nil,
        profileImagePath: String? = nil,
        profileImagePathUrl: String? = nil,
        userInfo: UserInfo? = nil
    ) {
        self.userId = userId
        self.isAnonymous = isAnonymous
        self.email = email
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.isPremium = isPremium
        self.preferences = preferences
        self.favoriteMovie = favoriteMovie
        self.favoriteCategory = favoriteCategory
        self.profileImagePath = profileImagePath
        self.profileImagePathUrl = profileImagePathUrl
        self.userInfo = userInfo
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case isAnonymous = "is_anonymous"
        case email = "email"
        case photoUrl = "photo_url"
        case dateCreated = "date_created"
        case isPremium = "user_isPremium"
        case preferences = "preferences"
        case favoriteMovie = "favorite_movie"
        case favoriteCategory = "favorite_category"
        case profileImagePath = "profile_image_path"
        case profileImagePathUrl = "profile_image_path_url"
        case userInfo = "user_info"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
        self.preferences = try container.decodeIfPresent([String].self, forKey: .preferences)
        self.favoriteMovie = try container.decodeIfPresent(Movie.self, forKey: .favoriteMovie)
        self.favoriteCategory = try container.decodeIfPresent(FavoriteCategory.self, forKey: .favoriteCategory)
        self.profileImagePath = try container.decodeIfPresent(String.self, forKey: .profileImagePath)
        self.profileImagePathUrl = try container.decodeIfPresent(String.self, forKey: .profileImagePathUrl)
        self.userInfo = try container.decodeIfPresent(UserInfo.self, forKey: .userInfo)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.isAnonymous, forKey: .isAnonymous)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
        try container.encodeIfPresent(self.preferences, forKey: .preferences)
        try container.encodeIfPresent(self.favoriteMovie, forKey: .favoriteMovie)
        try container.encodeIfPresent(self.favoriteCategory, forKey: .favoriteCategory)
        try container.encodeIfPresent(self.profileImagePath, forKey: .profileImagePath)
        try container.encodeIfPresent(self.profileImagePathUrl, forKey: .profileImagePathUrl)
        try container.encodeIfPresent(self.userInfo, forKey: .userInfo)
    }
    
}

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    private let userCollection: CollectionReference = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private func userFavoriteProductCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("favorite_products")
    }
    
    private func userFavoriteNoteCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("favorite_notes")
    }
    
//    private func userInfoCollection(userId: String) -> CollectionReference {
//        userDocument(userId: userId).collection("user_info")
//    }
    
    private func userFavoriteNoteDocument(userId: String, favoriteNoteId: String) -> DocumentReference {
        userFavoriteNoteCollection(userId: userId).document(favoriteNoteId)
    }
    
    private func userFavoriteProductDocument(userId: String, favoriteProductId: String) -> DocumentReference {
        userFavoriteProductCollection(userId: userId).document(favoriteProductId)
    }
    
//    private func userInfoDocument(userId: String, userInfoId: String) -> DocumentReference {
//        userInfoCollection(userId: userId).document(userInfoId)
//    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
//        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()

    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private var userFavoriteProductsListener: ListenerRegistration? = nil
    
    private var userNewNote: ListenerRegistration? = nil
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    func updateUserCollection(userId: String, userInfo: UserInfo?) async throws {
        if let userInfo = userInfo {
            let encodedData = try Firestore.Encoder().encode(userInfo)
            let data: [String: Any] = [
                DBUser.CodingKeys.userInfo.rawValue : encodedData
            ]
            try await userDocument(userId: userId).updateData(data)
        } else {
            let data: [String:Any?] = [
                DBUser.CodingKeys.userInfo.rawValue : nil
            ]
            
            try await userDocument(userId: userId).updateData(data as [AnyHashable : Any])
        }
    }
    
    func updateUserPremiumStatus(userId: String, isPremium: Bool) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.isPremium.rawValue : isPremium,
        ]

        try await userDocument(userId: userId).updateData(data)
    }
    
    func updateUserProfileImagePath(userId: String, path: String?, url: String?) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.profileImagePath.rawValue : path,
            DBUser.CodingKeys.profileImagePathUrl.rawValue : url,
        ]

        try await userDocument(userId: userId).updateData(data)
    }
    
    func addUserPreference(userId: String, preference: String) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayUnion([preference])
        ]

        try await userDocument(userId: userId).updateData(data)
    }
    
    func removeUserPreference(userId: String, preference: String) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayRemove([preference])
        ]

        try await userDocument(userId: userId).updateData(data)
    }
    
    func addFavoriteMovie(userId: String, movie: Movie) async throws {
        guard let data = try? encoder.encode(movie) else {
            throw URLError(.badURL)
        }
        
        let dict: [String:Any] = [
            DBUser.CodingKeys.favoriteMovie.rawValue : data
        ]

        try await userDocument(userId: userId).updateData(dict)
    }
    
    func removeFavoriteMovie(userId: String) async throws {
        let data: [String:Any?] = [
            DBUser.CodingKeys.favoriteMovie.rawValue : nil
        ]

        try await userDocument(userId: userId).updateData(data as [AnyHashable : Any])
    }
    
//    func addUserInfo(userId: String, userInfoId: String) async throws {
//        let document = userInfoCollection(userId: userId).document()
//        let documentId = document.documentID
//        
//        let data: [String: Any] = [
//            UserInfoForCollection.CodingKeys.id.rawValue : documentId,
//            UserInfoForCollection.CodingKeys.infoId.rawValue : userInfoId
//            
//        ]
//        
//        try await document.setData(data, merge: false)
//    }
    
    func addUserFavoriteNote(userId: String, noteId: String) async throws {
        let document = userFavoriteNoteCollection(userId: userId).document()
        let documentId = document.documentID
        
        let data: [String: Any] = [
            UserFavoriteNote.CodingKeys.id.rawValue : documentId,
            UserFavoriteNote.CodingKeys.noteId.rawValue : noteId,
            UserFavoriteNote.CodingKeys.dateCreated.rawValue : Timestamp()
        ]
        
        try await document.setData(data, merge: false)
    }
    
    func addUserFavoriteProduct(userId: String, productId: Int) async throws {
        let document = userFavoriteProductCollection(userId: userId).document()
        let documentId = document.documentID
        
        let data: [String:Any] = [
            UserFavoriteProduct.CodingKeys.id.rawValue : documentId,
            UserFavoriteProduct.CodingKeys.productId.rawValue : productId,
            UserFavoriteProduct.CodingKeys.dateCreated.rawValue : Timestamp()
        ]
        
        try await document.setData(data, merge: false)
    }
    
    func removeUserFavoriteNote(userId: String, favoriteNoteId: String) async throws {
        try await userFavoriteNoteDocument(userId: userId, favoriteNoteId: favoriteNoteId).delete()
    }
    
    func getUserFavoriteNoteById(userId: String, noteId: String) async throws -> UserFavoriteNote {
        let snapshot = try await userFavoriteNoteCollection(userId: userId)
            .whereField(UserFavoriteNote.CodingKeys.noteId.rawValue, isEqualTo: noteId)
            .getDocuments()
        
        guard let document = snapshot.documents.first else {
            throw URLError(.badURL)
        }
        
        return try document.data(as: UserFavoriteNote.self)
    }
    
    func removeUserFavoriteProduct(userId: String, favoriteProductId: String) async throws {
        try await userFavoriteProductDocument(userId: userId, favoriteProductId: favoriteProductId).delete()
    }
    
    func getAllUserFavoriteProducts(userId: String) async throws -> [UserFavoriteProduct] {
        try await userFavoriteProductCollection(userId: userId).getDocuments(as: UserFavoriteProduct.self)
    }
    
    func removeListenerForAllUserFavoriteProducts() {
        self.userFavoriteProductsListener?.remove()
    }
    
    func removeListenerForNewNotes() {
        self.userNewNote?.remove()
    }
    
    func addListenerForAllUserFavoriteProducts(userId: String, completion: @escaping (_ products: [UserFavoriteProduct]) -> Void) {
        self.userFavoriteProductsListener = userFavoriteProductCollection(userId: userId).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            let products: [UserFavoriteProduct] = documents.compactMap({ try? $0.data(as: UserFavoriteProduct.self) })
            completion(products)
            
            querySnapshot?.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    print("New products: \(diff.document.data())")
                }
                if (diff.type == .modified) {
                    print("Modified products: \(diff.document.data())")
                }
                if (diff.type == .removed) {
                    print("Removed products: \(diff.document.data())")
                }
            }
        }
    }
    
    func addListenerForNewNote(userId: String,completion: @escaping (_ products: [UserFavoriteNote]) -> Void) {
        
    }
    
    func addListenerForAllUserFavoriteProducts(userId: String) -> AnyPublisher<[UserFavoriteProduct], Error> {
        let (publisher, listener) = userFavoriteProductCollection(userId: userId)
            .addSnapshotListener(as: UserFavoriteProduct.self)
        
        self.userFavoriteProductsListener = listener
        return publisher
    }
    
    func addListenerForAllUserFavoriteNotes(userId: String) -> AnyPublisher<[UserFavoriteNote], Error> {
        let (publisher, listener) = userFavoriteNoteCollection(userId: userId)
            .addSnapshotListener(as: UserFavoriteNote.self)
        
        self.userNewNote = listener
        return publisher
    }
    
    func isNoteFavorite(userId: String, noteId: String) async throws -> Bool {
        let snapshot = try await userFavoriteNoteCollection(userId: userId)
            .whereField(UserFavoriteNote.CodingKeys.noteId.rawValue, isEqualTo: noteId)
            .getDocuments()
        
        return !snapshot.documents.isEmpty
    }
    
    
}

import Combine

struct UserFavoriteProduct: Codable {
    let id: String
    let productId: Int
    let dateCreated: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case productId = "product_id"
        case dateCreated = "date_created"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.productId = try container.decode(Int.self, forKey: .productId)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.productId, forKey: .productId)
        try container.encode(self.dateCreated, forKey: .dateCreated)
    }
    
}


struct UserFavoriteNote: Codable {
    let id:String
    let noteId: String
    let dateCreated: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case noteId = "note_id"
        case dateCreated = "date_created"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.noteId = try container.decode(String.self, forKey: .noteId)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.noteId, forKey: .noteId)
        try container.encode(self.dateCreated, forKey: .dateCreated)
    }
}

struct UserInfoForCollection: Codable {
    let id: String
    let infoId: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case infoId = "info_id"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.infoId = try container.decode(String.self, forKey: .infoId)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.infoId, forKey: .infoId)
    }
}


