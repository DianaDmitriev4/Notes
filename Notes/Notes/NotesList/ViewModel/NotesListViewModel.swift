//
//  NotesListViewModel.swift
//  Notes
//
//  Created by User on 13.12.2023.
//

import Foundation

protocol NotesListViewModelProtocol {
    var section: [TableViewSection] { get }
    var reloadTable: (() -> Void)? { get set }
    
    func getNotes()
}

final class NotesListViewModel: NotesListViewModelProtocol {
    
    // MARK: - Properties
    var reloadTable: (() -> Void)?
    
    private(set) var section: [TableViewSection] = [] {
        didSet {
            reloadTable?()
        }
    }
    
    // MARK: - Initialization
    init() {
        getNotes()
    }
    
    // MARK: - Private methods
    func getNotes() {
        let notes = NotePersistent.fetchAll()
        section = []
        print(notes)
        
        let groupedObjects = notes.reduce(into: [Date: [Note]]()) { result, note in
            let date = Calendar.current.startOfDay(for: note.date)
            result[date, default: []].append(note)
        }
        
        let keys = groupedObjects.keys
        
        keys.forEach { key in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM yyyy"
            let stringDate = dateFormatter.string(from: key)
            section.append(TableViewSection(title: stringDate,
                                            items: groupedObjects[key] ?? []))
        }
    }
}
