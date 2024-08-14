//
//  PerformanceView.swift
//  fireStudy
//
//  Created by Alexandra on 30.07.2024.
//

import SwiftUI
import FirebasePerformance

final class PerformanceManager {
    
    static let shared = PerformanceManager()
    private init() { }
    
//    var trace: Trace? = nil // 22 minut
    
    private var traces: [String:Trace] = [:]
    
    func startTrace(name: String) {
        let trace = Performance.startTrace(name: name)
        traces[name] = trace
    }
    
    func setValue(name: String, value: String, forAttribute: String) {
        guard let trace = traces[name] else { return }
        trace.setValue(value, forAttribute: forAttribute)
    }
    
    func stoptrace(name: String) {
        guard let trace = traces[name] else { return }
        trace.stop()
        traces.removeValue(forKey: name)
    }
}

struct PerformanceView: View {
    
    @State private var title: String = "Some TITLE"
    @State private var trace: Trace? = nil
    
    var body: some View {
        Text("Hello, World!")
            .onAppear {
                configure()
                downloadProductsAndUploadToFirebase()
                PerformanceManager.shared.startTrace(name: "perfomance_screen_time")
            }
            .onDisappear {
                PerformanceManager.shared.stoptrace(name: "perfomance_screen_time")
            }
    }
    
    private func configure() {
        PerformanceManager.shared.startTrace(name: "perfomance_screen_time")
        
        trace?.setValue(title, forAttribute: "title_text")
        
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            PerformanceManager.shared.setValue(name: "perfomance_screen_time", value: "Started downloading", forAttribute: "func_sate")
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            PerformanceManager.shared.setValue(name: "perfomance_screen_time", value: "Finished downloading", forAttribute: "func_sate")
            PerformanceManager.shared.stoptrace(name: "perfomance_screen_time")
        }
    }
    
    func downloadProductsAndUploadToFirebase() {
        let urlString = "https://dummyjson.com/products"
        guard let url = URL(string: urlString), let metric = HTTPMetric(url: url, httpMethod: .get) else { return }

        metric.start()
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                if let response = response as? HTTPURLResponse {
                 metric.responseCode = response.statusCode
                }
                metric.stop()
                print("Success! Count:")
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    PerformanceView()
}
