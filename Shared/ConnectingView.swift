// ConnectingView.swift
//  TesKey Watch App
//
//  Created by aiden on 11/15/23.
//  
//

import SwiftUI

struct ConnectingView: View {
    var body: some View {
        VStack {
            Text("Connecting")
                .font(.title3)
            Spacer()
                .frame(height: 10)
            ProgressView()
        }
    }
}

#if DEBUG
struct ConnectingView_Preview : PreviewProvider {
    static var previews: some View {
        ConnectingView()
    }

}
#endif
