//
//  BookInformation.swift
//  MusicAlarm
//
//  Created by 최아람 on 2023/02/16.
//

import Foundation

struct BookInformation: Codable {
    let items: [Item]
}

struct Item: Codable {
    let title: String
    let link: String
    let image: String
    let author: String
    let discount: String
    let publisher: String
    let description: String
}

