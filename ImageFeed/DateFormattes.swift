//
//  DateFormates.swift
//  ImageFeed
//
//  Created by mihail on 23.12.2023.
//

import Foundation

struct DateFormattes {
    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        
        return dateFormatter
    }()
    
    static var outputDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        return dateFormatter
    }()
}
