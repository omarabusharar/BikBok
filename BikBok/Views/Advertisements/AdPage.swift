//
//  AdPage.swift
//  BikBok
//
//  Created by Omar Abu Sharar on 8/30/25.
//

import SwiftUI
import FoundationModels

struct AdPage: View {
    let session = LanguageModelSession(instructions:  """
          Your task is to generate a short advertisement for a fictional product, service, or buisness. The advertisement should be engaging, concise, and tailored to the target audience. 
        """)
    @State private var advertisement: Advertisement?
    var timerAlignment: Alignment {
        switch advertisement?.format {
        case .bigNameSmallSlogan, .smallNameBigSlogan, .bigMessageSmallNameSlogan:
            return .topTrailing
        case .smallMessageBigNameSlogan, .companyBalanced, .allThree:
            return .bottomTrailing
        case .none:
            return .bottomTrailing
        }
    }
    @Binding var disableScroll: Bool
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                if let gradient = advertisement?.gradient {
                    RoundedRectangle(cornerRadius: 36)
                        .fill(gradient.opacity(0.45))
                        .blur(radius: 5)
                        .padding(4)
                        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 36))
                }
                RoundedRectangle(cornerRadius: 36)
                    .foregroundStyle(.clear)
                    .glassEffect(.clear, in: AnyShape(RoundedRectangle(cornerRadius: 36)))
                   
                Group {
                    if let ad = advertisement {
                        Group {
                            switch advertisement?.format {
                            case .bigNameSmallSlogan:
                                AF_BigSmall(big: ad.content.name, small: ad.content.slogan)
                            case .smallNameBigSlogan:
                                AF_SmallBig(big: ad.content.slogan, small: ad.content.name)
                            case .companyBalanced:
                                AF_Balanced(name: ad.content.name, message: ad.content.message)
                            case .allThree:
                                AF_AllThree(name: ad.content.name, slogan: ad.content.slogan, message: ad.content.message)
                            case .bigMessageSmallNameSlogan:
                                AF_BigSmall(big: ad.content.name, slogan: ad.content.slogan, small: ad.content.message)
                            case .smallMessageBigNameSlogan:
                                AF_SmallBig(big: ad.content.name, slogan: ad.content.slogan, small: ad.content.message)
                            case nil:
                                ProgressView("Loading...")
                            }
                        }
                        
                    } else {
                        ProgressView("Loading...")
                            .onAppear {
                               
                                Task {
                                    do {
                                        let response = try await session.respond(to: "go fully random. Make an ad across a variety of services, including non eco friendly ones. do not stick to the same or similar names.", generating: AdvertisementContent.self)
                                        DispatchQueue.main.async {
                                            self.advertisement = Advertisement(content: response.content)
                                        }
                                    } catch {
                                        print("Error generating advertisement: \(error)")
                                    }
                                }
                            }
                           
                    }
                }
                .overlay(alignment: timerAlignment, content: {
                    if let length = advertisement?.timerLength {
                        AdTimer(length: length, color: .primary, onComplete: {
                           disableScroll = false
                        })
                       
                    }
                })
                .padding(15)
                .padding(.vertical)
            }
            .padding()
            .padding(.top, 45)
            .containerRelativeFrame(.vertical, count: 15, span: 14, spacing: 0)
            .contentShape(.rect)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .containerRelativeFrame(.vertical, count: 1, spacing: 0)
       
    }
}


