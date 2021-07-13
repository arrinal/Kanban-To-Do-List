//
//  ContentView.swift
//  Kanban Simple
//
//  Created by Arrinal Sholifadliq on 10/07/21.
//

import SwiftUI

struct ToDoView: View {
    @EnvironmentObject var viewModel: KanbanViewModel
    var mainColor = Color(red: 238/255, green: 238/255, blue: 238/255)
    var accentColor = Color(red: 51/255, green: 66/255, blue: 87/255)
    
    var body: some View {
        ZStack {
            mainColor.ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    Text("To Do")
                        .font(.title2)
                        .bold()
                        .padding()
                        .foregroundColor(.white)
                    Spacer()
                }.background(accentColor)
                
                HStack(alignment: .center) {
                    TextField("Enter todo list...", text: $viewModel.submitNote, onCommit:  {
                        if viewModel.submitNote.count > 0 {
                            viewModel.save()
                            viewModel.fetchNotes()
                        }
                        
                    }).textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.leading)
                .padding(.trailing)
                
                ListView(arrayNotes: viewModel.toDoViewFiltered())
                
                Spacer()
                
                if viewModel.isShowingMenu {
                    MenuView(kanbanView: "toDoList", arrayNotes: viewModel.toDoViewFiltered())
                        .transition(.scale)
                }
                
                BottomView()
            }
            .foregroundColor(.black)
            .onAppear {
                viewModel.fetchNotes()
                viewModel.kanbanId = Int(viewModel.notes.first?.id ?? 0)
                //                if viewModel.toDoViewFiltered().contains(where: {$0.isChecked}) {
                //                    viewModel.isShowingMenu = true
                //                }
                
                viewModel.showHideMenu(each: viewModel.toDoViewFiltered(), withAnimation: false)
            }
            .environmentObject(viewModel)
        }
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoView().environmentObject(KanbanViewModel())
    }
}
