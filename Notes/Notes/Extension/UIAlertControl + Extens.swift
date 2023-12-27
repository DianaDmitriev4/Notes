//
//  File.swift
//  Notes
//
//  Created by User on 18.12.2023.
//

import UIKit

extension UIAlertController {
    func addActions(actions: [UIAlertAction]) {
        actions.forEach { action in
            addAction(action)
        }
    }
}
