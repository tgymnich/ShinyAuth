//
//  ScannerView.swift
//  ShinyAuth-iOS
//
//  Created by Tim Gymnich on 7/5/19.
//

import SwiftUI

struct ScannerView: View {
    @Binding var activeSheet: SheetKind?

    var body: some View {
        ZStack {
            ScannerViewController()
            HStack {
                Spacer()
                VStack {
                    CircularButton(systemName: "xmark")
                        .padding(.all, 10)
                        .onTapGesture {
                            activeSheet = nil
                        }
                    Spacer()
                }
            }
        }
    }
}

struct PageView_Preview: PreviewProvider {
    static var previews: some View {
        ScannerView(activeSheet: .constant(.scan))
    }
}
