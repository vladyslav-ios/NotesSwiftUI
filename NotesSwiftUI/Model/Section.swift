//
//  Section.swift
//  NotesSwiftUI
//
//  Created by Влад Лялькін on 14.12.2023.
//

import Foundation

struct SectionN: Identifiable {
    let id = UUID()
    let title: String
    let secondTitle: String?
    var notes: [Note]
}
