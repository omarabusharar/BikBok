//
//  PageView.swift
//  BiikBook
//
//  Created by Omar Abu Sharar on 8/22/25.
//

import SwiftUI

// MARK: - Book Page View
struct BookPage: View {
    var page: Page
    var book: Book
    var body: some View {
        HStack(spacing: -55) {
            PageText(text: page.content, number: page.number)
            VStack {
                PageActions(text: page.content, book: book, page: page)
                    .padding(5)
                    .padding(.vertical)
                    .glassEffect()
            }
                .padding(.trailing)
        }
       
    }
}

// MARK: - Page Text
private struct PageText: View {
    var text: String
    var number: Int
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 36)
                    .fill(Color.clear)
                    .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 36))
                VStack {
                    Text(text)
                        .font(.system(size: 20))
                        .padding()
                        .padding(.trailing, 30)
                    Spacer()
                    Text(String(number))
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                        .padding(.bottom)
                }
            }
           
            .padding()
            .padding(.top, 45)
            .containerRelativeFrame(.vertical, count: 15, span: 14, spacing: 0)
        }
        .containerRelativeFrame(.vertical, count: 1, spacing: 0)
        
    }
}

// MARK: - Page Actions
private struct PageActions: View {
    var text: String
    var likeCount = Int.random(in: 4000...100000)
    @State private var isLiked: Bool = false
    @State private var showThoughts: Bool = false
    var book: Book
    var page: Page
    var body: some View {
        VStack(spacing: 20) {
            PageAction(isActive: $isLiked, text: isLiked ? "\(((likeCount + 1)).formatted(.number))" : "\(likeCount.formatted(.number))", icon: "heart", colors: [.red, .pink, .purple], action: {
                withAnimation(.bouncy, {
                    isLiked.toggle()
                })
            })
            PageAction(isActive: $showThoughts, text: "Thoughts", icon: "bubble", colors: [.teal, .blue], action: {
                withAnimation(.bouncy) {
                    showThoughts.toggle()
                }
            })
            .sheet(isPresented: $showThoughts, content: {
                ThoughtsSheet(book: book, page: page)
            })
            PageAction(isActive: .constant(page.number == (book.bookmarkedPage ?? 0)), text: "Bookmark", icon: "bookmark", colors: [.yellow, .orange], action: {
                withAnimation(.bouncy) {
                    if book.bookmarkedPage == page.number {
                        book.bookmarkedPage = 0
                    } else {
                        book.bookmarkedPage = page.number
                    }
                }
            })
        }
    }
}

// MARK: - Individual Page Action
private struct PageAction: View {
    @Binding var isActive: Bool
    
    var text: String = "2,000"
    var icon: String = "heart"
    var colors: [Color] = [Color.red, Color.pink, Color.purple]
    var action: () -> Void = {}
    
    private var gradient: LinearGradient {
        LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    var body: some View {
        VStack(spacing: 7.5) {
            Button(action: {
                action()
            }, label: {
                Image(systemName: icon)
                    .font(.title)
                    .symbolVariant(isActive ? .fill : .none)
            })
            .foregroundStyle(isActive ? gradient : .linearGradient(colors: [.primary], startPoint: .top, endPoint: .bottom))
            .symbolEffect(.bounce, value: isActive)
            Text(text)
                .font(.footnote)
                .foregroundStyle(.primary)
        }
    }
}
