//
//  NoteRow.swift
//  NotesSwiftUI
//
//  Created by Влад Лялькін on 20.12.2023.
//

import SwiftUI

struct NoteRow: View {
    @State private var isPresent = false
    let viewModel: ViewModel
    let note: Note

    var body: some View {
        HStack {
            Button {
                isPresent.toggle()
            } label: {
                VStack(alignment: .leading) {
                    Text(note.title.removeSpace(with: "") != "" ? note.title.removeSpace(with: " ") : "New Note")
                        .font(.headline)
                        .foregroundStyle(Color(uiColor: .label))
                        .lineLimit(1)
                    
                    Text(Sort.date(date: note.dateEdited) + " " + (note.text.removeSpace(with: "") != "" ? note.text.removeSpace(with: " ") : "No Additional text"))
                        .foregroundStyle(.gray)
                        .lineLimit(1)
                }
            }
            .navigationDestination(isPresented: $isPresent) {
                NoteView(viewModel: viewModel, note: note)
            }
        }
    }
}

extension String {
    func removeSpace(with: String) -> String {
        return self.replacingOccurrences(of: "\\s", with: with, options: .regularExpression)
    }
}



//#Preview {
//    NoteRow()
//}
