//
//  AddNoteView.swift
//  fireStudy
//
//  Created by Alexandra on 02.08.2024.
//

import SwiftUI

struct AddNoteView: View {
    
    @StateObject private var viewModel = AddNoteViewModel()
    
    private func preferenceIsSelected(text: String) -> Bool {
        viewModel.noteCategory.contains(text)
    }
    
    let options: [String] = [
        NSLocalizedString("sport", comment: ""),
        NSLocalizedString("movie", comment: ""),
        NSLocalizedString("books", comment: ""),
        NSLocalizedString("games", comment: "")
    ]
    
    var body: some View {
        VStack {
            TextField(NSLocalizedString("enterTitle", comment: ""), text: $viewModel.noteTitle)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .frame(maxWidth: .infinity)
            
            VStack {
                HStack {
                    ForEach(options, id: \.self) { string in
                        Button(string) {
                            if preferenceIsSelected(text: string) {
                                viewModel.removeUserPreference(text: string)
                            } else {
                                viewModel.addUserPreference(text: string)
                            }
                        }
                        .font(.headline)
                        .buttonStyle(.borderedProminent)
                        .tint(preferenceIsSelected(text: string) ? .green : .red)
                    }
                }
            }
            
            TextEditor(text: $viewModel.noteContent)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                
                
            
            Button(action: {
                viewModel.addNewNote()
            }) {
                Text(NSLocalizedString("add", comment: ""))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
//            .padding()
        }
        .navigationTitle(NSLocalizedString("addNote", comment: ""))
        .padding()
    }
}

#Preview {
    AddNoteView()
}
