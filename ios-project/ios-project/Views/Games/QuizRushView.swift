//
//  QuizRushView.swift
//  ios-project
//
//  Created by student6 on 2026-06-27.
//
//
import SwiftUI

struct QuizRushView: View {

    @StateObject private var vm = QuizRushVM()

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
            
            GameBackground()

            switch vm.state {

            case .loading:

                VStack {
                    ProgressView()
                    Text("Loading Questions...")
                        .padding()
                        .foregroundColor(.white)
                }

            case .failed:

                VStack(spacing: 20) {

                    Text("Failed to load questions.")
                        .foregroundColor(.white)

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
                        .foregroundColor(.white)

                    Spacer().frame(height: 25)

                    HStack {

                        Text("Score: \(vm.score)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
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
                        .foregroundColor(.white)
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
                        .foregroundColor(.white)
                }
                .padding()

            case .finished:
                GameOverView(title: "Well Done!", gameName: "Quiz Rush", score: vm.score, highScore: vm.bestScore) {
                    Task {
                        await vm.loadQuiz()
                    }
                }
            }
        }
        .task {
            await vm.loadQuiz()
        }
        
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    QuizRushView()
}
