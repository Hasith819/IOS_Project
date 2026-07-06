//
//  SettingsTab.swift
//  ios-project
//
//  Created by student6 on 2026-07-06.
//
import SwiftUI

struct SettingsTabView: View {
    
    @AppStorage("dailyChallengeEnabled") private var notificationsEnabled = false
    @AppStorage("dailyChallengeTime") private var challengeTimeInterval: Double = Date().timeIntervalSince1970
    
    @State private var showResetConfirmation = false
    @State private var showResetSuccess = false
    @State private var showPermissionDeniedAlert = false
    
    private let gameSessionStore = GameSessionStore.shared
    
    private var challengeTimeBinding: Binding<Date> {
        Binding(
            get: { Date(timeIntervalSince1970: challengeTimeInterval) },
            set: { challengeTimeInterval = $0.timeIntervalSince1970 }
        )
    }
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section {
                    Toggle(isOn: $notificationsEnabled.animation()) {
                        Label {
                            Text("Daily Challenge")
                        } icon: {
                            Image(systemName: "bell.badge.fill")
                                .foregroundStyle(.orange)
                        }
                    }
                    
                    if notificationsEnabled {
                        DatePicker(
                            "Reminder Time",
                            selection: challengeTimeBinding,
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(.compact)
                    }
                } header: {
                    Text("Notifications")
                } footer: {
                    Text(notificationsEnabled
                         ? "You'll get a reminder every day at the selected time to play your daily challenge."
                         : "Turn this on to get a daily reminder to come back and play.")
                }
                
                Section {
                    Button(role: .destructive) {
                        showResetConfirmation = true
                    } label: {
                        Label {
                            Text("Reset All Stats")
                                .foregroundStyle(.red)
                        } icon: {
                            Image(systemName: "trash.fill")
                                .foregroundStyle(.red)
                        }
                    }
                } header: {
                    Text("Data")
                } footer: {
                    Text("This permanently deletes your scores, high scores, and session history across all games.")
                }
                

                Section {
                    HStack {
                        Label("Version", systemImage: "info.circle")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("About")
                }
            }
            .navigationTitle("Settings")
            .confirmationDialog(
                "Reset all stats?",
                isPresented: $showResetConfirmation,
                titleVisibility: .visible
            ) {
                Button("Reset Everything", role: .destructive) {
                    gameSessionStore.resetAllStats()
                    showResetSuccess = true
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This action cannot be undone. All scores and game history will be permanently deleted.")
            }
            .alert("Stats Reset", isPresented: $showResetSuccess) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("All your stats have been cleared.")
            }
            .alert("Notifications Disabled", isPresented: $showPermissionDeniedAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Enable notifications for this app in iOS Settings to get your daily challenge reminder.")
            }
            .onChange(of: notificationsEnabled) { _, isEnabled in
                if isEnabled {
                    requestPermissionAndSchedule()
                } else {
                    NotificationService.shared.cancelDailyChallenge()
                }
            }
            .onChange(of: challengeTimeInterval) { _, _ in
                if notificationsEnabled {
                    NotificationService.shared.scheduleDailyChallenge(at: challengeTimeBinding.wrappedValue)
                }
            }
            .onAppear {
                if notificationsEnabled {
                    NotificationService.shared.scheduleDailyChallenge(at: challengeTimeBinding.wrappedValue)
                }
            }
        }
    }
    
    private func requestPermissionAndSchedule() {
        NotificationService.shared.requestAuthorization { granted in
            if granted {
                NotificationService.shared.scheduleDailyChallenge(at: challengeTimeBinding.wrappedValue)
            } else {
                notificationsEnabled = false
                showPermissionDeniedAlert = true
            }
        }
    }
}

#Preview {
    SettingsTabView()
}
