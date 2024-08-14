//
//  AnalyticsView.swift
//  fireStudy
//
//  Created by Alexandra on 31.07.2024.
//

import SwiftUI
import FirebaseAnalytics
import FirebaseAnalyticsSwift

final class AnalyticsManager {
    
    static let shared = AnalyticsManager()
    private init() { }
    
    func logEvent(name: String, params: [String:Any]? = nil) {
        Analytics.logEvent(name, parameters: params)
    }
    
    func setUserId(userId: String) {
        Analytics.setUserID(userId)
    }
    
    func setUserProperty(value: String?, property: String) {
        Analytics.setUserProperty(value, forName: property)
    }
}

struct AnalyticsView: View {
    var body: some View {
        VStack(spacing: 40) {
            Button("Click me!") {
                AnalyticsManager.shared.logEvent(name: "AnalyticsView_buttonClick")
            }
            
            Button("Click me too!") {
                AnalyticsManager.shared.logEvent(name: "AnalyticsView_secondButtonClick", params: ["screen_title" : "Hello!"])
            }
        }
        .analyticsScreen(name: "AnalyticsView")
        .onAppear {
            AnalyticsManager.shared.logEvent(name: "AnalyticsView_Appear")
        }
        .onDisappear {
            AnalyticsManager.shared.logEvent(name: "AnalyticsView_Disappear")
            AnalyticsManager.shared.setUserId(userId: "asdf111")
            AnalyticsManager.shared.setUserProperty(value: true.description, property: "user_is_premium")
        }
    }
}

#Preview {
    AnalyticsView()
}
