//
//  ConversationsViewModel.swift
//  Advize
//
//  Created by Elliott Griffin on 1/14/25.
//


import Foundation

class ConversationsViewModel: ObservableObject {
    @Published var conversations: [(title: String, figure: String)] = []
    
    init() {
        loadConversations()
    }
    
    func addConversation(title: String, figure: String) {
        conversations.append((title: title, figure: figure))
        saveConversations()
    }
    
    func deleteConversation(at offsets: IndexSet) {
        conversations.remove(atOffsets: offsets)
        saveConversations()
    }
    
    private func loadConversations() {
        if let storedConversations = UserDefaults.standard.array(forKey: "conversations") as? [[String: String]] {
            conversations = storedConversations.compactMap { dict in
                guard let title = dict["title"], let figure = dict["figure"] else { return nil }
                return (title: title, figure: figure)
            }
        }
    }
    
    private func saveConversations() {
        let storedConversations = conversations.map { ["title": $0.title, "figure": $0.figure] }
        UserDefaults.standard.set(storedConversations, forKey: "conversations")
    }
}
