//
//  KanbanView.swift
//  Kanban Simple
//
//  Created by Arrinal Sholifadliq on 12/07/21.
//

import SwiftUI

struct KanbanView: View {
    var mainColor = Color(red: 238/255, green: 238/255, blue: 238/255)
    
    @StateObject var viewModel = KanbanViewModel()
    
    
    var body: some View {
        NavigationView {
            ZStack {
                mainColor.ignoresSafeArea()
                ToDoView().environmentObject(viewModel)
                if viewModel.isShowingInProgress {InProgressView().environmentObject(viewModel)}
                if viewModel.isShowingDone {DoneView().environmentObject(viewModel)}
            }
            .navigationTitle("Kanban To-Do List")
        }
    }
}



struct KanbanView_Previews: PreviewProvider {
    static var previews: some View {
        KanbanView()
    }
}
