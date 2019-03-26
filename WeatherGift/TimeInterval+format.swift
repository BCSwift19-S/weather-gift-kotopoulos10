//
//  TimeInterval+format.swift
//  WeatherGift
//
//  Created by Tom Kotopoulos on 3/25/19.
//  Copyright © 2019 Tom Kotopoulos. All rights reserved.
//

import Foundation

extension TimeInterval{
    
    func format (timeZone:String, dateFormatter: DateFormatter) -> String{
        let usableDate = Date(timeIntervalSince1970: self)
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        return dateFormatter.string(from: usableDate)
    }
}
