//
//  ContentView.swift
//  ToDoList
//
//  Created by Mohammadamin Aryan on 6/15/22.
//

import SwiftUI

class ToDoItem {
    var id: String
    var name: String
    var creation_date: Date
    var due_date: Date
    
    init(name: String, creation_date: Date, due_date: Date) {
        self.id = UUID().uuidString
        self.name = name
        self.creation_date = creation_date
        self.due_date = due_date
    }
}

struct ContentView: View {
    
    init() {
        UITabBar.appearance().barTintColor = .systemBackground
        UINavigationBar.appearance().barTintColor = .systemBackground
    }
    
    func deleteItem(at offsets: IndexSet) {
        toDoItems.remove(atOffsets: offsets)
    }
    
    @State var toDoItems: [ToDoItem] = [
        ToDoItem(name: "todo1", creation_date: Date(), due_date: Date())
    ]
    
    @State var isAcending = true
    @State var sortBy = "creationDate"
    
    @State var selectedIndex = 0
    @State var shouldShowModal = false
    @State var isShowingSheet = false
    
    @State var selectedDate = Date()
    
    let tabBarImageNames = ["person", "gear", "plus.app.fill", "pencil", "lasso", "arrow.up.arrow.down.square.fill"]
    
    static let stackDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "E, yyyy-MM-dd HH:mm:ss"
            return formatter
        }()
    
    var body: some View {
        VStack(spacing: 0) {
            
            ZStack {
                
                Spacer()
                    .fullScreenCover(isPresented: $shouldShowModal, content: {
                        Button(action: {shouldShowModal.toggle()}, label: {
                            Text("Fullscreen cover")
                        })
                    
                })
                
                switch selectedIndex {
                case 0:
                    NavigationView {
                        List {
                            ForEach(toDoItems, id: \.id) { item in
                                VStack(alignment: .leading, spacing: 10) {
                                    
                                    Text("\(item.name)").bold().font(.title2)
                                    Text("\(item.due_date, formatter: Self.stackDateFormatter)")
                                }
                            }
                            .onDelete(perform: deleteItem)
                        }
                        .navigationTitle("First Tab")
                        .toolbar {
                            HStack() {
                                NavigationLink {
                                    AddItemView(ToDoItems: $toDoItems)
                                } label: {
                                    Image(systemName: "plus.app.fill")
                                }
                                Button {
                                    isShowingSheet.toggle()
                                } label: {
                                    Image(systemName: "arrow.up.arrow.down.square.fill")
                                }
                                .sheet(isPresented: $isShowingSheet) {
                                   // VStack(spacing: 10) {
                                        List {
                                        Button {sortBy = "name"} label: {
                                            HStack() {
                                                Text("Name")
                                                if (sortBy == "name") {
                                                    Spacer()
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                        }
                                        Button {sortBy = "dueDate"} label: {
                                            HStack() {
                                                Text("Due Date")
                                                if (sortBy == "dueDate") {
                                                    Spacer()
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                        }
                                        Button {sortBy = "creationDate"} label: {
                                            HStack() {
                                                Text("Creation Date")
                                                if (sortBy == "creationDate") {
                                                    Spacer()
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                        }
                                   // }
                                    //List {
                                            Spacer()

                                        Button {isAcending = false} label: {
                                            HStack() {
                                                Text("Decending")
                                                if (!isAcending) {
                                                    Spacer()
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                        }
                                        Button {isAcending = true} label: {
                                            HStack() {
                                                Text("Acending")
                                                if (isAcending) {
                                                    Spacer()
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                        }
                                    //}
                                            Spacer()
                                    Button("Sort", action: { isShowingSheet.toggle()})
                                }
                            }
                        }
                    }
                        
                }
                    
                case 1:
                    NavigationView {
                            List {
                                DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                                
                                ForEach(toDoItems, id: \.id) { item in
                                    if(Calendar.current.compare(item.due_date, to: selectedDate, toGranularity: .day) == .orderedSame) {
                                        VStack(alignment: .leading, spacing: 10) {
                                            
                                            Text("\(item.name)").bold().font(.title2)
                                            Text("\(item.due_date, formatter: Self.stackDateFormatter)")
                                        }
                                    }
                                    
                                }
                                .onDelete(perform: deleteItem)
                            }
                            .navigationTitle("second Tab")
                        }
                    
                default:
                    NavigationView {
                        Text("Remaining tabs")
                        
                    }
                }
                
            }
            
//            Spacer()
            
            Divider()
                .padding(.bottom, 8)
            
            HStack {
                ForEach(0..<2) { num in
                    Button(action: {
                        
                        if num == 2 {
                            shouldShowModal.toggle()
                            return
                        }
                        
                        selectedIndex = num
                    }, label: {
                        Spacer()
                        
                        if num == 2 {
                            Image(systemName: tabBarImageNames[num])
                                .font(.system(size: 44, weight: .bold))
                                .foregroundColor(.red)
                        } else {
                            Image(systemName: tabBarImageNames[num])
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(selectedIndex == num ? Color(.black) : .init(white: 0.8))
                        }
                        
                        
                        Spacer()
                    })
                    
                }
            }
            
            
        }
    }
}

//TabView {
//    Text("First")
//        .tabItem {
//            Image(systemName: "person")
//            Text("First")
//        }
//    Text("Second")
//        .tabItem {
//            Image(systemName: "gear")
//            Text("Second")
//        }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
