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
    
    @State var selectedIndex = 0
    @State var shouldShowModal = false
    
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
                                    
                                } label: {
                                    Image(systemName: "arrow.up.arrow.down.square.fill")
                                }
                            }
                        }
                    }
                    
                case 1:
                    NavigationView {
                        ScrollView {
                            Text("TEST")
                        }
                        .navigationTitle("Second Tab")
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
