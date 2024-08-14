//
//  CrashView.swift
//  fireStudy
//
//  Created by Alexandra on 30.07.2024.
//

import SwiftUI

struct CrashView: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.3).ignoresSafeArea()
            
            VStack(spacing: 40) {
                Button {
                    CrashManager.shared.addLog(message: "Before crash in BTN 1")
                    let myString: String? = nil
                    
                    guard let myString else {
                        CrashManager.shared.sendNonFatal(error: URLError(.dataNotAllowed))
                        return
                    }
                    
                    let string2 = myString
                } label: {
                    Text("Click ME 1")
                }

                Button {
                    CrashManager.shared.addLog(message: "Before crash in BTN 2")
                    fatalError("Fatal Error! CRASHHH")
                } label: {
                    Text("Click ME 2")
                }
                
                Button {
                    CrashManager.shared.addLog(message: "Before crash in BTN 3")
                    let array: [String] = []
                    let item = array[0]
                } label: {
                    Text("Click ME 3")
                }
            }
        }
        .onAppear {
            CrashManager.shared.setUserId(userId: "abcd1234")
            CrashManager.shared.setIsPremiumValue(isPremium: true)
            CrashManager.shared.addLog(message: "crash_view_appeared")
            CrashManager.shared.addLog(message: "crash view appeared on user's screen")
        }
    }
}

#Preview {
    CrashView()
}
