//
//  ApiService.swift
//  ios-project
//
//  Created by student6 on 2026-07-02.
//

import Foundation

struct QuizResponse: Codable {
    let results: [Question]
}

struct Question: Codable, Identifiable {
    let id = UUID()
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]

    enum CodingKeys: String, CodingKey {
        case question
        case correct_answer
        case incorrect_answers
    }
}

struct ApiService {
    func fetchQuestions() async throws -> [Question] {
        let url = URL(string: "https://opentdb.com/api.php?amount=10&type=multiple")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let result = try JSONDecoder().decode(QuizResponse.self, from: data)
        return result.results
    }
}

extension String {
    var htmlDecoded: String {
        self
            .replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&#039", with: "'")
    }
    
}
