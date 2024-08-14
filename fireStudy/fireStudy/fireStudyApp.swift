//
//  fireStudyApp.swift
//  fireStudy
//
//  Created by Alexandra on 09.07.2024.
//

import SwiftUI
import Firebase

@main
struct fireStudyApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
//    init() {
//        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.red)]
//        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.red)]
//        UINavigationBar.appearance().tintColor = UIColor(Color.red)
//        UITableView.appearance().backgroundColor = UIColor.clear
//    }
    
    var body: some Scene {
        WindowGroup {
//            ZStack {
//                Color.bgAccent.ignoresSafeArea()
                RootView()
//            }
            CrashView()
           
//            PerformanceView()
//            AnalyticsView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
