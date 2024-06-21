//
//  MainWeatherView.swift
//  weatherApp
//
//  Created by Indraneel Varma on 21/06/24.
//

import Foundation
import SwiftUI

struct MainWeatherView: View {
    var image: String
    var temp: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: image)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 180, height: 180)
            Text("\(temp)°")
                .font(.system(size: 70, weight: .medium))
                .foregroundStyle(.white)
        }
        .padding(.bottom, 40)
    }
}

