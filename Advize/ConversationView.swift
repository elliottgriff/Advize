import SwiftUI

struct ConversationView: View {
    let conversation: (title: String, figure: String)
    @State private var userInput = ""
    @State private var chatResponses: [String] = []
    @State private var isLoading = false
    
    private let openAIService = OpenAIService()
    
    var body: some View {
        VStack {
            List(chatResponses, id: \.self) { response in
                Text(response)
                    .padding(.vertical, 4)
            }
            
            HStack {
                TextField("Type your message", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: submitMessage) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Submit")
                            .padding(.horizontal)
                    }
                }
                .disabled(userInput.isEmpty || isLoading)
            }
            .padding()
        }
        .navigationTitle(conversation.title)
    }
    
    func submitMessage() {
        guard !userInput.isEmpty else { return }
        isLoading = true
        
        Task {
            do {
                let response = try await openAIService.generateResponse(
                    prompt: userInput,
                    figure: conversation.figure
                )
                DispatchQueue.main.async {
                    chatResponses.append("You: \(userInput)")
                    chatResponses.append("\(conversation.figure): \(response)")
                    userInput = ""
                    isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    chatResponses.append("Error: Unable to fetch response")
                    isLoading = false
                }
            }
        }
    }
}

