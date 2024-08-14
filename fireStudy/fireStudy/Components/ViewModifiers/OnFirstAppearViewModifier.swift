//
//  OnFirstAppearViewModifier.swift
//  fireStudy
//
//  Created by Alexandra on 26.07.2024.
//

import SwiftUI

struct OnFirstAppearViewModifier: ViewModifier {
    
    @State private var didApear: Bool = false
    let perfom: (() -> Void)?
 
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !didApear {
                    perfom?()
                    didApear = true
                }
            }
    }
}


extension View {
    
    func onFirstAppear(perfom: (() -> Void)?) -> some View {
        modifier(OnFirstAppearViewModifier(perfom: perfom))
    }
}
