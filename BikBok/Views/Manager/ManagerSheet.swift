//
//  ManagerSheet.swift
//  BiikBook
//
//  Created by Omar Abu Sharar on 8/22/25.
//

import SwiftUI
import SwiftData

// Sheet to manage the library of books
struct ManagerSheet: View {
    @Query var books: [Book]
    @Environment(\.editMode) var editMode
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        NavigationStack {
            List {
               Section("Books") {
                   ForEach(books, content: { book in
                       Label(title: {
                           Text(book.title)
                       }, icon: {
                           Image(systemName: "book.fill")
                               .foregroundStyle(Gradient(colors: book.colors.map { color in
                                   Color(color)
                               }))
                       })
                   }).onDelete(perform: { indexSet in
                       modelContext.delete(books[indexSet.first!])
                   })
               }
                Section("Delete All", content: {
                    Button(action: {
                        withAnimation(.bouncy) {
                            deleteAll()
                        }
                    }, label: {
                        Label("Delete All Books", systemImage: "trash")
                            .foregroundStyle(.red)
                    })
                    .frame(maxWidth: .infinity, alignment: .leading)
                })
            }
            .navigationTitle("Manage Library")
            .toolbar {
                ToolbarItem(placement: .cancellationAction, content: {
                    Button(role: .close) {
                        dismiss()
                    }
                })
                ToolbarItem(placement: .primaryAction) {
                    EditButton()
                }
            }
        }
    }
    
    // Function to delete all books from the library, virtually resetting the app
    private func deleteAll() {
        for book in books {
            modelContext.delete(book)
        }
    }
    
}

#Preview {
    ManagerSheet()
}
