//
//  OpenAIService.swift
//  Advize
//
//  Created by Elliott Griffin on 1/7/25.
//

import Foundation

class OpenAIService {
    let apiKey = ProcessInfo.processInfo.environment["OPENAPI_KEY"]
    
    func generateResponse(
        prompt: String,
        figure: String,
        model: String = "gpt-4o",
        maxTokens: Int = 400
    ) async throws -> String {
        guard let apiKey = apiKey, !apiKey.isEmpty else {
            print("Error: Missing API Key")
            throw NSError(domain: "OpenAI", code: 1, userInfo: [NSLocalizedDescriptionKey: "API Key is missing or invalid"])
        }
        print("API Key: \(apiKey)")

        let endpoint = "https://api.openai.com/v1/chat/completions"
        
        let systemMessage = """
        You are \(figure), a trusted and personable advisor. You speak informally, with warmth and empathy, as if you’re having a heartfelt conversation with a close confidant. Your advice is practical, supportive, and conversational. Engage the user in a way that feels natural and relatable.
        """
        
        let requestBody: [String: Any] = [
            "model": model,
            "messages": [
                ["role": "system", "content": systemMessage],
                ["role": "user", "content": prompt]
            ],
            "max_tokens": maxTokens,
            "temperature": 0.9, 
            "top_p": 1.0,
            "frequency_penalty": 0.0,
            "presence_penalty": 0.6
        ]
        
        print("Request Body: \(requestBody)")
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            print("Error: Failed to encode request body")
            throw URLError(.badServerResponse)
        }
        
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    print("Error: HTTP Status Code is not 200")
                }
            }
            
            if let rawResponse = String(data: data, encoding: .utf8) {
                print("Raw Response: \(rawResponse)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []),
               let dictionary = json as? [String: Any] {
                print("Parsed JSON: \(dictionary)")
                
                if let error = dictionary["error"] as? [String: Any],
                   let message = error["message"] as? String {
                    print("Error from OpenAI: \(message)")
                    throw NSError(domain: "OpenAI", code: 1, userInfo: [NSLocalizedDescriptionKey: message])
                }
                
                if let choices = dictionary["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    return content.trimmingCharacters(in: .whitespacesAndNewlines)
                } else {
                    throw URLError(.cannotParseResponse)
                }
            } else {
                throw URLError(.cannotParseResponse)
            }
        } catch {
            print("Error: \(error.localizedDescription)")
            throw error
        }
    }
}

