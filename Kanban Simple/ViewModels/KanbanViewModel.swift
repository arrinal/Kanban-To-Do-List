import SwiftUI
import CoreData

class KanbanViewModel: ObservableObject {
    @Published var kanban = Kanban()
    @Published var notes = [Note]()
    @Published var tempDeleteToDo: [Note] = []
    @Published var tempDeleteInProgress: [Note] = []
    @Published var tempDeleteDone: [Note] = []
    @Published var isShowingMenu = false
    @Published var tempShowMenu = [Note]()
    
    @Published var inProgress = [Note]()
    
    @Published var isShowingInProgress = false
    @Published var isShowingDone = false
    
    @Published var editable = ""

    
    
    
    var kanbanId: Int {
        get {
            kanban.noteId
        }
        
        set {
            kanban.noteId = newValue
        }
    }
    
    var submitNote: String {
        get {
            kanban.note
        }
        
        set {
            kanban.note = newValue
        }
        
    }
    
    func fetchNotes() {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Note.id, ascending: false)]
        
        do {
            notes = try PersistenceController.shared.container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
    func save() {
        kanbanId += 1
        let note = Note(context: PersistenceController.shared.container.viewContext)
        note.name = submitNote
        note.isChecked = false
        note.isInProgress = false
        note.isDone = false
        note.id = Int16(kanbanId)
        PersistenceController.shared.save()
        submitNote = ""
    }
    
    func deleteNote(at offsets: IndexSet, view: [Note]) {
        for index in offsets {
            let note = view[index]
            PersistenceController.shared.delete(note)
        }
        fetchNotes()
        
        showHideMenu(each: view, withAnimation: false)
        
    }
    
    func addToTempDelete(view: String) {
        if view == "toDoList" {
            for each in notes.filter({$0.isInProgress == false && $0.isDone == false}) {
                if each.isChecked {
                    tempDeleteToDo.append(each)
                }
            }
        } else if view == "inProgress" {
            for each in notes.filter({$0.isInProgress == true && $0.isDone == false}) {
                if each.isChecked {
                    tempDeleteInProgress.append(each)
                }
            }
        } else if view == "done" {
            for each in notes.filter({$0.isInProgress == false && $0.isDone == true}) {
                if each.isChecked {
                    tempDeleteDone.append(each)
                }
            }
        }
    }
    
    func deleteMultiple(view: String) {
        if view == "toDoList" {
            for each in tempDeleteToDo {
                PersistenceController.shared.delete(each)
            }
            withAnimation {
                self.isShowingMenu = false
            }
            tempDeleteToDo = []
        } else if view == "inProgress" {
            for each in tempDeleteInProgress {
                PersistenceController.shared.delete(each)
            }
            withAnimation {
                self.isShowingMenu = false
            }
            tempDeleteInProgress = []
        } else if view == "done" {
            for each in tempDeleteDone {
                PersistenceController.shared.delete(each)
            }
            withAnimation {
                self.isShowingMenu = false
            }
            tempDeleteDone = []
        }
        fetchNotes()
    }
    
    func getCheckedByView(view: String) -> Int {
        if view == "toDoList" {
            return tempDeleteToDo.count
        } else if view == "inProgress" {
            return tempDeleteInProgress.count
        } else if view == "done" {
            return tempDeleteDone.count
        } else {
            return 0
        }
    }
    
    func showHideMenu(each notes: [Note], withAnimation animation: Bool) {
        
        switch animation {
        case true:
            if notes.contains(where: {$0.isChecked}) {
                withAnimation { isShowingMenu = true }
            } else {
                withAnimation { isShowingMenu = false }
            }
            
        case false:
            if notes.contains(where: {$0.isChecked}) {
                isShowingMenu = true
            } else {
                isShowingMenu = false
            }
        }
        
    }
    
    func moveToToDoList(from arrayNote: [Note]) {
        for each in arrayNote {
            if each.isChecked == true {
                each.isInProgress = false
                each.isChecked = false
            }
        }
        PersistenceController.shared.save()
        fetchNotes()
        
        withAnimation {
            self.isShowingMenu = false
        }
    }
    
    func moveToInProgress(from arrayNote: [Note]) {
        for each in arrayNote {
            if each.isChecked == true {
                each.isInProgress = true
                each.isChecked = false
                each.isDone = false
            }
        }
        PersistenceController.shared.save()
        fetchNotes()
        
        withAnimation {
            self.isShowingMenu = false
        }
    }
    
    func moveToDone(from arrayNote: [Note]) {
        for each in arrayNote {
            if each.isChecked == true {
                each.isInProgress = false
                each.isChecked = false
                each.isDone = true
            }
        }
        PersistenceController.shared.save()
        fetchNotes()
        
        withAnimation {
            self.isShowingMenu = false
        }
    }
    
    
    func toDoViewFiltered() -> [Note] {
        return notes.filter({$0.isInProgress == false && $0.isDone == false})
    }
    
    func inProgressViewFiltered() -> [Note] {
        return notes.filter({$0.isInProgress == true && $0.isDone == false})
    }
    
    func doneViewFiltered() -> [Note] {
        return notes.filter({$0.isInProgress == false && $0.isDone == true})
    }
    
    func moveTo(view: String) -> [String] {
        if view == "toDoList" {
            return ["In Progress", "Done"]
        } else if view == "inProgress" {
            return ["Done", "To Do List"]
        } else if view == "done" {
            return ["In Progress", "To Do List"]
        } else {
            return ["", ""]
        }
    }
    
    func moveToActionFirst(view: String) {
        if view == "toDoList" {
            moveToInProgress(from: toDoViewFiltered())
        } else if view == "inProgress" {
            moveToDone(from: inProgressViewFiltered())
        } else if view == "done" {
           moveToInProgress(from: doneViewFiltered())
        }
    }
    
    func moveToActionSecond(view: String) {
        if view == "toDoList" {
            moveToDone(from: toDoViewFiltered())
        } else if view == "inProgress" {
            moveToToDoList(from: inProgressViewFiltered())
        } else if view == "done" {
            moveToToDoList(from: doneViewFiltered())
        }
    }
    
    func showHideEditMenu(note: [Note]) -> Bool {
        note.filter({$0.isChecked == true}).count == 1
    }
    
    
    
    
    func alertViewTextField(edit editNoteFromMenuView: [Note]) {
        let alert = UIAlertController(title: "Edit Task", message: "Task want to edit: \(editNoteFromMenuView[0].name ?? "Undefined")", preferredStyle: .alert)

        alert.addTextField { (nama) in
            nama.placeholder = "Edit your task..."
        }

        //Action Buttons
        let edit = UIAlertAction(title: "Edit", style: .default) { (_) in
            let edit = alert.textFields![0] as UITextField
            editNoteFromMenuView[0].name = edit.text ?? ""
            PersistenceController.shared.save()
            self.fetchNotes()
            print("value entered by user in our textfield is: " + (self.editable))
        }

        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (_) in
        }

        //adding into alertview
        alert.addAction(cancel)
        alert.addAction(edit)

        //presenting alert
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {
        })
    }
    
}

extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        tapGesture.name = "MyTapGesture"
        window.addGestureRecognizer(tapGesture)
    }
 }

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false // set to `false` if you don't want to detect tap during other gestures
    }
}
