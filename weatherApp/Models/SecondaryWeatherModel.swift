//
//  WeatherDayView.swift
//  weatherApp
//
//  Created by Indraneel Varma on 21/06/24.
//

import Foundation
import SwiftUI

struct SecondaryWeatherModel: View {
    var day: String
    var image: String
    var temp: Int
    
    var body: some View {
        VStack {
            Text(day)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(.white)
            Image(systemName: image)
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
            Text("\(temp)°")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.white)
        }
    }
}
