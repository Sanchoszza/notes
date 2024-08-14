//
//  ProfileView.swift
//  fireStudy
//
//  Created by Alexandra on 23.07.2024.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
//    @Binding var showEditProfileView: Bool
    @State private var selecteItem: PhotosPickerItem? = nil
    @State private var url: URL? = nil
    
    let options: [String] = [
        "Sport", "Movies", "Books"
    ]
    
    private func preferenceIsSelected(text: String) -> Bool {
        viewModel.user?.preferences?.contains(text) == true
    }
    
    var body: some View {
        List {
            if let user = viewModel.user {
                
                if let urlString = viewModel.user?.profileImagePathUrl, let url = URL(string: urlString) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150, alignment: .center)
                            .cornerRadius(12)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 150, height: 150)
                    }
                }
                
                Text("User name: \(user.userInfo?.name ?? "no name")")
                Text("Birthday: \(Utilities.shared.formattedDate(from: user.userInfo?.birthday ?? Date()))")
                
                
                
//                Button(action: {
//                    viewModel.togglePremiumStatus()
//                }, label: {
//                    Text("User is premium: \((user.isPremium ?? false).description.capitalized)")
//                })
                
//                VStack {
//                    HStack {
//                        ForEach(options, id: \.self) { string in
//                            Button(string) {
//                                if preferenceIsSelected(text: string) {
//                                    viewModel.removeUserPreference(text: string)
//                                } else {
//                                    viewModel.addUserPreference(text: string)
//                                }
//                               
//                            }
//                            .font(.headline)
//                            .buttonStyle(.borderedProminent)
//                            .tint(preferenceIsSelected(text: string) ? .green : .red)
//                        }
//                    }
//                    
//                    Text("User preferences: \((user.preferences ?? []).joined(separator: ", "))")
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                }
                
//                Button(action: {
//                    if user.favoriteMovie == nil {
//                        viewModel.addFavoriteMovie()
//                    } else {
//                        viewModel.removeFavoriteMovie()
//                    }
//                }, label: {
//                    Text("Favorite Movie: \((user.favoriteMovie?.title ?? "").description.capitalized)")
//                })
                
                PhotosPicker(selection: $selecteItem, matching: .images, photoLibrary: .shared()) {
                    Text(NSLocalizedString("selectImg", comment: ""))
                }
                
                if viewModel.user?.profileImagePath != nil {
                    Button {
                        viewModel.deleteProfileImage()
                    } label: {
                        Text(NSLocalizedString("deleteImg", comment: ""))
                    }
                }
            }
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
        .onChange(of: selecteItem, perform: { newValue in
            if let newValue {
                viewModel.saveProfileImage(item: newValue)
            }
        })
        .navigationTitle(Text(NSLocalizedString("profile", comment: "")))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    SettingsView(showSignInView: $showSignInView)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    EditUserInfoView()
                } label: {
                    Image(systemName: "person.crop.circle")
                        .font(.headline)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        RootView()
    }
}
