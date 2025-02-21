//
//  LocalNotificationManager.swift
//  CaptureVue
//
//  Created by Paris Makris on 11/2/25.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    static func requestPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Permission approved!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    static func scheduleNotification(title: String, subtitle: String, sound: UNNotificationSound = .default, timeInterval: TimeInterval = 5) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = sound
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            }
        }
    }
}
