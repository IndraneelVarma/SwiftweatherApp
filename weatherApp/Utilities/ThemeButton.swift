//
//  MyButton.swift
//  weatherApp
//
//  Created by Indraneel Varma on 17/06/24.
//

import Foundation
import SwiftUI

struct ThemeButton: View {
    var title: String
    var textColor: Color
    var backgroundColor: Color
    @Binding var isNight: Bool
    var body: some View {
        Button{
            print(isNight)
            isNight.toggle()
            } label: {
            Text(title)
                .frame(width: 250, height: 50)
                .foregroundColor(textColor)
                .background(backgroundColor)
                .font(.system(size: 20,weight: .bold))
                .cornerRadius(10)
        }
    }
}


