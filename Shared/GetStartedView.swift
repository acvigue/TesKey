//
//  ContentView.swift
//  TesKey Watch App
//
//  Created by aiden on November 14, 2023.
//

import SwiftUI

struct GetStartedView: View {
    @EnvironmentObject public var bm: BluetoothManager
    
    var body: some View {
        VStack(alignment: .center) {
            Text("TesKey")
                .font(.title2)
            Spacer()
            Text("Unlock and control your vehicle on the go")
                .font(.footnote)
                .multilineTextAlignment(.center)
            Spacer()
            Button(action: bm.startDiscovery, label: {
                Text("Get Started")
            })
        }
        .padding()
    }
}

#if DEBUG
struct GetStartedView_Previews : PreviewProvider {
    static var previews: some View {
        GetStartedView()
    }

}
#endif
