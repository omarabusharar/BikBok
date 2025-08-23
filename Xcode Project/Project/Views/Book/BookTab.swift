//
//  ContentView.swift
//  bikbok
//
//  Created by Omar Abu Sharar on 8/21/25.
//

import SwiftUI
import SwiftData

// Handles navigation and layout for a single book
struct BookTab: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var selection: Int? = 0
    var isCoverShown: Bool {
        selection == 0
    }
    var opacity: Double {
        if colorScheme == .dark {
            isCoverShown ? 0.545 : 0.15
        } else {
            isCoverShown ? 1 : 0.9
        }
    }
    
    var book: Book
    
    var pages: [Page] {
        return book.pages.sorted { $0.number < $1.number }
    }
  
    var body: some View {
        NavigationStack {
            ZStack {
                GeometryReader { geo in
                ScrollView {
                   
                        LazyVStack(spacing: 0) {
                            CoverLayout(book: book)
                                .id(0)
                            ForEach(pages, id: \.id) { page in
                                BookPage(page: page, book: book)
                                    .id(page.number)
                                    
                                    
                            }
                        }
                        .ignoresSafeArea()
                        .scrollTargetLayout()
                        .contentMargins(.bottom, 20)
                        .scrollContentBackground(.hidden)
                    }
                }
                .background {
                    Rectangle()
                        .fill(book.gradient.opacity(opacity))
                        .animation(.bouncy, value: isCoverShown)
                        .ignoresSafeArea()
                        .brightness(isCoverShown ? 0 : -0.4)
                }
                
                .navigationTitle(isCoverShown ? "" : book.title)
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            withAnimation(.snappy) {
                                selection = book.bookmarkedPage ?? 0
                            }
                        }, label: {
                            Label("Go to Bookmark", systemImage: "bookmark.circle")
                                .labelStyle(.iconOnly)
                        })
          
                    }
                    ToolbarItemGroup(placement: .primaryAction) {
                        Menu(content: {
                            Button("Up", systemImage: "chevron.up", action: {
                                withAnimation(.snappy) {
                                    if selection ?? 0 > 0 {
                                        selection = (selection ?? 0) - 1
                                    }
                                }
                            })
                            Button("Jump to Cover", systemImage: "book", action: {
                                withAnimation(.snappy) {
                                    selection = 0
                                }
                            })
                        }, label: {
                            Label("Up", systemImage: "chevron.up")
                        }, primaryAction: {
                            withAnimation(.snappy) {
                                if selection ?? 0 > 0 {
                                    selection = (selection ?? 0) - 1
                                }
                            }
                        })
                       
                        .disabled(selection == 0 || selection == nil)
                        Button("Down", systemImage: "chevron.down", action: {
                            withAnimation(.snappy) {
                                if selection ?? 0 < (book.pages.count) {
                                    selection = (selection ?? 0) + 1
                                }
                            }
                        })
                        .disabled(selection == nil || selection == book.pages.count)
                    }
                })
                .scrollPosition(id: $selection, anchor: .bottom)
                .scrollEdgeEffectStyle(.soft, for: .vertical)
                .scrollTargetBehavior(.paging)
                .scrollIndicators(.hidden, axes: .vertical)
                .ignoresSafeArea()
            }
        }
        .safeAreaPadding(.all)
        
    }
    
}



