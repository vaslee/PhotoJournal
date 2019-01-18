//
//  PhotoJournal.swift
//  PhotoJournal
//
//  Created by TingxinLi on 1/14/19.
//  Copyright © 2019 TingxinLi. All rights reserved.
//

import Foundation

struct PhotoJournal: Codable {
    let createdAt: String
    let imageData: Data
    let description: String
    
    public var dateFormattedString: String {
        
        let isoDateFormatter = ISO8601DateFormatter()
        var formattedDate = createdAt
        if let date = isoDateFormatter.date(from: createdAt) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy hh:mm a" 
            formattedDate = dateFormatter.string(from: date)
        }
        return formattedDate
        
    }
    public var date: Date {
        let isoDateFormatter = ISO8601DateFormatter()
        var formattedDate = Date()
        if let date = isoDateFormatter.date(from: createdAt) {
            formattedDate = date
        }
        return formattedDate
    }
}
