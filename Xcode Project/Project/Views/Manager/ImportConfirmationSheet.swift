//
//  ImportConfirmationSheet.swift
//  BiikBook
//
//  Created by Omar Abu Sharar on 8/22/25.
//

import SwiftUI
import SwiftData


// MARK: - Confirm and edit individual imported book
struct ImportConfirmationSheet: View {
    @State var book: Book
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var scrollPosition: Int? = -1
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $book.title)
                Section("Colors") {
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal) {
                            LazyHStack {
                                ForEach(potientialGradients, id: \.0) { gradient in
                                    Button {
                                        book.colors = [gradient.1, gradient.2]
                                    } label: {
                                        ICS_ColorOrb(color1: Color(gradient.1), color2: Color(gradient.2))
                                            .overlay {
                                                if book.colors == [gradient.1, gradient.2] {
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .font(.title)
                                                        .foregroundStyle(.white)
                                                        .shadow(radius: 3)
                                                }
                                            }
                                           
                                          
                                           
                                    }
                                    .id(gradient.0)
                                    
                                }
                                
                            }
                            .onAppear(perform: {
                                proxy.scrollTo(potientialGradients.first(where: { $0.1 == book.colors.first && $0.2 == book.colors.last })?.0, anchor: .center)
                            })
                          
                            
                            .scrollTargetLayout()
                        }
                        .scrollPosition(id: $scrollPosition, anchor: .leading)
                       
                      
                 
                        
                    }
                    
                }
                .listRowInsets(.horizontal, .zero)
               
                .scrollIndicators(.hidden)
                Section("Information") {
                    HStack {
                        Text("Pages")
                        Spacer()
                        Text("\(book.pages.count)")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction, content: {
                    Button(role: .cancel, action: {
                        dismiss()
                    })
                })
                ToolbarItem(placement: .primaryAction, content: {
                    Button("Confirm", systemImage: "checkmark", action: {
                        Task {
                            do {
                                modelContext.insert(book)
                                print(modelContext.insertedModelsArray)
                                try modelContext.save()
                            }
                        }
                       
                        dismiss()
                    })
                    .buttonStyle(.glassProminent)
                })
            }
        }
        }
}

// MARK: - Color Orb
private struct ICS_ColorOrb: View {
    var color1: Color
    var color2: Color
    var gradient: LinearGradient {
        LinearGradient(gradient: Gradient(colors: [color1,color2]), startPoint: .topTrailing, endPoint: .bottomLeading)
    }
    var body: some View {
        Image(systemName: "circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(gradient)
            .frame(width: 70, height: 60)
    }
}

