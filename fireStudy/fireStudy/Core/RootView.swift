//
//  RootView.swift
//  fireStudy
//
//  Created by Alexandra on 23.07.2024.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSigninView: Bool = false
    
    var body: some View {
        ZStack {
            if !showSigninView {
                TabbarView(showSignInView: $showSigninView)
            }
        }
        .onAppear {
            let authUser = try? AuthManager.shared.getAuthUser()
            self.showSigninView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSigninView, content: {
            NavigationStack {
                AuthView(showSignInView: $showSigninView)
            }
        })
    }
}

#Preview {
    RootView()
}
