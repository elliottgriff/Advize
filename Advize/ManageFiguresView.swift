//
//  ManageFiguresView.swift
//  Advize
//
//  Created by Elliott Griffin on 1/7/25.
//


struct ManageFiguresView: View {
    @State private var figures = ["Marcus Aurelius", "Picasso", "Ben Franklin"]
    @State private var newFigure = ""
    
    var body: some View {
        VStack {
            List {
                ForEach(figures, id: \.self) { figure in
                    Text(figure)
                }
                .onDelete { indices in
                    figures.remove(atOffsets: indices)
                }
            }
            
            HStack {
                TextField("Add new figure", text: $newFigure)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Add") {
                    if !newFigure.isEmpty {
                        figures.append(newFigure)
                        newFigure = ""
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Manage Figures")
    }
}
