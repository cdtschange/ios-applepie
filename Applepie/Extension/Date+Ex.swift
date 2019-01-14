//
//  Date+Ex.swift
//  Applepie
//
//  Created by 山天大畜 on 2019/1/14.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import Foundation

public extension Date {
    
    public init?(fromString string: String,
                 format: String,
                 timezone: TimeZone = TimeZone.autoupdatingCurrent,
                 locale: Locale = Locale.current) {
        
        let formatter = DateFormatter()
        formatter.timeZone = timezone
        formatter.locale = locale
        formatter.dateFormat = format
        if let date = formatter.date(from: string) {
            self = date
        } else {
            return nil
        }
    }
}
