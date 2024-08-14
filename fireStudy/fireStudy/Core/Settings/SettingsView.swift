//
//  SettingsView.swift
//  fireStudy
//
//  Created by Alexandra on 09.07.2024.
//

import SwiftUI


struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            Button(action: {
                Task {
                    do {
                        try viewModel.logOut()
                        showSignInView = true
                    } catch {
                        print("ERROR \(error)")
                    }
                }
            }, label: {
                Text(NSLocalizedString("logOut", comment: ""))
            })
            
            Button(role: .destructive) {
                Task {
                    do {
                        try await viewModel.deleteAccount()
                        showSignInView = true
                    } catch {
                        print("ERROR \(error)")
                    }
                }
            } label: {
                Text(NSLocalizedString("deleteAcc", comment: ""))
            }

            
            if viewModel.authProviders.contains(.email) {
                emailSection
            }
         
            if viewModel.authUser?.isAnonymous == true {
                anonymousSection
            }
           
        }
        .onAppear {
            viewModel.loadAuthProviders()
            viewModel.loadAuthUser()
        }
        .navigationTitle(Text(NSLocalizedString("settings", comment: "")))
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
    }
}


extension SettingsView {
    private var emailSection: some View {
        Section {
            Button(action: {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("Password reset")
                    } catch {
                        print("ERROR \(error)")
                    }
                }
            }, label: {
                Text("Reset password")
            })
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.updatePassword()
                        print("Password updated")
                    } catch {
                        print("ERROR \(error)")
                    }
                }
            }, label: {
                Text("Update password")
            })
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.updateEmail()
                        print("Emaul updated")
                    } catch {
                        print("ERROR \(error)")
                    }
                }
            }, label: {
                Text("Update email")
            })
        } header: {
            Text("Email functions")
        }

        
    }
    
    private var anonymousSection: some View {
        Section {
            Button(action: {
                Task {
                    do {
                        try await viewModel.linkGoogleAccount()
                        print("Link Google Account")
                    } catch {
                        print("ERROR \(error)")
                    }
                }
            }, label: {
                Text(NSLocalizedString("linkGoogle", comment: ""))
            })
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.linkAppleAccount()
                        print("Link Apple Account")
                    } catch {
                        print("ERROR \(error)")
                    }
                }
            }, label: {
                Text(NSLocalizedString("linkApple", comment: ""))
            })
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.linkEmailAccount()
                        print("Link Email Account")
                    } catch {
                        print("ERROR \(error)")
                    }
                }
            }, label: {
                Text(NSLocalizedString("linkEmail", comment: ""))
            })
        } header: {
            Text("Email functions")
        }

        
    }
}


