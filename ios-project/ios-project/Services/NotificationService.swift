//
//  NotificationService.swift
//  ios-project
//
//  Created by student6 on 2026-07-06.
//
import Foundation
import UserNotifications

final class NotificationService {
    
    static let shared = NotificationService()
    
    private let center = UNUserNotificationCenter.current()
    private let dailyChallengeIdentifier = "dailyChallengeReminder"
    
    private init() {}
    
  
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    func getAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }

    func scheduleDailyChallenge(at time: Date) {

        center.removePendingNotificationRequests(withIdentifiers: [dailyChallengeIdentifier])
        
        let content = UNMutableNotificationContent()
        content.title = "Play Hub Daily Challenge"
        content.body = "Your daily challenge is ready. Come back and beat your high score!"
        content.sound = .default
        
        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
        dateComponents.second = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: dailyChallengeIdentifier,
            content: content,
            trigger: trigger
        )
        
        center.add(request)
    }

    func cancelDailyChallenge() {
        center.removePendingNotificationRequests(withIdentifiers: [dailyChallengeIdentifier])
    }
}
