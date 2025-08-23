# BikBok
What if TikTok was for Books and had people instead of AI? (iOS 26, SwiftUI, Foundation Models)

## Thought Process
People these days don't read and mainly spend their time on short-form social media, such as Instagram, TikTok, or YouTube Shorts. This has lead to less people reading. If we combine the mechanisms of TikTok, with the power of books, can we solve this problem?

## Preview

| Home   | Book Cover | Thoughts   | Reading |
| ------------- | ------------- | ------------- | ------------- |
| <img width="645" height="1398" alt="IMG_7885" src="https://github.com/user-attachments/assets/e4e5a13f-7e0c-420f-b1df-7045f8828780" />  | <img width="645" height="1398" alt="IMG_7875" src="https://github.com/user-attachments/assets/9aaf9165-ccd9-4501-a3d6-f2005e7da135" />  | <img width="645" height="1398" alt="IMG_7881" src="https://github.com/user-attachments/assets/f6001b7b-c43c-4034-ac0e-b619c0d4ae9a" /> | <img width="645" height="1398" alt="IMG_7878" src="https://github.com/user-attachments/assets/efa3cec2-5bf8-4a2c-862d-71020871774e" /> |





## Frameworks Used 
Attempted to take advantage of new iOS 26 APIs.
- Swift
- SwiftUI
- SwiftData
- Foundation Models API
- Combine
- Observable Object (seperating generation logic from views to a degree)

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
- User can reply to these comments, and in turn the GenAI can reply to them.

## Personal Notes
- Finished this project in two days with a couple of breaks in between
- Nice change of pace, explored APIs
