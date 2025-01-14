//
//  HomeView.swift
//  Advize
//
//  Created by Elliott Griffin on 1/7/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = ConversationsViewModel()
    @State private var isAddingConversation = false
    @State private var isManagingFigures = false
    @State private var figures: [String] = UserDefaults.standard.stringArray(forKey: "figures") ?? ["Marcus Aurelius", "Picasso", "Ben Franklin"]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.conversations, id: \.title) { conversation in
                    NavigationLink(destination: ConversationView(conversation: conversation)) {
                        VStack(alignment: .leading) {
                            Text(conversation.title)
                            Text(conversation.figure)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: viewModel.deleteConversation)
            }
            .navigationTitle("Conversations")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { isAddingConversation = true }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isManagingFigures = true }) {
                        Text("Manage Figures")
                    }
                }
            }
        }
        .sheet(isPresented: $isAddingConversation) {
            AddConversationView(figures: figures) { title, figure in
                viewModel.addConversation(title: title, figure: figure)
                isAddingConversation = false
            }
        }
        .sheet(isPresented: $isManagingFigures) {
            ManageFiguresView(figures: $figures)
        }
    }
}
