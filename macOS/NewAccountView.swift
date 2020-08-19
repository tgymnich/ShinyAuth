//
//  NewAccountView.swift
//  macOS
//
//  Created by Tim Gymnich on 19.08.20.
//

import SwiftUI

struct NewAccountView: View {
    @Binding var showNewAccount: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("URL")
            TextField("URL", text: .constant(""))
            Spacer()
            HStack {
                Spacer()
                Button(action: { showNewAccount = false }, label: {
                    Text("Cancel")
                })
                Button(action: { showNewAccount = false }, label: {
                    Text("OK")
                })
            }
        }
        .padding()
        .frame(width: 300, height: 200, alignment: .center)
    }
}

struct NewAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NewAccountView(showNewAccount: .constant(true))
    }
}
