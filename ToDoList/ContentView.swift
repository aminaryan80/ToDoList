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
    var creationDate: Date
    var dueDate: Date
    
    init(name: String, creationDate: Date, dueDate: Date) {
        self.id = UUID().uuidString
        self.name = name
        self.creationDate = creationDate
        self.dueDate = dueDate
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
    
    func sortItems() {
        switch sortBy {
        case "name":
            toDoItems.sort {
                $0.name < $1.name
            }
        case "dueDate":
            toDoItems.sort {
                $0.dueDate < $1.dueDate
            }
        default:
            toDoItems.sort {
                $0.creationDate < $1.creationDate
            }
        }
        if !isAcending{
            toDoItems.reverse()
        }
    }
    
    func sortItemsByDueDate() {
        toDoItems.sort {
            $0.dueDate < $1.dueDate
        }
    }
    
    @State var toDoItems: [ToDoItem] = []
    
    @State var isAcending = true
    @State var sortBy = "creationDate"
    
    @State var selectedIndex = 0
    @State var shouldShowModal = false
    @State var isShowingSheet = false
    
    @State var selectedDate = Date()
    
    let tabBarImageNames = ["list.bullet.rectangle.portrait", "calendar"]
    let tabBarNames = ["All", "Daily"]
    
    static let stackDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "E, yyyy-MM-dd HH:mm:ss"
            return formatter
        }()
    
    var body: some View {
        VStack(spacing: 0) {
            
            ZStack {
                
                Spacer()
                
                switch selectedIndex {
                case 0:
                    NavigationView {
                        List {
                            ForEach(toDoItems, id: \.id) { item in
                                VStack(alignment: .leading, spacing: 10) {
                                    
                                    Text("\(item.name)").bold().font(.title2)
                                    HStack () {
                                        Image(systemName: "calendar")
                                        Text("\(item.dueDate, formatter: Self.stackDateFormatter)")
                                    }
                                }
                            }
                            .onDelete(perform: deleteItem)
                        }
                        .navigationTitle("All Tasks")
                        .onAppear {
                            sortItems()
                        }
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
                                .sheet(isPresented: $isShowingSheet, onDismiss: sortItems) {
                                    List {
                                        Button {sortBy = "name"} label: {
                                            HStack() {
                                                Text("Name").foregroundColor(.black)
                                                if (sortBy == "name") {
                                                    Spacer()
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                        }
                                            
                                        Button {sortBy = "dueDate"} label: {
                                            HStack() {
                                                Text("Due Date").foregroundColor(.black)
                                                if (sortBy == "dueDate") {
                                                    Spacer()
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                        }
                                                
                                        Button {sortBy = "creationDate"} label: {
                                            HStack() {
                                                Text("Creation Date").foregroundColor(.black)
                                                if (sortBy == "creationDate") {
                                                    Spacer()
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                        }
                                                
                                        Spacer()

                                        Button {isAcending = false} label: {
                                            HStack() {
                                                Text("Decending").foregroundColor(.black)
                                                if (!isAcending) {
                                                    Spacer()
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                        }
                                            
                                        Button {isAcending = true} label: {
                                            HStack() {
                                                Text("Acending").foregroundColor(.black)
                                                if (isAcending) {
                                                    Spacer()
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                        }
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
                                    if(Calendar.current.compare(item.dueDate, to: selectedDate, toGranularity: .day) == .orderedSame) {
                                        VStack(alignment: .leading, spacing: 10) {
                                            
                                            Text("\(item.name)").bold().font(.title2)
                                            HStack () {
                                                Image(systemName: "calendar")
                                                Text("\(item.dueDate, formatter: Self.stackDateFormatter)")
                                            }
                                        }
                                    }
                                }
                                .onDelete(perform: deleteItem)
                            }
                            .navigationTitle("Daily Tasks")
                            .onAppear {
                                sortItemsByDueDate()
                            }
                        }
                    
                default:
                    NavigationView {
                        Text("Remaining tabs")
                        
                    }
                }
                
            }
            
            
            Divider()
                .padding(.bottom, 8)
            
            HStack {
                ForEach(0..<2) { num in
                    Button(action: {
                        selectedIndex = num
                    }, label: {
                        Spacer()
                        VStack {
                            Image(systemName: tabBarImageNames[num])
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(selectedIndex == num ? Color(.black) : .init(white: 0.8))
                            Text(tabBarNames[num]).foregroundColor(selectedIndex == num ? Color(.black) : .init(white: 0.8)).font(.caption)
                        }
                        
                        Spacer()
                    })
                    
                }
            }
            
            
        }
    }
}
