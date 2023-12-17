//
//  TableViewSection.swift
//  Notes
//
//  Created by User on 13.12.2023.
//

import Foundation

protocol TableViewItemProtocol { }

struct TableViewSection: TableViewItemProtocol {
    var title: String?
    var items: [TableViewItemProtocol]
}
