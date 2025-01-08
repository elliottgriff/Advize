import SwiftUI

struct ConversationView: View {
    @State private var userInput = ""
    @State private var chatResponses: [String] = []
    @State private var selectedFigure = "Marcus Aurelius"
    @State private var isLoading = false
    
    private let figures = ["Marcus Aurelius", "Picasso", "Ben Franklin"]
    private let openAIService = OpenAIService()
    
    var body: some View {
        VStack {
            List(chatResponses, id: \.self) {
                Text($0)
            }
            
            HStack {
                Picker("Figure", selection: $selectedFigure) {
                    ForEach(figures, id: \.self) { figure in
                        Text(figure)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                TextField("Type your message", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: submitMessage) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Submit")
                    }
                }
                .disabled(userInput.isEmpty || isLoading)
            }
            .padding()
        }
        .navigationTitle("Conversation")
    }
    
    func submitMessage() {
        guard !userInput.isEmpty else { return }
        isLoading = true
        
        let prompt = "\(selectedFigure) responds: \(userInput)"
        
        Task {
            do {
                let response = try await openAIService.generateResponse(prompt: prompt)
                DispatchQueue.main.async {
                    chatResponses.append("You: \(userInput)")
                    chatResponses.append("\(selectedFigure): \(response)")
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
