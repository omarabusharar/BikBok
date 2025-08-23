//
//  Book.swift
//  BiikBook
//
//  Created by Omar Abu Sharar on 8/22/25.
//

import SwiftUI
import Foundation
import SwiftData


// Book model
@Model
class Book: Identifiable {
    
    // Static properties
    @Attribute(.unique) var id: UUID = UUID()
    var title: String
    var colors: [String]
    var bookmarkedPage: Int? = nil
    @Relationship(deleteRule: .cascade, inverse: \Page.book) var pages: [Page] = []
    
    // Computed properties
    var gradient: LinearGradient {
        let color1 = Color(colors[0])
        let color2 = Color(colors[1])
        return LinearGradient(gradient: Gradient(colors: [color1, color2]), startPoint: .topTrailing, endPoint: .bottomLeading)
    }
    
    // Initializer
    init(title: String, content: String) {
        self.title = title
        self.colors = potientialColors.shuffled().prefix(2).map { String($0) }
        let words = content.split(separator: " ")
        var p: [Page] = []
        for i in stride(from: 0, to: words.count, by: 120) {
            let pageWords = words[i..<min(i + 120, words.count)]
            let page: Page = Page(book: self, content: pageWords.joined(separator: " "), number: p.count + 1)
            p.append(page)
        }
        pages = p
    }
}

// Page Model
@Model
class Page: Identifiable {
    // Static properties
    @Attribute(.unique) var id: UUID = UUID()
    var book: Book
    var content: String
    var number: Int
    
    // Initializer
    init(book: Book, content: String, number: Int) {
        self.book = book
        self.content = content
        self.number = number
    }
}

