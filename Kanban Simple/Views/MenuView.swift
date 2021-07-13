//
//  MenuView.swift
//  Kanban Simple
//
//  Created by Arrinal Sholifadliq on 12/07/21.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var viewModel: KanbanViewModel
    @State private var showingCancelActionSheet = false
    @State private var showingMoveToActionSheet = false
    
    var kanbanView: String
    var arrayNotes: [Note]
    
    func sWordDetect() -> String {
        if viewModel.getCheckedByView(view: kanbanView) == 1 {
            return "task"
        } else {
            return "tasks"
        }
    }
    
    var body: some View {
        HStack {
            Button {
                viewModel.addToTempDelete(view: kanbanView)
                self.showingCancelActionSheet = true
                
            } label: {
                Text("Delete")
                    .actionSheet(isPresented: $showingCancelActionSheet) {
                        ActionSheet( title: Text("Are you sure want to delete?"), buttons: [
                            .destructive(Text("Delete \(viewModel.getCheckedByView(view: kanbanView)) \(sWordDetect())")) {
                            viewModel.deleteMultiple(view: kanbanView)
                        },
                            .cancel() {
                            viewModel.tempDeleteToDo = []
                            viewModel.tempDeleteInProgress = []
                            viewModel.tempDeleteDone = []
                        }
                        ])
                    }
            }
            Spacer()
            if viewModel.showHideEditMenu(note: arrayNotes) {
                Button {
                    let filteredToEdit = arrayNotes.filter({$0.isChecked == true})
                    viewModel.alertViewTextField(edit: filteredToEdit)
                } label: {
                    Text("Edit")
                }
            }
            Spacer()
            Button {
                self.showingMoveToActionSheet = true
            } label: {
                Text("Move to")
                    .actionSheet(isPresented: $showingMoveToActionSheet) {
                        ActionSheet( title: Text("Where do you want to move to?"), buttons: [
                            .default(Text(viewModel.moveTo(view: kanbanView)[0])) {
                            viewModel.moveToActionFirst(view: kanbanView)
                        },
                            .default(Text(viewModel.moveTo(view: kanbanView)[1])) {
                            viewModel.moveToActionSecond(view: kanbanView)
                        },
                            .cancel()
                        ])
                    }
            }
        }.padding()
            .border(.gray)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(kanbanView: "toDoList", arrayNotes: KanbanViewModel().notes).environmentObject(KanbanViewModel())
    }
}
