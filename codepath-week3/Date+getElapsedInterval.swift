//
//  Date+getElapsedInterval.swift
//  codepath-week3
//
//  Created by Phuong Nguyen on 9/29/17.
//  Copyright © 2017 Roostertech. All rights reserved.
//

import Foundation

extension Date {
    
    func getElapsedInterval() -> String {
        
        let interval = Calendar.current.dateComponents([.year, .month, .day], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year) year" :
                "\(year) years"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month) month" :
                "\(month) months"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day) day" :
                "\(day) days"
        } else if let hour = interval.hour, hour > 0 {
            return "\(hour)h"
        } else if let minute = interval.minute, minute > 0 {
            return "\(minute)m"
        } else {
            return "a moment ago"
        }
        
    }
}
