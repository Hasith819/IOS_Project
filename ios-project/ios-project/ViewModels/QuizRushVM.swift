//
//  QuizRushVM.swift
//  ios-project
//
//  Created by student6 on 2026-07-06.
//

import SwiftUI
import Combine

enum QuizState {
    case loading
    case loaded
    case failed
    case finished
}


@MainActor
class QuizRushVM: ObservableObject {
    
    private let sessionStore = GameSessionStore.shared

    @Published var questions: [Question] = []
    @Published var currentIndex = 0

    @Published var score = 0
    @Published var streak = 0

    @Published var state: QuizState = .loading

    @Published var selectedAnswer: String? = nil
    @Published var isCorrect = false

    @Published var shuffledAnswers: [String] = []
    
    @AppStorage("QuizRushHighScore")
     private var highScore: Int = 0

     @Published var bestScore: Int = 0
    
    private let service = TriviaApiService()

   
    func loadQuiz() async {

        state = .loading

        do {
            questions = try await service.fetchQuestions()

            currentIndex = 0
            score = 0
            streak = 0
            selectedAnswer = nil
            isCorrect = false
            bestScore = highScore
            prepareAnswers()

            state = .loaded

        } catch {
            state = .failed
        }
    }


    var currentQuestion: Question {
        questions[currentIndex]
    }

 
    func prepareAnswers() {
        shuffledAnswers =
            ([currentQuestion.correct_answer] +
             currentQuestion.incorrect_answers)
            .shuffled()
    }

 
    func answerTapped(_ answer: String) {

        selectedAnswer = answer

        if answer == currentQuestion.correct_answer {
            isCorrect = true
            streak += 1
            score += 10 + (streak * 2)
        } else {
            isCorrect = false
            streak = 0
            score = max(score - 5, 0)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {

            self.selectedAnswer = nil

                if self.currentIndex == self.questions.count - 1 {

                    self.state = .finished
                    self.sessionStore.appendSession(
                        mode: .quizRush,
                        score: self.score,
                        location: LocationService.shared.currentLocation
                    )
                  
                    if self.score > self.highScore {
                        self.highScore = self.score
                    }

                    self.bestScore = self.highScore

                } else {
                    self.currentIndex += 1
                    self.prepareAnswers()
                }
        }
    }
}
