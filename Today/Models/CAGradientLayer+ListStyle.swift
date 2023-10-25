//
//  CAGradientLayer+ListStyle.swift
//  Today
//
//  Created by Данил Шипицын on 23.10.2023.
//

import Foundation
import UIKit

extension CAGradientLayer {
    static func gradient(for style: ReminderListStyle, in frame: CGRect) -> Self {
        let layer = Self()
        layer.colors = color(for: style)
        layer.frame = frame
        return layer
    }
    
    private static func color(for style: ReminderListStyle) -> [CGColor] {
        let beginColor: UIColor
        let endColor: UIColor
        
        switch style {
        case .today:
            beginColor = .todayGradientTodayBegin
            endColor = .todayGradientTodayEnd
        case .future:
            beginColor = .todayGradientFutureBegin
            endColor = .todayGradientFutureEnd
        case .all:
            beginColor = .todayGradientAllBegin
            endColor = .todayGradientAllEnd
        }
        
        return [beginColor.cgColor, endColor.cgColor]
    }
}
