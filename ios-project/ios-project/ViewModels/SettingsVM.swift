//
//  SettingsVM.swift
//  ios-project
//
//  Created by student6 on 2026-07-12.
//

import SwiftUI
import Combine

final class SettingsVM: ObservableObject {
    
    @Published var showResetConfirmation = false
    @Published var showResetSuccess = false
    @Published var showPermissionDeniedAlert = false
    
    
    private let gameSessionStore = GameSessionStore.shared
    
    
    func resetStats() {
        gameSessionStore.resetAllStats()
        showResetSuccess = true
    }
    
    
    func requestPermissionAndSchedule(
        notificationsEnabled: Binding<Bool>,
        challengeTime: Date
    ) {
        
        NotificationService.shared.requestAuthorization { granted in
            
            DispatchQueue.main.async {
                
                if granted {
                    
                    NotificationService.shared.scheduleDailyChallenge(
                        at: challengeTime
                    )
                    
                } else {
                    
                    notificationsEnabled.wrappedValue = false
                    self.showPermissionDeniedAlert = true
                }
            }
        }
    }
    
    
    func scheduleNotification(
        enabled: Bool,
        time: Date
    ) {
        
        if enabled {
            NotificationService.shared.scheduleDailyChallenge(at: time)
        }
    }
    
    
    func cancelNotification() {
        NotificationService.shared.cancelDailyChallenge()
    }
}
