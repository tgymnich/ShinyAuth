//
//  IconView.swift
//  ShinyAuth
//
//  Created by Tim Gymnich on 21.8.20.
//

import SwiftUI
import CommonCrypto

struct IconView: View {
    @State var text: String = ""
    var angle: Angle {
        // map a string to a color (hue rotation)
        guard let data = text.data(using: .utf8) else { return Angle.zero }
        var digest = [UInt8](repeating: 0, count: 32)

        data.withUnsafeBytes {
             _ = CC_SHA256($0.baseAddress, UInt32(data.count), &digest)
        }

        var result = digest.reduce(1.0) { $0 * Double($1) }.truncatingRemainder(dividingBy: 360)

        // cut out orange
        switch result {
        case 35..<55: result = 35
        case 55...75: result = 75
        default: break
        }

        return Angle(degrees: result)
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.red)
                .hueRotation(angle)
            Text(text.prefix(2))
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
