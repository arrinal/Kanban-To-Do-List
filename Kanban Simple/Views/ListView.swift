//
//  ListView.swift
//  Kanban Simple
//
//  Created by Arrinal Sholifadliq on 12/07/21.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var viewModel: KanbanViewModel
    
    var arrayNotes: [Note]
    
    var body: some View {
        List {
            ForEach(arrayNotes) { note in
                Button {
                    note.isChecked.toggle()
                    viewModel.showHideMenu(each: arrayNotes, withAnimation: true)
                    PersistenceController.shared.save()
                    viewModel.fetchNotes()

                } label: {
                    HStack {
                        Image(systemName: note.isChecked ? "checkmark.square" : "square").foregroundColor(.blue)
                        Text("\(note.name ?? "Unknown")")
                    }
                }
            }.onDelete{ viewModel.deleteNote(at: $0, view: arrayNotes)}
        }.listStyle(InsetGroupedListStyle())
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(arrayNotes: KanbanViewModel().notes)
            .environmentObject(KanbanViewModel())
    }
}
