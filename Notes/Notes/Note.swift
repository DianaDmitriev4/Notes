//
//  Note.swift
//  Notes
//
//  Created by User on 13.12.2023.
//

import Foundation

struct Note: TableViewItemProtocol {
    let title: String
    let description: String
    let date: Date
    let imageURL: String?
    let image: Data?
    
}
