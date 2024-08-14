//
//  SignInWithEmailViewModel.swift
//  fireStudy
//
//  Created by Alexandra on 23.07.2024.
//
import Foundation

@MainActor
final class SignInWithEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password")
            return
        }
        let authDataResult = try await AuthManager.shared.signInUser(email: email, password: password)
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password")
            return
        }
        try await AuthManager.shared.createUser(email: email, password: password)
    }
}
