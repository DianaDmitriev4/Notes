//
//  ColorCategory.swift
//  Notes
//
//  Created by User on 27.12.2023.
//

import UIKit

enum ColorCategory: String, CaseIterable {
    
    case green, blue, yellow, red, white
    var title: String {
        switch self {
        case .green:
            "Green"
        case .blue:
            "Blue"
        case .yellow:
            "Yellow"
        case .red:
            "Red"
        case .white:
            "White"
        }
    }
    var color: UIColor {
        switch self {
        case .green:
            UIColor.lightGreen
        case .blue:
            UIColor.lightBlue
        case .yellow:
            UIColor.lightYellow
        case.red:
            UIColor.lightRed
        case .white:
            UIColor.white
        }
    }
}
