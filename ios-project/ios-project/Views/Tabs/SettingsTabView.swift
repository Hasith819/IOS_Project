//
//  SettingsTab.swift
//  ios-project
//
//  Created by student6 on 2026-07-06.
//
import SwiftUI

struct SettingsTabView: View {
    
    @StateObject private var viewModel = SettingsVM()
    
    @AppStorage("dailyChallengeEnabled") private var notificationsEnabled = false
    
    @AppStorage("dailyChallengeTime")
    private var challengeTimeInterval: Double = Date().timeIntervalSince1970
    
    private var challengeTimeBinding: Binding<Date> {
        Binding(
            get: {
                Date(timeIntervalSince1970: challengeTimeInterval)
            },
            set: {
                challengeTimeInterval = $0.timeIntervalSince1970
            }
        )
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
              
                MenuBackground()
                    .ignoresSafeArea()
                
                Form {
                    Section {
                        Toggle(isOn: $notificationsEnabled.animation()) {
                            Label {
                                Text("Daily Challenge")
                                    .foregroundColor(.white)
                            } icon: {
                                Image(systemName: "bell.badge.fill")
                                    .foregroundStyle(.orange)
                            }
                        }
                        .listRowBackground(Color.white.opacity(0.08))
                        
                        if notificationsEnabled {
                            DatePicker(
                                "Reminder Time",
                                selection: challengeTimeBinding,
                                displayedComponents: .hourAndMinute
                            )
                            .datePickerStyle(.compact)
                            .listRowBackground(Color.white.opacity(0.08))
                            .colorScheme(.dark)
                        }
                        
                    } header: {
                        Text("Notifications")
                            .foregroundColor(.white.opacity(0.6))
                    } footer: {
                        Text(
                            notificationsEnabled
                            ? "You'll get a reminder every day at the selected time to play your daily challenge."
                            : "Turn this on to get a daily reminder to come back and play."
                        )
                        .foregroundColor(.white.opacity(0.5))
                    }
                    
                    Section {
                        Button(role: .destructive) {
                            viewModel.showResetConfirmation = true
                        } label: {
                            Label {
                                Text("Reset All Stats")
                                    .foregroundStyle(.red)
                            } icon: {
                                Image(systemName: "trash.fill")
                                    .foregroundStyle(.red)
                            }
                        }
                        .listRowBackground(Color.white.opacity(0.08))
                        
                    } header: {
                        Text("Data")
                            .foregroundColor(.white.opacity(0.6))
                    } footer: {
                        Text("This permanently deletes your scores, high scores, and session history across all games.")
                            .foregroundColor(.white.opacity(0.5))
                    }
                    
                    Section {
                        HStack {
                            Label("Version", systemImage: "info.circle")
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("1.0.0")
                                .foregroundStyle(.white.opacity(0.6))
                        }
                        .listRowBackground(Color.white.opacity(0.08))
                        
                    } header: {
                        Text("About")
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
            
            .preferredColorScheme(.dark)
            
            .confirmationDialog(
                "Reset all stats?",
                isPresented: $viewModel.showResetConfirmation,
                titleVisibility: .visible
            ) {
                Button("Reset Everything", role: .destructive) {
                    viewModel.resetStats()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This action cannot be undone. All scores and game history will be permanently deleted.")
            }
            
            .alert("Stats Reset", isPresented: $viewModel.showResetSuccess) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("All your stats have been cleared.")
            }
            
            .alert("Notifications Disabled", isPresented: $viewModel.showPermissionDeniedAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Enable notifications for this app in iOS Settings to get your daily challenge reminder.")
            }
            
            .onChange(of: notificationsEnabled) { _, isEnabled in
                if isEnabled {
                    viewModel.requestPermissionAndSchedule(
                        notificationsEnabled: $notificationsEnabled,
                        challengeTime: challengeTimeBinding.wrappedValue
                    )
                } else {
                    viewModel.cancelNotification()
                }
            }
            
            .onChange(of: challengeTimeInterval) { _, _ in
                if notificationsEnabled {
                    viewModel.scheduleNotification(
                        enabled: true,
                        time: challengeTimeBinding.wrappedValue
                    )
                }
            }
            
            .onAppear {
                if notificationsEnabled {
                    viewModel.scheduleNotification(
                        enabled: true,
                        time: challengeTimeBinding.wrappedValue
                    )
                }
            }
        }
    }
}

#Preview {
    SettingsTabView()
}
