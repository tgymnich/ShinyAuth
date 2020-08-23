//
//  IconView.swift
//  ShinyAuth
//
//  Created by Tim Gymnich on 21.8.20.
//

import SwiftUI

struct IconView: View {

    @State var text: String = ""

    var body: some View {
        ZStack {
            Circle().fill(Color.blue)
                .hueRotation(Angle(degrees: Double.random(in: 0..<360)))
            Text(text)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .font(.title2)
                .minimumScaleFactor(0.1)
        }
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        IconView(text: "GH")
    }
}
