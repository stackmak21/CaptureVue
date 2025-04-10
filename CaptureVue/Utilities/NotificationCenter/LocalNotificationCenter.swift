//
//  LocalNotificationCenter.swift
//  CaptureVue
//
//  Created by Paris Makris on 7/4/25.
//

import Foundation
import UserNotifications


class LocalNotificationCenter{
    
    static let instance: LocalNotificationCenter = LocalNotificationCenter()
    
    
    private init(){}
    
    
    func createNotificationContent(){
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()

        content.title = "Notification Title"
        content.body = "Notification Body"
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: "Identifier", content: content, trigger: trigger)
        
        center.add(request)
    }
    
}



