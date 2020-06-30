//
//  CircularButton.swift
//  ShinyAuth
//
//  Created by Tim Gymnich on 30.6.20.
//

import SwiftUI

struct CircularButton: View {
    var systemName = "qrcode.viewfinder"
    var body: some View {
        return HStack {
            Image(systemName: systemName)
                .foregroundColor(.black)
                .imageScale(.large)
        }
        .frame(width: 44, height: 44)
        .background(Color.white)
        .cornerRadius(30)
    }
}

struct CircularButton_Previews: PreviewProvider {
    static var previews: some View {
        CircularButton()
    }
}
