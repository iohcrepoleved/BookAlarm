//
//  Alarm.swift
//  MusicAlarm
//
//  Created by 최아람 on 2023/02/15.
//

import UIKit

struct Alarm : Codable {
    var id : String = UUID().uuidString
    var date : Date
    var isOn : Bool
    var keyword : String
    var orderCondition : String
    var searchCondition : String
    
    var time : String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm"
        
        return timeFormatter.string(from: date)
    }
    
    var ampm : String {
        let ampmFormatter = DateFormatter()
        ampmFormatter.dateFormat = "a"
        ampmFormatter.locale = Locale(identifier: "ko")
        
        return ampmFormatter.string(from: date)
    }
}
