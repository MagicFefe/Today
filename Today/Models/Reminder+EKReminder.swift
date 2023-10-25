//
//  Reminder+EKReminder.swift
//  Today
//
//  Created by Данил Шипицын on 25.10.2023.
//

import Foundation
import EventKit

extension Reminder {
    init(with ekReminder: EKReminder) throws {
        guard let dueDate = ekReminder.alarms?.first?.absoluteDate else {
            throw TodayError.reminderHasNoDueDate
        }
        self.id = ekReminder.calendarItemIdentifier
        self.title = ekReminder.title
        self.dueDate = dueDate
        self.notes = ekReminder.notes
        self.isComplete = ekReminder.isCompleted
    }
}
