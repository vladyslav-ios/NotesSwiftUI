//
//  NoteView.swift
//  NotesSwiftUI
//
//  Created by Влад Лялькін on 14.12.2023.
//

import SwiftUI
import SwiftData

struct NoteView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var note: Note
    
    @FocusState private var isFocusTitle: Bool
    @FocusState private var isFocusText: Bool

    private var (title, text) = ("","")
    
    var body: some View {
        VStack {
            TextField("Enter Title", text: $note.title, axis: .vertical)
                .font(.largeTitle)
                .focused($isFocusTitle)
                .onChange(of: note.title, perform: { _ in
                    note.dateEdited = Date()
                    viewModel.fetchNotes()
                })
            
            TextField("Enter Text", text: $note.text, axis: .vertical)
                .font(Font.title3)
                .focused($isFocusText)
                .onChange(of: note.text, perform: { _ in
                    note.dateEdited = Date()
                    viewModel.fetchNotes()
                })
            Spacer()
        }
        .padding()
        .navigationTitle("").navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button("Done") {
                    isFocusTitle = false
                    isFocusText = false
                }
                .tint(.yellow)
            }
        }
        .onDisappear {
            guard !note.title.isEmpty || !note.text.isEmpty else {
                return viewModel.deletaNote(noteToDelete: note)
            }
        }
    }
    
    init(viewModel: ViewModel, note: Note) {
        self.viewModel = viewModel
        _note = State(initialValue: note)
        title = note.title
        text = note.text
    }
}


#Preview {
    NoteView(viewModel: ViewModel(modelContext: try! ModelContext(ModelContainer(for: Note.self))), note: Note(dateEdited: Date(), title: "", text: ""))
}
