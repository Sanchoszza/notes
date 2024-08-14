//
//  SignInWithEmail.swift
//  fireStudy
//
//  Created by Alexandra on 09.07.2024.
//

import SwiftUI



struct SignInWithEmail: View {
    
    @StateObject private var viewModel = SignInWithEmailViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            TextField("Email...", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(12)
            SecureField("Password...", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(12)
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.signUp()
                        showSignInView = false
                        return
                    } catch {
                        
                    }
                    
                    do {
                        try await viewModel.signIn()
                        showSignInView = false
                        return
                    } catch {
                        
                    }
                }
                
            }, label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            })
            Spacer()
        }
        .padding()
        .navigationTitle("Sign In With Email")
    }
}

#Preview {
    NavigationStack {
        SignInWithEmail(showSignInView: .constant(false))
    }
}
