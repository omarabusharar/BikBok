//
//  GenerableComments.swift
//  BiikBook
//
//  Created by Omar Abu Sharar on 8/22/25.
//

import Foundation
import FoundationModels
import SwiftUI
import Combine

// Commenter model
struct CommentUser: Equatable {
    var name: String {
        return comment.name
    }
    
    // false if user, true if bot
    var replies: [(Bool, String)]
    var comment: Commenter
    
    
    var actualColor: [String] = Array<String>(potientialColors.shuffled().prefix(2))
    
    func colors() -> [Color] {
        return actualColor.map { Color($0) }
    }
    
    static func ==(lhs: CommentUser, rhs: CommentUser) -> Bool {
        return lhs.name == rhs.name && lhs.comment.thought == rhs.comment.thought
    }
    
    static func hash(into hasher: inout Hasher, commentUser: CommentUser) {
        hasher.combine(commentUser.name)
        hasher.combine(commentUser.comment.thought)
    }
}

// Generative elements for comments
@Generable
struct Commenter: Equatable {
    
    @Guide(description: "A username similar to Twitter or Instagram handles.")
    var name: String
    
    @Guide(description: "A brief thought regarding the book. Concise and around a sentence long.")
    var thought: String

    
}

// Thought model containing all commenters for a page
struct Thought:  Equatable {
    
    var users: [CommentUser]
    var thoughts: [String] {
        users.map({$0.comment}).map({ $0.thought })
    }
    var usernames:[String] {
        users.map({$0.comment}).map({ $0.name })
    }

}

// Thought thinker to manage and generate thoughts, including replies
class ThoughtThinker: ObservableObject {
   
    @Published var thought: Thought = Thought(users: [])
    
    var thoughtCount: Int {
        thought.users.count
    }
    var lessThanTen: Bool {
        thoughtCount < 10
    }
    
    // Generate a reply to a given user's comment based on the content of the page
    func respond(_ user: CommentUser, page: Page) async -> (Bool, String) {
        let session = LanguageModelSession(instructions:  """
              Your response should be a brief thought, usually one sentence, and should be a very brief 8 word reaction to the previous comment. It can be funny, insightful, or just a simple reaction. It should not be overly positive or negative. It should be neutral and objective. Do not repeat the previous knowledge, use it as a reference.
            """)
        if session.isResponding == false {
            var previousKnowledge: String {
                return user.comment.thought
            }
            var pagePreview: String {
                let words = page.content.split(separator: " ").prefix(30).joined(separator: " ")
                return words
            }
            var comment: String {
                if let lastBotReply = user.replies.last(where: {
                    $0.0 == false
                }) {
                    return lastBotReply.1
                }
                return "No comment provided."
            }
            do {
                let response =  try await session.respond(to: Prompt("User's Comment: \(comment). Your previous comment: \(previousKnowledge). Page content: \(pagePreview). Respond in line with your previous comment as well with your knowledge of the story."))
                return (true, response.content)
            } catch {
               print("Error generating reply: \(error.localizedDescription)")
            }
            
           
          
        }
        return (true, "That's interesting!")
        
    }
    
    // Generate a new thought for a given book and text
    func think(book: Book, text: String) async -> Void {
        let session = LanguageModelSession(instructions:  """
                Thoughts are usually not more than one sentence. They are usually a very brief 8 word reaction to text. They can be funny, insightful, or just a simple reaction. They should not be generic or vague. They should be specific to the text provided. They should not be questions. They should not be longer than 20 words. They should not reference the author or the reader. They should not be overly positive or negative. They should be neutral and objective.
            """)
        print("thinking")
     
        // limit text to 50 words
        let words = text.split(separator: " ").prefix(50).joined(separator: " ")
        var response: Commenter = Commenter(name: "", thought: "")
        let prompt = "Make a unique username. React to the following content from \(book.title): " + words
      
            if session.isResponding == false {
                do {
                  
                    while response.thought.isEmpty {
                        if !session.isResponding {
                            print("generating comment...")
                            let respond = try await session.respond(to: prompt, generating: Commenter.self).content
                            print(respond)
                            
                            if thought.thoughts.contains(respond.thought) || thought.usernames.contains(respond.name) {
                                print("duplicate comment, regenerating...")
                                continue
                            } else {
                                response = respond
                                thought.users.append(CommentUser( replies: [], comment: response))
                                print("Comment Added. Total Comments: \(thoughtCount)")
                            }
                        }
                    }
                } catch {
                    print("Error generating comment: \(error.localizedDescription)")
                    
                    // try again on failure
                    if lessThanTen {
                        await think(book: book, text: text)
                    }
                }
            }
        
    }

}
