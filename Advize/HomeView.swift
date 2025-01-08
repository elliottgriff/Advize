//
//  HomeView.swift
//  Advize
//
//  Created by Elliott Griffin on 1/7/25.
//


struct HomeView: View {
    @State private var conversations: [String] = ["Conversation 1"]
    @State private var isAddingConversation = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(conversations, id: \.self) { conversation in
                    NavigationLink(destination: ConversationView(conversation: conversation)) {
                        Text(conversation)
                    }
                }
            }
            .navigationTitle("Conversations")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { isAddingConversation = true }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ManageFiguresView()) {
                        Text("Manage Figures")
                    }
                }
            }
        }
        .sheet(isPresented: $isAddingConversation) {
            AddConversationView { newConversation in
                conversations.append(newConversation)
            }
        }
    }
}
