//
//  BottomView.swift
//  Kanban Simple
//
//  Created by Arrinal Sholifadliq on 10/07/21.
//

import SwiftUI

struct BottomView: View {
    @EnvironmentObject var viewModel: KanbanViewModel
    var bottomButtonColor = Color(red: 71/255, green: 96/255, blue: 114/255)
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                viewModel.isShowingInProgress = false
                viewModel.isShowingDone = false
                viewModel.showHideMenu(each: viewModel.toDoViewFiltered(), withAnimation: true)
            } label: {
                VStack {
                    Image("todo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                    Text("To Do").font(.callout)
                }
            }
            Spacer()
            Button {
                viewModel.isShowingInProgress = true
                viewModel.isShowingDone = false
                viewModel.showHideMenu(each: viewModel.inProgressViewFiltered(), withAnimation: true)
            } label: {
                VStack {
                    Image("in-progress")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                    Text("In Progress").font(.callout)
                }
            }
            Spacer()
            Button {
                viewModel.isShowingDone = true
                viewModel.isShowingInProgress = false
                viewModel.showHideMenu(each: viewModel.inProgressViewFiltered(), withAnimation: true)
            } label: {
                VStack {
                    Image("done")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                    Text("Done").font(.callout)
                }
            }
            Spacer()
        }
        .foregroundColor(.white)
        .padding()
        .background(bottomButtonColor.ignoresSafeArea(edges: .bottom))
    }
}

struct BottomView_Previews: PreviewProvider {
    static var previews: some View {
        BottomView().environmentObject(KanbanViewModel())
    }
}
