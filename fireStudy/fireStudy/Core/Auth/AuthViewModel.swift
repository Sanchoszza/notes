//
//  AuthViewModel.swift
//  fireStudy
//
//  Created by Alexandra on 23.07.2024.
//

import Foundation

@MainActor
final class AuthViewModel: ObservableObject {

    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthManager.shared.signInWithGoogle(tokens: tokens)
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }
    
    func signInApple() async throws {
        let helper = SignInWithAppleHelper()
        let token = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await AuthManager.shared.signInWithApple(tokens: token)
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }
    
    func signInAnonymous() async throws {
        let authDataResult = try await AuthManager.shared.signInAnonymous()
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }

}
