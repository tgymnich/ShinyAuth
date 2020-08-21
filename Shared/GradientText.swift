//
//  GradientText.swift
//  ShinyAuth
//
//  Created by Tim Gymnich on 28.6.20.
//

import SwiftUI

struct GradientText: View {
    let text: String
    let colors: [Color]
    let progress: CGFloat
    let kerning: CGFloat

    init(_ text: String, colors: [Color], progress: CGFloat, kerning: CGFloat = 0.0) {
        self.text = text
        self.colors = colors
        self.progress = progress
        self.kerning = kerning
    }

    var body: some View {
        Text(text)
            .kerning(kerning)
            .foregroundColor(.clear)
            .background(LinearGradient(gradient: Gradient(colors: colors), startPoint: UnitPoint(x: progress, y: 1), endPoint: UnitPoint(x: 1, y: 1)))
            .mask(Text(text).kerning(kerning))
    }
}

struct GradientText_Previews: PreviewProvider {
    static var previews: some View {
        GradientText("Hello World", colors: [.green, .blue], progress: -1)
            .font(.title)
    }
}
