//
//  ApiService.swift
//  ios-project
//
//  Created by student6 on 2026-07-02.
//

import Foundation

struct TriviaApiService {
   func fetchQuestions() async throws -> [Question] {
       let url = URL(string: "https://opentdb.com/api.php?amount=10&type=multiple")!
       let (data, _) = try await URLSession.shared.data(from: url)
       let result = try JSONDecoder().decode(QuizResponse.self, from: data)
       return result.results
   }
}
