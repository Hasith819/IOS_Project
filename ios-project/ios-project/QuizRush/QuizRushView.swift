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

    private let service = ApiService()

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

        if selected == answer {
            return vm.isCorrect ? .green : .red
        }

        return .blue
    }

    var body: some View {

        ZStack {

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
                            .foregroundColor(.orange)
                    }
                    .padding(.horizontal)

                    Spacer().frame(height: 35)

                    Text(vm.currentQuestion.question)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding()

                    ForEach(vm.shuffledAnswers, id: \.self) { answer in

                        Button {

                            vm.answerTapped(answer)

                        } label: {

                            Text(answer)
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
                }
                .padding()

            case .finished:

                VStack(spacing: 25) {

                    Text("🎉 Game Over")
                        .font(.largeTitle)

                    Text("Final Score")
                        .font(.title2)

                    Text("\(vm.score)")
                        .font(.system(size: 55))
                        .bold()

                    Text("Best Streak: \(vm.streak)")

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
