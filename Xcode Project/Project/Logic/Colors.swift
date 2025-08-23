//
//  Colors.swift
//  BikBok
//
//  Created by Omar Abu Sharar on 8/23/25.
//

import SwiftUI
import Foundation

// List of potiential colors to use for gradients
let potientialColors: [String] = [
    "red", "green", "blue", "yellow", "purple",
    "orange", "pink", "cyan", "indigo", "mint",
    "teal"
]

// Generate all unique pairs of potiential colors for gradients
var potientialGradients: [(Int,String, String)] = {
    var gradients: [(String, String)] = []
    
        for color1 in potientialColors {
            for color2 in potientialColors {
                if color1 != color2 {
                    if gradients.contains(where: { $0 == (color2, color1) }) || gradients.contains(where: { $0 == (color1, color2) }) {
                        continue
                    } else {
                        gradients.append((color1, color2))
                    }
                }
            }
        }
    return gradients.enumerated().map({ ($0.offset, $0.element.0, $0.element.1) })
}()


// Color extension to initialize Color from string names
extension Color {
    init(_ color: String) {
        switch color {
        case "red":
            self = .red
        case "green":
            self = .green
        case "blue":
            self = .blue
        case "yellow":
            self = .yellow
        case "purple":
            self = .purple
        case "orange":
            self = .orange
        case "pink":
            self = .pink
        case "cyan":
            self = .cyan
        case "indigo":
            self = .indigo
        case "mint":
            self = .mint
        case "teal":
            self = .teal
        default:
            self = .primary
        }
    }
}
