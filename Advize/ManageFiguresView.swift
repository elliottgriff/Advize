//
//  ManageFiguresView.swift
//  Advize
//
//  Created by Elliott Griffin on 1/7/25.
//

import SwiftUI

struct ManageFiguresView: View {
    @Binding var figures: [String]
    @Environment(\.dismiss) private var dismiss
    @State private var newFigure = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(figures, id: \.self) { figure in
                        Text(figure)
                    }
                    .onDelete(perform: deleteFigure)
                }
                
                HStack {
                    TextField("Add new figure", text: $newFigure)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Add") {
                        addFigure()
                    }
                    .disabled(newFigure.isEmpty)
                }
                .padding()
            }
            .navigationTitle("Manage Figures")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func addFigure() {
        if !figures.contains(newFigure) {
            figures.append(newFigure)
            UserDefaults.standard.set(figures, forKey: "figures")
            newFigure = ""
        }
    }
    
    private func deleteFigure(at offsets: IndexSet) {
        figures.remove(atOffsets: offsets)
        UserDefaults.standard.set(figures, forKey: "figures")
    }
}
