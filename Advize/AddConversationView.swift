//
//  AddConversationView.swift
//  Advize
//
//  Created by Elliott Griffin on 1/14/25.
//

import SwiftUI

struct AddConversationView: View {
    @State private var newConversation = ""
    @State private var selectedFigure: String
    var figures: [String]
    var onAdd: (String, String) -> Void
    @Environment(\.dismiss) private var dismiss
    
    init(figures: [String], onAdd: @escaping (String, String) -> Void) {
        self.figures = figures
        self.onAdd = onAdd
        _selectedFigure = State(initialValue: figures.first ?? "")
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Conversation title", text: $newConversation)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Picker("Select a Figure", selection: $selectedFigure) {
                    ForEach(figures, id: \.self) { figure in
                        Text(figure)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                
                Spacer()
            }
            .navigationTitle("New Conversation")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        if !newConversation.isEmpty && !selectedFigure.isEmpty {
                            onAdd(newConversation, selectedFigure)
                            dismiss()
                        }
                    }
                    .disabled(newConversation.isEmpty || selectedFigure.isEmpty)
                }
            }
        }
    }
}
