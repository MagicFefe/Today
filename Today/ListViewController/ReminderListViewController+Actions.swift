//
//  ReminderListViewController+Actions.swift
//  Today
//
//  Created by Данил Шипицын on 21.10.2023.
//

import Foundation
import UIKit

extension ReminderListViewController {
    
    @objc func didPressDoneButton(_ sender: ReminderDoneButton) {
        guard let id = sender.id else { return }
        completeReminder(withId: id)
    }
    
    @objc func didPressAddButton(_ sender: UIBarButtonItem) {
        let reminder = Reminder(title: "", dueDate: Date.now)
        let reminderViewController = ReminderViewController(reminder: reminder) { [weak self] reminder in
            self?.addReminder(reminder)
            self?.updateSnapshot()
            self?.dismiss(animated: true)
        }
        reminderViewController.isCreatingReminer = true
        reminderViewController.setEditing(true, animated: false)
        reminderViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel, target: self, action: #selector(didCancelAdd(_:)))
        reminderViewController.navigationItem.title = NSLocalizedString("Add Reminder", comment: "Add Reminder view controller title")
        let navigationController = UINavigationController(rootViewController: reminderViewController)
        present(navigationController, animated: true)
    }
    
    @objc func didCancelAdd(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc func didChangeListStyle(_ sender: UISegmentedControl) {
        listStyle = ReminderListStyle(rawValue: sender.selectedSegmentIndex) ?? .today
        refreshBackground()
        updateSnapshot()
    }
    
    @objc func eventStoreChanged(_ notification: NSNotification) {
        reminderStoreChanged()
    }
}
