//
//  SignInGoogleHelper.swift
//  fireStudy
//
//  Created by Alexandra on 19.07.2024.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth

struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
    let name: String?
    let email: String?
}


final class SignInGoogleHelper {
    
    @MainActor
    func signIn() async throws -> GoogleSignInResultModel{
        
        guard let topVC = Utilities.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }
        
        let gidSignInRResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken = gidSignInRResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        
        let accessToken: String = gidSignInRResult.user.accessToken.tokenString
        let name = gidSignInRResult.user.profile?.name
        let email = gidSignInRResult.user.profile?.email
        
        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken, name: name, email: email)
        return tokens
    }
}
