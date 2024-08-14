//
//  SettingsViewModel.swift
//  fireStudy
//
//  Created by Alexandra on 23.07.2024.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject{
    
    @Published var authProviders: [AuthProviderOption] = []
    @Published var authUser: AuthDataResultModel? = nil
    
    func loadAuthProviders() {
        if let provider = try? AuthManager.shared.getProviders() {
            authProviders = provider
        }
    }
    
    func loadAuthUser() {
        self.authUser = try? AuthManager.shared.getAuthUser()
    }
    
    func logOut() throws {
        try AuthManager.shared.signOut()
    }
    
    func deleteAccount() async throws {
        try await AuthManager.shared.deleteUser()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthManager.shared.getAuthUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws {
        let email = "helloo11@mail.ru"
        try await AuthManager.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws {
        let password = "password"
        try await AuthManager.shared.updatePasword(password: password)
    }
    
    func linkGoogleAccount() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthManager.shared.linkGoogle(tokens: tokens)
        self.authUser = authDataResult
    }
    
    func linkAppleAccount() async throws {
        let helper = SignInWithAppleHelper()
        let token = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await AuthManager.shared.linkApple(tokens: token)
        self.authUser = authDataResult
    }
    
    func linkEmailAccount() async throws {
        let email = "helloo11@mail.ru"
        let password = "password"
        let authDataResult = try await AuthManager.shared.linkEmail(email: email, password: password)
        self.authUser = authDataResult
    }
}
