//
//  Note.swift
//  NotesSwiftUI
//
//  Created by Влад Лялькін on 17.12.2023.
//

import Foundation
import SwiftData

@Model
final class Note: Identifiable {
    let id = UUID()
    let dateCreated = Date()
    var dateEdited: Date
    var title: String
    var text: String
    
    init(dateEdited: Date, title: String, text: String) {
        self.dateEdited = dateEdited
        self.title = title
        self.text = text
    }
}
