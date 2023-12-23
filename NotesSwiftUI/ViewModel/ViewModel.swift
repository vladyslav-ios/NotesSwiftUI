//
//  NotesViewModel.swift
//  NotesSwiftUI
//
//  Created by Влад Лялькін on 12.12.2023.
//

import SwiftUI
import SwiftData

final class ViewModel: ObservableObject {
    @Published var sections = [SectionN]()
    @Published var notes = [Note]()
    @Published var count = 0
    
    @AppStorage("SortBy") var sortBy = "dateEdited" {
        didSet {
            fetchNotes()
        }
    }
    
    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchNotes()
    }
    
    func createNote() -> Note {
        let newNote = Note(dateEdited: Date(), title: "", text: "")
        modelContext.insert(newNote)

        fetchNotes()
        return newNote
    }
    
    func fetchNotes() {
        withAnimation() {
            do {
                let fetchDescriptor = FetchDescriptor<Note>()
                
                notes = try modelContext.fetch(fetchDescriptor)
                sections = switch sortBy {
                case "dateEdited":
                    Sort.notes(notes: notes.sorted { $0.dateEdited > $1.dateEdited }, sort: "dateEdited")
                case "dateCreated":
                    Sort.notes(notes: notes.sorted { $0.dateCreated > $1.dateCreated }, sort: "dateCreated")
                default:
                    [SectionN(title: "Notes", secondTitle: nil, notes: notes.sorted { $0.title > $1.title })]
                }
                count = try modelContext.fetchCount(fetchDescriptor)
            } catch {
                fatalError("error: \(error)")
            }
        }
    }
    
    func deletaNote(noteToDelete: Note) {
        withAnimation {
            for index in (0..<sections.count).reversed() {
                sections[index].notes.removeAll { $0.id == noteToDelete.id }
                if sections[index].notes.isEmpty {
                    sections.remove(at: index)
                }
            }
            
            notes.removeAll { $0.id == noteToDelete.id }
            
            do {
                modelContext.delete(noteToDelete)
                let fetchDescriptor = FetchDescriptor<Note>()
                count = try modelContext.fetchCount(fetchDescriptor)
            } catch {
                fatalError("error: \(error)")
            }
        }
    }
}
