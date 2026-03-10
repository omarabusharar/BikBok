//
//  ManagerTab.swift
//  BiikBook
//
//  Created by Omar Abu Sharar on 8/22/25.
//

import SwiftUI
import SwiftData
internal import UniformTypeIdentifiers

// Tab for managing books (importing, deleting, etc.)
// First Tab in the app
struct ManagerTab: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var importedBook: Book? = nil
    @State private var showImporter: Bool = false
    @State private var showManager: Bool = false
    @State private var scrollPosition: ScrollPosition = .init(edge: .bottom)
    var body: some View {
        NavigationStack {
            ZStack {
                GeometryReader { geo in
                    ScrollView {
                        
                        LazyVStack(spacing: 0) {
                            CoverLayout(header: "BikBok", footer: "Version 1")
                        }
                        .ignoresSafeArea()
                        .scrollTargetLayout()
                        .contentMargins(.bottom, 20)
                        .scrollContentBackground(.hidden)
                    }
                    .scrollDisabled(true)
                }
                
                
                .scrollPosition($scrollPosition, anchor: .bottom)
                .scrollEdgeEffectStyle(.soft, for: .vertical)
                .scrollTargetBehavior(.paging)
                .scrollIndicators(.hidden, axes: .vertical)
                .ignoresSafeArea()
            }
            
            .safeAreaPadding(.all)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button("Manage", systemImage: "books.vertical.fill") {
                        withAnimation(.snappy) {
                            showManager = true
                        }
                    }
                    .sheet(isPresented: $showManager, onDismiss: {
                        showManager = false
                    }, content: {
                        ManagerSheet()
                    })
                })
                ToolbarItem(placement: .topBarLeading, content: {
                    Button("Import (.txt)", systemImage: "square.and.arrow.down") {
                        withAnimation(.snappy) {
                            showImporter.toggle()
                        }
                    }
                    .sheet(item: $importedBook, onDismiss: {
                        importedBook = nil
                    }, content: { book in
                        ImportConfirmationSheet(book: book)
                    })
                    .fileImporter(isPresented: $showImporter, allowedContentTypes: [.plainText], allowsMultipleSelection: true) { result in
                        switch result {
                        case .success(let files):
                            
                            let multipleBooks = files.count > 1
                            for file in files {
                                importBook(from: file, multipleBooks: multipleBooks)
                            }
                            
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                })
            }
        }
    }
    
    private func importBook(from file: URL, multipleBooks: Bool = false) {
        let filename = file.deletingPathExtension().lastPathComponent
    
        if file.startAccessingSecurityScopedResource() {
            var content = "Failed to import book."
            do {
                content = try String(contentsOf: file, encoding: .utf8)
            } catch {
                print(error.localizedDescription)
                file.stopAccessingSecurityScopedResource()
                return
            }
            let book = Book(title: filename, content: content)
            
            if multipleBooks {
                modelContext.insert(book)
                try? modelContext.save()
            } else {
                importedBook = book
            }
            
        }
        file.stopAccessingSecurityScopedResource()
        
    }
}


