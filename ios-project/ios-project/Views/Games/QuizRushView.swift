//
//  QuizRushView.swift
//  ios-project
//
//  Created by student6 on 2026-06-27.
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
class QuizRushViewModel: ObservableObject {

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

    // MARK: - Load Quiz
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

    // MARK: - Current Question
    var currentQuestion: Question {
        questions[currentIndex]
    }

    // MARK: - Shuffle ONCE per question
    func prepareAnswers() {
        shuffledAnswers =
            ([currentQuestion.correct_answer] +
             currentQuestion.incorrect_answers)
            .shuffled()
    }

    // MARK: - Answer Logic
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

                    // SAVE HIGH SCORE
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

struct QuizRushView: View {

    @StateObject private var vm = QuizRushViewModel()

    // MARK: - Button Color
    func buttonColor(for answer: String) -> Color {

        guard let selected = vm.selectedAnswer else {
            return .blue
        }
        
        let correct = vm.currentQuestion.correct_answer

        if answer == correct {
            return .green
        }
        
        if answer == selected {
            return .red
        }

        return .blue
    }

    var body: some View {

        ZStack {
            
            AnimatedBackground()

            switch vm.state {

            case .loading:

                VStack {
                    ProgressView()
                    Text("Loading Questions...")
                        .padding()
                }

            case .failed:

                VStack(spacing: 20) {

                    Text("Failed to load questions.")

                    Button("Retry") {
                        Task {
                            await vm.loadQuiz()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }

            case .loaded:

                VStack {

                    Text("Quiz Rush")
                        .font(.largeTitle)
                        .bold()

                    Spacer().frame(height: 25)

                    HStack {

                        Text("Score: \(vm.score)")
                            .font(.title3)
                            .fontWeight(.bold)

                        Spacer()

                        Text("Streak: \(vm.streak)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 1.0, green: 0.84, blue: 0.0))
                    }
                    .padding(.horizontal)

                    Spacer().frame(height: 35)

                    Text(vm.currentQuestion.question.htmlDecoded)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Spacer().frame(height: 40)

                    ForEach(vm.shuffledAnswers, id: \.self) { answer in

                        Button {

                            vm.answerTapped(answer)

                        } label: {

                            Text(answer.htmlDecoded)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(buttonColor(for: answer))
                                .cornerRadius(12)
                        }
                        .disabled(vm.selectedAnswer != nil)
                    }

                    Spacer()

                    Text("Question \(vm.currentIndex + 1) of 10")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                }
                .padding()

            case .finished:

                VStack(spacing: 25) {

                    Text("Well Done!")
                        .font(.largeTitle)

                    Text("Final Score")
                        .font(.title2)

                    Text("\(vm.score)")
                        .font(.system(size: 55))
                        .bold()

                    Text("Best Streak: \(vm.streak)")
                    
                    Text("High Score: \(vm.bestScore)")
                        .font(.title3)
                        .foregroundColor(.yellow)

                    if vm.score == vm.bestScore && vm.score > 0 {
                        Text("New High Score!")
                            .font(.headline)
                            .foregroundColor(.orange)
                    }

                    Button("Play Again") {
                        Task {
                            await vm.loadQuiz()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .task {
            await vm.loadQuiz()
        }
    }
}

#Preview {
    QuizRushView()
}
