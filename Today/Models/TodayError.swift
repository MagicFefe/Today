//
//  TodayError.swift
//  Today
//
//  Created by Данил Шипицын on 25.10.2023.
//

import Foundation

enum TodayError: LocalizedError {
    case accessDenied
    case accessRestricted
    case failedReadCalendarItem
    case failedReadingReminders
    case reminderHasNoDueDate
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .accessDenied:
            NSLocalizedString(
                "The app doesn't have permission to read reminders.", comment: "access denied error description")
        case .accessRestricted:
            NSLocalizedString("This device doesn't allow access to reminders.", comment: "access restricted error description")
        case .failedReadCalendarItem:
            NSLocalizedString(
                "Failed to read a calendar item.", comment: "failed reading calendar item error description")
        case .failedReadingReminders:
            NSLocalizedString(
                "Failed to read reminders.", comment: "failed reading reminders error description")
        case .reminderHasNoDueDate:
            NSLocalizedString(
                "A reminder has no due date.", comment: "reminder has no due date error description")
        case .unknown:
            NSLocalizedString("An unknown error occurred.", comment: "unknown error description")
        }
    }
}
