//
//  ContentView.swift
//  NotesSwiftUI
//
//  Created by Влад Лялькін on 12.12.2023.
//

import SwiftUI
import SwiftData

struct NotesView: View {
    @StateObject private var viewModel: ViewModel
    @State private var newNote: Note? //for toolbar
    @State private var searchFilter = "" //for searchable
    
    var filteredNotes: [SectionN] {
        guard !searchFilter.isEmpty else { return viewModel.sections }

        return [SectionN(title: "Notes", secondTitle: "Found", notes: viewModel.notes.filter { $0.text.localizedCaseInsensitiveContains(searchFilter)
            || $0.title.localizedCaseInsensitiveContains(searchFilter)
        })]
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredNotes) { section in
                    Section {
                        ForEach(section.notes) { note in
                            NoteRow(viewModel: viewModel, note: note)
                        }
                        .onDelete(perform: { indexSet in
                            if let index = indexSet.first {
                                viewModel.deletaNote(noteToDelete: section.notes[index])
                            }
                        })
                    } header: {
                        HStack {
                            Text(section.title)
                                .foregroundStyle(.primary)
                                .font(.title3)
                                .offset(x: -18)
                            Spacer()
                            if let title = section.secondTitle {
                                Text((section.notes.count != 0 ? "\(section.notes.count)" : "None") + " " + title)
                                    .foregroundStyle(.gray)
                                    .font(.body)
                                    .offset(x: 18)
                            }
                        }
                    }
                    .headerProminence(.increased)
                    .animation(.default)
                }
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu("Sort By", systemImage: "ellipsis.circle") {
                        Picker("Sort By", selection: $viewModel.sortBy) {
                            Text("Data Edited").tag(SortBy[0])
                            Text("Data Created").tag(SortBy[1])
                            Text("Title").tag(SortBy[2])
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.newNote = viewModel.createNote()
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                    .navigationDestination(item: $newNote) { note in
                        NoteView(viewModel: viewModel, note: note)
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Text(viewModel.count == 0 ? "No Notes" : viewModel.count > 1 ? "\(viewModel.count) Notes" : "\(viewModel.count) Note")
                        .font(.system(size: 12))
                }
            }
            .searchable(text: $searchFilter, placement: .navigationBarDrawer(displayMode: .always))
        }
        .tint(.yellow)
    }
    
    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}

#Preview {
    NotesView(modelContext: try! ModelContext(ModelContainer(for: Note.self)))
}
