//
//  ReminderListViewController+DataSource.swift
//  Today
//
//  Created by Данил Шипицын on 20.10.2023.
//

import UIKit

extension ReminderListViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Reminder.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Reminder.ID>
    
    var reminderCompletedValue: String {
        NSLocalizedString("Completed", comment: "Reminder completed value")
    }
    
    var reminderNotCompletedValue: String {
        NSLocalizedString("Not completed", comment: "Reminder not completed value")
    }
    
    private var reminderStore: ReminderStore { ReminderStore.shared }
    
    func updateSnapshot(reloading idsThatChanged: [Reminder.ID] = []) {
        let ids = idsThatChanged.filter { id in filteredReminders.contains(where: { $0.id == id }) }
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(filteredReminders.map {
            $0.id
        })
        if !ids.isEmpty {
            snapshot.reloadItems(ids)
        }
        dataSource.apply(snapshot)
        headerView?.progress = progress
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: Reminder.ID) {
        let reminder = reminder(withId: id)
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = reminder.title
        contentConfiguration.secondaryText = reminder.dueDate.dateAndTimeText
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption1)
        cell.contentConfiguration = contentConfiguration
        
        var doneButtonConfiguration = doneButtonConfigutration(for: reminder)
        doneButtonConfiguration.tintColor = .todayListCellDoneButtonTint
        
        cell.accessibilityValue = reminder.isComplete ? reminderCompletedValue : reminderNotCompletedValue
        cell.accessibilityCustomActions = [doneButtonAcessibilityAction(for: reminder)]
        cell.accessories = [
            .customView(configuration: doneButtonConfiguration)
        ]
        
        var backgroundCongiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundCongiguration.backgroundColor = .todayListCellBackground
        cell.backgroundConfiguration = backgroundCongiguration
    }
    
    private func doneButtonConfigutration(for reminder: Reminder) -> UICellAccessory.CustomViewConfiguration {
        let symbolName = reminder.isComplete ? "circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        let button = ReminderDoneButton()
        button.id = reminder.id
        button.addTarget(self, action: #selector(didPressDoneButton(_:)), for: .touchUpInside)
        button.setImage(image, for: .normal)
        return UICellAccessory.CustomViewConfiguration(customView: button, placement: .leading(displayed: .always))
    }
    
    private func doneButtonAcessibilityAction(for reminder: Reminder) -> UIAccessibilityCustomAction {
        let name = NSLocalizedString("Toggle Completion", comment: "Reminder done button accessibility label")
        let action = UIAccessibilityCustomAction(name: name) { [weak self] action in
            self?.completeReminder(withId: reminder.id)
            return true
        }
        return action
    }
    
    func reminder(withId id: Reminder.ID) -> Reminder {
        let index = reminders.indextOfReminder(id: id)
        return reminders[index]
    }
    
    func completeReminder(withId id: Reminder.ID) {
        var reminder = reminder(withId: id)
        reminder.isComplete.toggle()
        updateReminder(reminder: reminder)
        updateSnapshot(reloading: [id])
    }
    
    func updateReminder(reminder: Reminder) {
        do {
            try reminderStore.save(reminder)
            let index = reminders.indextOfReminder(id: reminder.id)
            reminders[index] = reminder
        } catch TodayError.accessDenied {
        } catch {
            showError(error)
        }
    }
    
    func addReminder(_ reminder: Reminder) {
        var copy = reminder
        do {
            let idFromStore = try reminderStore.save(copy)
            copy.id = idFromStore
            reminders.append(reminder)
        } catch TodayError.accessDenied {
        } catch {
            showError(error)
        }
    }
    
    func deleteReminder(withId id: Reminder.ID) {
        do {
            try reminderStore.remove(with: id)
            let index = reminders.indextOfReminder(id: id)
            reminders.remove(at: index)
        } catch TodayError.accessDenied {
        } catch {
            showError(error)
        }
    }
    
    func prepareReminderStore() {
        Task {
            do {
                try await reminderStore.requestAccess()
                reminders = try await reminderStore.readAll()
                NotificationCenter.default.addObserver(
                    self, selector: #selector(eventStoreChanged), name: .EKEventStoreChanged, object: nil)
            } catch TodayError.accessDenied, TodayError.accessRestricted {
                #if DEBUG
                reminders = Reminder.sampleData
                #endif
            } catch {
                showError(error)
            }
            updateSnapshot()
        }
    }
    
    func reminderStoreChanged() {
        Task {
            reminders = try await reminderStore.readAll()
            updateSnapshot()
        }
    }
}
