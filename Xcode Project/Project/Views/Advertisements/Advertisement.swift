//
//  Advertisement.swift
//  BikBok
//
//  Created by Omar Abu Sharar on 8/30/25.
//

import Foundation
import SwiftUI
import FoundationModels


struct Advertisement {
    var id: UUID = UUID()
    
    var content: AdvertisementContent
    var timerLength: Int = Int.random(in: 5...15)
    let gradient: LinearGradient = {
        let potiential = potientialGradients.randomElement().map({
            let colors = [$0.1, $0.2].map({ Color($0) })
            return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
        })
        return potiential ?? LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
    }()
    let format: AdvertisementFormat = AdvertisementFormat.random()
}

enum AdvertisementFormat {
    case bigNameSmallSlogan
    case smallNameBigSlogan
    case companyBalanced
    case allThree
    case bigMessageSmallNameSlogan
    case smallMessageBigNameSlogan
    
    static func random() -> AdvertisementFormat {
        let allCases = [
            AdvertisementFormat.bigNameSmallSlogan,
            AdvertisementFormat.smallNameBigSlogan,
            AdvertisementFormat.companyBalanced,
            AdvertisementFormat.allThree,
            AdvertisementFormat.bigMessageSmallNameSlogan,
            AdvertisementFormat.smallMessageBigNameSlogan
        ]
        return allCases.randomElement() ?? .companyBalanced
    }
}


@Generable
struct AdvertisementContent {
    var name: String
    var slogan: String
    var message: String
    
}
 
