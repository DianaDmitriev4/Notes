//
//  NoteEntity+CoreDataProperties.swift
//  Notes
//
//  Created by User on 22.12.2023.
//
//

import Foundation
import CoreData


extension NoteEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteEntity> {
        return NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
    }
    
    @NSManaged public var date: Date?
    @NSManaged public var imageUrl: URL?
    @NSManaged public var text: String?
    @NSManaged public var title: String?
    @NSManaged public var category: String?
    
}

extension NoteEntity : Identifiable {
    
}
