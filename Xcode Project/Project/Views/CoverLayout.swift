//
//  CoverLayout.swift
//  BikBok
//
//  Created by Omar Abu Sharar on 8/23/25.
//

import SwiftUI

// A reusable layout for displaying a book cover with header and footer text
struct CoverLayout: View {
    var header: String = ""
    var footer: String = ""
    var book: Book?
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                if let gradient = book?.gradient {
                    RoundedRectangle(cornerRadius: 36)
                        .fill(gradient.opacity(0.45))
                        .blur(radius: 5)
                        .padding(4)
                        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 36))
                }
                RoundedRectangle(cornerRadius: 36)
                    .foregroundStyle(.clear)
                    .glassEffect(.clear, in: AnyShape(RoundedRectangle(cornerRadius: 36)))
                VStack(alignment: .leading) {
                    HStack {
                        Text(book == nil ? header : book!.title)
                            .font(.system(size: 60))
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                        Spacer()
                    }
                    Spacer()
                    if let book = book {
                        Text("\(book.pages.count) Pages")
                            .font(.headline)
                            .foregroundStyle(Color(book.colors.last ?? "blue"))
                    } else {
                        Text(footer)
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(15)
                .padding(.vertical)
            }
            .padding()
            .padding(.top, 45)
            .containerRelativeFrame(.vertical, count: 15, span: 14, spacing: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .containerRelativeFrame(.vertical, count: 1, spacing: 0)
    }
}
