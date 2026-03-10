//
//  CommentsSheet.swift
//  BiikBook
//
//  Created by Omar Abu Sharar on 8/22/25.
//

import SwiftUI
import FoundationModels

// Sheet which shows thoughts on a page
struct ThoughtsSheet: View {
    @StateObject var thinker = ThoughtThinker()
    @Environment(\.dismiss) private var dismiss
    var book: Book

    let session = LanguageModelSession(instructions:  """
            Thoughts are usually not more than one sentence. They are usually a very brief 8 word reaction to text. They can be funny, insightful, or just a simple reaction. They should not be generic or vague. They should be specific to the text provided. They should not be questions. They should not be longer than 20 words. They should not reference the author or the reader. They should not be overly positive or negative. They should be neutral and objective.
        """)
    
    var page: Page
    
    var count: Int {
        thinker.thoughtCount
    }

    var body: some View {
        NavigationStack {
            if count < 3 {
                ProgressView(count == 1 ? "1 Thought" : "\(count) Thoughts")
                    .containerRelativeFrame(.vertical)
                    .containerRelativeFrame(.horizontal)
                    .overlay(alignment: .bottom) {
                    Text("Thoughts take a while to generate due to safety guardrails. Please use the feature with caution. Thoughts are AI-generated and do not reflect real opinions.")
                            .font(.footnote)
                            .foregroundStyle(.tertiary)
                            .padding()
                            .glassEffect(.regular, in: AnyShape(RoundedRectangle(cornerRadius: 16)))
                            .padding(.horizontal)
                        
                }
            } else {
                List {
                    ForEach($thinker.thought.users, id: \.name) { $user in
                        withAnimation(.snappy) {
                            ThoughtCell(thinker: thinker, page: page, user: $user)
                                
                        }
                    }
                }
                .animation(.bouncy.speed(0.5), value: thinker.thought.users)
                .navigationTitle("Thoughts")
                .toolbarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction, content: {
                        Button(role: .cancel, action: {
                            dismiss()
                        
                        })
                    })
                }
            }
        }
        .onAppear {
            if !session.isResponding {
                Task {
                    do {
                        await thinker.think(book: book, text: page.content)
                    }
                }
            }
        }
        .onChange(of: count, {
            if count < 10 {
                Task {
                    do {
                        await thinker.think(book: book, text: page.content)
                    }
                }
            }
        })

        
    }
    
   
}

// Single cell for a thought / comment
struct ThoughtCell: View {
    @ObservedObject var thinker: ThoughtThinker
    var comment: Commenter {
        return user.comment
    }
    var page: Page
    @Binding var user: CommentUser
    var colors: [Color] {
        user.colors()
    }
    @State private var isReplying: Bool = false
    @State private var replyText: String = ""
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 70, height: 60)
         
            VStack(alignment: .leading) {
                HStack {
                    Text(user.name)
                    Spacer()
                    Text("\(Int.random(in: 1..<24)) hours ago")
                        .foregroundStyle(.secondary)
                }
                    .font(.footnote)
                Text(comment.thought)
                    .lineLimit(2, reservesSpace: false)
                if user.replies.isEmpty {
                    HStack {
                        if isReplying {
                            TextField("Reply", text: $replyText)
                                .padding(5)
                                .background {
                                    Capsule()
                                        .foregroundStyle(.thinMaterial)
                                }
                            Button("Send", systemImage: "arrow.up") {
                                withAnimation(.snappy) {
                                    isReplying = false
                                }
                            }
                            .buttonBorderShape(.circle)
                            .buttonStyle(.glassProminent)
                            .labelStyle(.iconOnly)
                        } else {
                            Button("Reply") {
                                withAnimation(.snappy) {
                                    isReplying = true
                                }
                            }
                            
                        }
                    }
                    .buttonStyle(.glass)
                        .font(.footnote)
                        
                }
                ForEach(user.replies, id: \.1, content: {
                    reply in
                    if reply.0 == false {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("You")
                                .font(.footnote)
                                .fontWeight(.bold)
                            Text(reply.1)
                                .font(.footnote)
                        }
                            .padding(8)
                            .padding(.trailing)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(.thinMaterial)
                            }
                    } else {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(comment.name)
                                .font(.footnote)
                                .fontWeight(.bold)
                            Text(reply.1)
                                .font(.footnote)
                                .minimumScaleFactor(0.6)
                        }
                            .padding(8)
                            .padding(.trailing)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(.thinMaterial)
                            }
                    }
                })
               
                }
        }
        .onChange(of: isReplying, {
            
            // When user finishes replying, generate a reply from the thinker
            if isReplying == false && !replyText.isEmpty {
                Task {
                    do {
                        user.replies.append((false, replyText))
                        try await user.replies.append(thinker.respond(user, page: page))
                      
                    }
                }
            }
        })
       
    }
}

