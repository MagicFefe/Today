//
//  ReminderListStyle.swift
//  Today
//
//  Created by Данил Шипицын on 23.10.2023.
//

import Foundation

enum ReminderListStyle: Int {
    case today
    case future
    case all
    
    var name: String {
        switch self {
        case .today:
            NSLocalizedString("Today", comment: "Today style name")
        case .future:
            NSLocalizedString("Future", comment: "Future style name")
        case .all:
            NSLocalizedString("All", comment: "All style name")
        }
    }
    
    func shouldInclude(date: Date) -> Bool {
        let isInToday = Locale.current.calendar.isDateInToday(date)
        switch self {
        case .today:
            return isInToday
        case .future:
            return (date > Date.now) && !isInToday
        case .all:
            return true
        }
    }
}
