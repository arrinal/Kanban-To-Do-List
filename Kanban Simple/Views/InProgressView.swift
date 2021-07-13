//
//  InProgressView.swift
//  Kanban Simple
//
//  Created by Arrinal Sholifadliq on 12/07/21.
//

import SwiftUI

struct InProgressView: View {
    @EnvironmentObject var viewModel: KanbanViewModel
    var mainColor = Color(red: 238/255, green: 238/255, blue: 238/255)
    var accentColor = Color(red: 51/255, green: 66/255, blue: 87/255)
    
    var body: some View {
        ZStack {
            mainColor.ignoresSafeArea()
            VStack {
                HStack {
                  Spacer()
                    Text("In Progress")
                        .font(.title2)
                        .bold()
                        .padding()
                        .foregroundColor(.white)
                    Spacer()
                }.background(accentColor)
                ListView(arrayNotes: viewModel.inProgressViewFiltered())
                
                Spacer()
                
                if viewModel.isShowingMenu {
                    MenuView(kanbanView: "inProgress", arrayNotes: viewModel.inProgressViewFiltered())
                        .transition(.scale)
                }
                
                BottomView()
            }
            .foregroundColor(.black)
            .onAppear {
                viewModel.fetchNotes()
//                if viewModel.inProgressViewFiltered().contains(where: {$0.isChecked}) {
//                    viewModel.isShowingMenu = true
//                }
                viewModel.showHideMenu(each: viewModel.inProgressViewFiltered(), withAnimation: false)
            }
            .environmentObject(viewModel)
        }
        
    }
}

struct InProgressView_Previews: PreviewProvider {
    static var previews: some View {
        InProgressView().environmentObject(KanbanViewModel())
    }
}
