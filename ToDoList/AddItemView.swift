//
//  AddItemView.swift
//  ToDoList
//
//  Created by Mohammadamin Aryan on 6/15/22.
//

import SwiftUI

struct AddItemView: View {
    @Environment(\.presentationMode) var mode
    
    @Binding var ToDoItems: [ToDoItem]
    
    @State var name = ""
    @State var dueDate = Date()
    
    @State var isEmptyNameAlertPresented = false
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
            DatePicker("Date", selection: $dueDate)
        }
        .alert("Name cannot be empty!", isPresented: $isEmptyNameAlertPresented) {
            Button("Cancel", role: .cancel) {}
        }
        .navigationTitle(Text("Add new todo"))
        .toolbar {
            Button {
                if name != "" {
                    let item = ToDoItem(name: name, creationDate: Date(), dueDate: dueDate)
                    ToDoItems.append(item)
                    mode.wrappedValue.dismiss()
                } else {
                    isEmptyNameAlertPresented = true
                }
                
            } label: {
                Text("Add")
            }
        }
    }
}
