//
//  NotesListViewModel.swift
//  Notes
//
//  Created by User on 13.12.2023.
//

import Foundation

protocol NotesListViewModelProtocol {
    var section: [TableViewSection] { get }
}

final class NotesListViewModel: NotesListViewModelProtocol {
    
    // MARK: - Properties
    private(set) var section: [TableViewSection] = []
    
    // MARK: - Initialization
    init() {
        getNotes()
        setMocks()
    }
    
    // MARK: - Private methods
    private func getNotes() {
        
    }
    
    private func setMocks() {
        let section = TableViewSection(title: "26 April 2023",
                                       items: [Note(title: "First note",
                                                    description: "First note description",
                                                    date: Date(),
                                                    imageURL: nil,
                                                    image: nil, category: nil),
                                               
                                               Note(title: "Second note",
                                                    description: "Second note description",
                                                    date: Date(),
                                                    imageURL: nil,
                                                    image: nil, category: nil)
                                       ])
        self.section = [section]
    }
}
