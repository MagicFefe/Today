//
//  Date+Today.swift
//  Today
//
//  Created by Данил Шипицын on 20.10.2023.
//

import Foundation

extension Date {
    var dateAndTimeText: String {
        let timeText = formatted(date: .omitted, time: .shortened)
        if Locale.current.calendar.isDateInToday(self) {
            let timeFormat = NSLocalizedString("Today at %@", comment: "Today at time format string")
            return String(format: timeFormat, timeText)
        } else {
            let dateText = formatted(.dateTime.month(.abbreviated).day())
            let dateTimeFormat = NSLocalizedString("%@ at %@", comment: "Date and time format string")
            return String(format: dateTimeFormat, dateText, timeText)
        }
    }
    
    var dayText: String {
        if Locale.current.calendar.isDateInToday(self) {
            return NSLocalizedString("Today", comment: "Today due date description" )
        } else {
            return formatted(.dateTime.day().month().weekday(.wide))
        }
    }
}
