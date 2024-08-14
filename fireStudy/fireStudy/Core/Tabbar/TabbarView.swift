//
//  TabbarView.swift
//  fireStudy
//
//  Created by Alexandra on 25.07.2024.
//

import SwiftUI

struct TabbarView: View {
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        TabView {
            NavigationStack {
                AllNotesView()
                
            }
            .tabItem {
                Image(systemName: "pencil.and.list.clipboard")
                Text(NSLocalizedString("notes", comment: ""))
            }
            
            NavigationStack {
                AddNoteView()
            }
            .tabItem {
                Image(systemName: "note.text.badge.plus")
                Text(NSLocalizedString("create", comment: ""))
            }
            
            NavigationStack {
                FavoriteNoteView()
            }
            .tabItem {
                Image(systemName: "star.fill")
                Text(NSLocalizedString("favorite", comment: ""))
            }
            
            NavigationStack {
                ProfileView(showSignInView: $showSignInView)
            }
            .tabItem {
                Image(systemName: "person")
                Text(NSLocalizedString("profile", comment: ""))
            }
        }
    }
}

#Preview {
    TabbarView(showSignInView: .constant(false))
}
