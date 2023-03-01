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
        var bookLink : String = ""
        let sort = alarm.orderCondition == "정확도순" ? "sim" : "date"
        let condition : String = searchCondition(alarm: alarm)
        let urlStr = "https://openapi.naver.com/v1/search/book.json?query=\(alarm.keyword)&sort=\(sort)&display=100"
        
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
                var counter = 0
                var hasBook = false
                var num = Int.random(in: 0..<bookInformation.items.count)
                switch condition {
                case "title":
                    if bookInformation.items.count != 0 {
                        while !bookInformation.items[num].title.contains(alarm.keyword) && counter < bookInformation.items.count{
                            num = Int.random(in: 0..<bookInformation.items.count)
                            counter += 1
                        }
                        if counter != bookInformation.items.count {
                            hasBook = true
                        }
                    }
                case "publisher":
                    if bookInformation.items.count != 0 {
                        while !bookInformation.items[num].publisher.contains(alarm.keyword) && counter < bookInformation.items.count{
                            num = Int.random(in: 0..<bookInformation.items.count)
                            counter += 1
                        }
                        if counter != bookInformation.items.count {
                            hasBook = true
                        }
                    }
                case "author":
                    if bookInformation.items.count != 0 {
                        while !bookInformation.items[num].author.contains(alarm.keyword) && counter < bookInformation.items.count{
                            num = Int.random(in: 0..<bookInformation.items.count)
                            counter += 1
                        }
                        if counter != bookInformation.items.count {
                            hasBook = true
                        }
                    }
                case "description":
                    if bookInformation.items.count != 0 {
                        while !bookInformation.items[num].description.contains(alarm.keyword) && counter < bookInformation.items.count{
                            num = Int.random(in: 0..<bookInformation.items.count)
                            counter += 1
                        }
                        if counter != bookInformation.items.count {
                            hasBook = true
                        }
                    }
                default:
                    break
                }
                
                
                if hasBook == true {
                    bookTitle = bookInformation.items[num].title
                    bookLink = bookInformation.items[num].link
                    content.title = "[\(alarm.keyword)] 책 추천 시간 📖"
                    content.body = "추천 도서명 : \(bookTitle)"
                    content.sound = .default
                    content.badge = 1
                    content.userInfo = ["link" :bookLink]
                }else{
                    content.title = "[\(alarm.keyword)] 키워드를 재설정해주세요 📖"
                    content.body = "해당 키워드의 책을 검색할 수 없습니다"
                    content.sound = .default
                    content.badge = 0
                }
                
                let component = Calendar.current.dateComponents([.hour, .minute], from: alarm.date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: alarm.isOn)
                let request = UNNotificationRequest(identifier: alarm.id, content: content, trigger: trigger)
                
                self!.add(request)
            }
        }.resume()
        
        
    }
    
    private func searchCondition (alarm: Alarm) -> String {
        switch alarm.searchCondition {
        case "책 제목":
            return "title"
        case "출판사":
            return "publisher"
        case "저자명":
            return "author"
        case "책 소개":
            return "description"
        default:
            return "title"
        }
    }
}
