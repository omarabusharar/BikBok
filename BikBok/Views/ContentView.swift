//
//  TabView.swift
//  BiikBook
//
//  Created by Omar Abu Sharar on 8/22/25.
//

import SwiftUI
import SwiftData

// Main view containing a tab view with a manager tab and a tab for each book
struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Book.title) private var books: [Book]
    var body: some View {
        TabView {
            Tab {
                ManagerTab()
            }
            ForEach(books) { book in
                Tab {
                    BookTab(book: book)
                       
                        .scrollContentBackground(.hidden)
                        
                        
                }
            }
            
        }
        .scrollContentBackground(.hidden)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
