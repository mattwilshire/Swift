//
//  NotificationManager.swift
//  SwiftExample
//
//  Created by Matthew Wilshire on 03/04/2022.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    static func start() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
                case .notDetermined:
                    self.requestAuthorization()
                case .authorized, .provisional:
                    self.addNotification()
                default:
                    break
            }
        }
    }
    
    static func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted == true && error == nil {
                self.addNotification()
            }
        }
    }
    
    static func addNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.sound = .default
        content.body = "Have you filled in your diary for today ?"

        // Every day at this time.
        var triggerDate = DateComponents()
        triggerDate.hour = 01
        triggerDate.minute = 07
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)


        let request = UNNotificationRequest(identifier: "DiaryNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            print("Added notification!")
            
            guard error == nil else { return }
        }
        
    }
    
    static func list() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            for notification in notifications {
                print(notification)
            }
        }
    }
}
