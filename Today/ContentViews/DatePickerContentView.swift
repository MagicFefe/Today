//
//  DatePickerContentView.swift
//  Today
//
//  Created by Данил Шипицын on 21.10.2023.
//

import UIKit

class DatePickerContentView: UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        var date: Date = Date.now
        var onChange: (Date) -> Void = { _ in }
        
        func makeContentView() -> UIView & UIContentView {
            DatePickerContentView(configuration: self)
        }
    }
    
    let picker = UIDatePicker()
    var configuration: UIContentConfiguration {
        didSet {
            self.configure(configuration: configuration)
        }
    }
    
    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        addPinnedSubview(picker)
        picker.preferredDatePickerStyle = .inline
        picker.addTarget(self, action: #selector(didChange(_:)), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? DatePickerContentView.Configuration else {
            return
        }
        picker.date = configuration.date
    }
    
    @objc private func didChange(_ sender: UIDatePicker) {
        guard let configuration = configuration as? DatePickerContentView.Configuration else {
            return
        }
        configuration.onChange(sender.date)
    }
}

extension UICollectionViewListCell {
    func datePickerConfiguration() -> DatePickerContentView.Configuration {
        DatePickerContentView.Configuration()
    }
}
