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
        var bookTitle : String = ""
        let urlStr = "https://openapi.naver.com/v1/search/book.json?query=\(alarm.keyword)&sort=sim"
        
        guard let encodedStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = URL(string: encodedStr)!
        var urlRequest = URLRequest(url: url)
        
        urlRequest.allHTTPHeaderFields = [
            "X-Naver-Client-Id" : "G3hyX6_LFymqGJkp2MV2",
            "X-Naver-Client-Secret" : "aixVtDNSps"
        ]
        let session = URLSession(configuration: .default)
        session.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let data = data, error == nil else {return}
            let decoder = JSONDecoder()
            guard let bookInformation = try? decoder.decode(BookInformation.self, from: data) else {return}
            DispatchQueue.main.async {
                if let book = bookInformation.items.first {
                    bookTitle = String(book.title)
                }
                content.title = "책 추천 시간 📖"
                content.body = "\(bookTitle)을 추천해드립니다"
                content.sound = .default
                content.badge = 1
                
                let component = Calendar.current.dateComponents([.hour, .minute], from: alarm.date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: alarm.isOn)
                let request = UNNotificationRequest(identifier: alarm.id, content: content, trigger: trigger)
                
                self!.add(request)
            }
        }.resume()
        
        
    }

}
