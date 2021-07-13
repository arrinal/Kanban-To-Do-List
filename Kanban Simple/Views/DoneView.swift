//
//  DoneView.swift
//  Kanban Simple
//
//  Created by Arrinal Sholifadliq on 13/07/21.
//

import SwiftUI

struct DoneView: View {
    @EnvironmentObject var viewModel: KanbanViewModel
    var mainColor = Color(red: 238/255, green: 238/255, blue: 238/255)
    var accentColor = Color(red: 51/255, green: 66/255, blue: 87/255)
    
    var body: some View {
        ZStack {
            mainColor.ignoresSafeArea()
            VStack {
                HStack {
                  Spacer()
                    Text("Done")
                        .font(.title2)
                        .bold()
                        .padding()
                        .foregroundColor(.white)
                    Spacer()
                }.background(accentColor)
                ListView(arrayNotes: viewModel.doneViewFiltered())
                
                Spacer()
                
                if viewModel.isShowingMenu {
                    MenuView(kanbanView: "done", arrayNotes: viewModel.doneViewFiltered())
                        .transition(.scale)
                }
                
                BottomView()
            }
            .foregroundColor(.black)
            .onAppear {
                viewModel.fetchNotes()
                viewModel.showHideMenu(each: viewModel.doneViewFiltered(), withAnimation: false)
            }
            .environmentObject(viewModel)
        }
        
    }
}

struct DoneView_Previews: PreviewProvider {
    static var previews: some View {
        DoneView().environmentObject(KanbanViewModel())
    }
}
