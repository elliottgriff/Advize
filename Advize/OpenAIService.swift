//
//  OpenAIService.swift
//  Advize
//
//  Created by Elliott Griffin on 1/7/25.
//


import Foundation

class OpenAIService {

    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String

    func generateResponse(prompt: String, model: String = "text-davinci-003", maxTokens: Int = 150) async throws -> String {
        let endpoint = "https://api.openai.com/v1/completions"
        let headers = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
        
        let requestBody: [String: Any] = [
            "model": model,
            "prompt": prompt,
            "max_tokens": maxTokens,
            "temperature": 0.7
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            throw URLError(.badServerResponse)
        }
        
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        if let json = try? JSONSerialization.jsonObject(with: data, options: []),
           let dictionary = json as? [String: Any],
           let choices = dictionary["choices"] as? [[String: Any]],
           let text = choices.first?["text"] as? String {
            return text.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            throw URLError(.cannotParseResponse)
        }
    }
}
