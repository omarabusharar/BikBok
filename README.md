# BikBok
What if TikTok was for Books and had people instead of AI? (iOS 26, SwiftUI, Foundation Models)

## Thought Process
People these days don't read and mainly spend their time on short-form social media, such as Instagram, TikTok, or YouTube Shorts. This has lead to less people reading. If we combine the mechanisms of TikTok, with the power of books, can we solve this problem?

## Preview
To Be Added

## Frameworks Used 
Attempted to take advantage of new iOS 26 APIs.
- Swift
- SwiftUI
- SwiftData
- Foundation Models API
- Combine

## Features
### Reading
- Scroll horizontally between books, vertically between pages
- Keep track of where you are at with the bookmark function.
- Liquid Glass cards serve as pages and provide clear hiearchy between sections.
- Interface adapts between light and dark mode while keeping the gradient visible.
### Data
- Imports from .txt files
- Books are stored as SwiftData objects
### Thoughts
- Takes advantage of the new Foundation Models API. (iOS 26+, Apple Inteligence required)
- Each comment takes in a page as context and replies in a concise manner.
- User can reply to these comments, and in turn the robot can reply to them.
