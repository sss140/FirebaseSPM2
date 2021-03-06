//
//  ContentView.swift
//  FirebaseSPM2
//
//  Created by 佐藤一成 on 2020/12/29.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct ContentView: View {
    private var db:Firestore
    @State private var title:String = ""
    @State private var tasks:[Task] = []
    
    
    init(){
        db = Firestore.firestore()
    }
    
    private func saveTask(task:Task){
        do{
            _ = try db.collection("tasks").addDocument(from: task){ err in
                if let err = err{
                    print(err.localizedDescription)
                }else{
                    print("Document has been saved")
                    fetchAllTasks()
                }
            }
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    private func fetchAllTasks(){
        db.collection("tasks").getDocuments { (snapshot, error) in
            if let error = error{
                print(error.localizedDescription)
            }else{
                if let snapshot = snapshot{
                    tasks = snapshot.documents.compactMap{doc in
                        var task = try? doc.data(as: Task.self)
                        if task != nil{
                            task!.id = doc.documentID
                        }
                        return task
                    }
                }
            }
        }
    }
    
    private func deleteTask(at indexSet:IndexSet){
        indexSet.forEach{index in
            let task = tasks[index]
            
            db.collection("tasks")
                .document(task.id!)
                .delete{error in
                    if let error = error{
                        print(error.localizedDescription)
                    }else{
                        fetchAllTasks()
                    }
                    
                }
        }
    }
    
    
    var body: some View {
        VStack{
            TextField("Enter Task", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Save"){
                let task = Task(title: title)
                saveTask(task: task)
            }
            List{
                ForEach(tasks, id:\.title){task in
                    Text(task.title)
                }.onDelete(perform:deleteTask)
            }
            /*
            List(tasks, id: \.title){task in
                Text(task.title)
            }
            */
            Spacer()
                .onAppear(perform: {
                    fetchAllTasks()
                })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
