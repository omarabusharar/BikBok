//
//  AdFormats.swift
//  BikBok
//
//  Created by Omar Abu Sharar on 8/30/25.
//

import Foundation
import SwiftUI


struct AF_BigSmall: View {
    var big: String
    var slogan: String? = nil
    var small: String
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    Text(big)
                        .fontWeight(.bold)
                        .font(.system(size: 60))
                    Spacer()
                }
                if let slogan = slogan {
                    Text(slogan)
                        .font(.system(size: 40))
                }
            }
              
                .minimumScaleFactor(0.4)
               
            Spacer()
            
            Text(small)
                .minimumScaleFactor(0.4)
                
        }
    }
}


struct AF_SmallBig: View {
    var big: String
    var slogan: String? = nil
    var small: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(small)
                
            Spacer()
            
            VStack(alignment: .leading) {
                HStack {
                    Text(big)
                        .fontWeight(.bold)
                    Spacer()
                }
                if let slogan = slogan {
                    Text(slogan)
                }
            }
            .font(.system(size: 60))
          
                
        }
    }
}

struct AF_AllThree: View {
    var name: String
    var slogan: String
    var message: String
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(name)
                    .font(.system(size: 60))
                    .fontWeight(.bold)
                Spacer()
            }
        
            Text(slogan)
                .font(.system(size: 40))
            
            Spacer()
            Text(message)
                .font(.body)
                .minimumScaleFactor(0.4)
               
        }
    }
}

struct AF_Balanced: View {
    var name: String
    var message: String
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(name)
                    .font(.system(size: 60))
                    .fontWeight(.bold)
                Spacer()
            }
            
            Spacer()
            Text(message)
                .font(.system(size: 40))
                .minimumScaleFactor(0.4)
        }
    }
}

