//
//  DiscountType.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 03.08.2022.
//

import UIKit.UIColor

enum DiscountType {
    case discountRed
    case discountYellow
    case discountGreen
    
    var backgroundColor: UIColor {
        switch self {
        case .discountRed:
            return .red.withAlphaComponent(0.4)
        case .discountYellow:
            return .yellow.withAlphaComponent(0.4)
        case .discountGreen:
            return .green.withAlphaComponent(0.4)
        }
    }
    
    static func getType(with value: Int) -> Self {
        switch value {
        case 0...30:
            return .discountGreen
        case 31...60:
            return .discountYellow
        default:
            return .discountRed
        }
    }
    
}
