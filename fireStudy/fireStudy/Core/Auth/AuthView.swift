//
//  AuthView.swift
//  fireStudy
//
//  Created by Alexandra on 09.07.2024.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct AuthView: View {
    
    @StateObject private var viewModel = AuthViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            
            Button {
                Task {
                    do {
                        try await viewModel.signInAnonymous()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text(NSLocalizedString("signInAnon", comment: ""))
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(10)
            }
            
            NavigationLink {
                SignInWithEmail(showSignInView: $showSignInView)
            } label: {
                Text(NSLocalizedString("signInEmail", comment: ""))
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                Task {
                    do {
                        try await viewModel.signInGoogle()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
            }
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.signInApple()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
            }, label: {
                SignInWithAppleButtonRepresentable(type: .default, style: .black)
                    .allowsTightening(false)
            })
            .frame(height: 55)
            
            Spacer()
        }
        .padding()
        .navigationTitle(NSLocalizedString("signIn", comment: ""))
    }
}

#Preview {
    NavigationStack{
        AuthView(showSignInView: .constant(false))
    }
}
