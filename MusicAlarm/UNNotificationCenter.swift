//
//  UNNotificationCenter.swift
//  MusicAlarm
//
//  Created by 최아람 on 2023/02/15.
//

import Foundation
import UserNotifications

extension UNUserNotificationCenter {
    func addNotificationRequest(by alarm:Alarm) {
        let content = UNMutableNotificationContent()
        content.title = "음악 추천 시간 🎧"
        content.body = "음악을 추천해드립니다"
        content.sound = .default
        content.badge = 1
        
        let component = Calendar.current.dateComponents([.hour, .minute], from: alarm.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: alarm.isOn)
        let request = UNNotificationRequest(identifier: alarm.id, content: content, trigger: trigger)
        
        self.add(request)
    }
}
