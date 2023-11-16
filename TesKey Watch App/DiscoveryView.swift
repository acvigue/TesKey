// DiscoveryView.swift
//  TesKey Watch App
//
//  Created by aiden on 11/15/23.
//  
//

import SwiftUI

struct DiscoveryView: View {
    @EnvironmentObject public var bm: BluetoothManager
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Select Vehicle")
                    .font(.title3)
                if(bm.discoveredPeripherals.isEmpty) {
                    Spacer()
                        .frame(height: 20)
                    Text("Searching")
                        .font(.footnote)
                } else {
                    ForEach(bm.discoveredPeripherals, id: \.identifier) { peripheral in
                        Button(action:  {bm.stopDiscovery(peripheral)}, label: {
                            Text(peripheral.name ?? "Unknown")
                        })
                    }
                }
                Spacer()
                    .frame(height: 10)
                ProgressView()
            }
        }
    }
}

#if DEBUG
struct DiscoveryView_Previews : PreviewProvider {
    static let myEnvObject = BluetoothManager()
    static var previews: some View {
        DiscoveryView().environmentObject(myEnvObject)
    }

}
#endif
