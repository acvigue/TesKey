// DisconnectedView.swift
//  TesKey Watch App
//
//  Created by aiden on 11/15/23.
//  
//

import SwiftUI

struct DisconnectedView: View {
    @EnvironmentObject public var bm: BluetoothManager
    @State private var isPresentingConfirm: Bool = false
    
    var body: some View {
        VStack {
            Text("Disconnected")
                .font(.title3)
            Spacer()
                .frame(height: 10)
            Button(action: { bm.attemptConnection() }, label: {
                Text("Reconnect")
            })
            Spacer()
                .frame(height: 10)
            Button(role: .destructive, action: {  isPresentingConfirm = true }, label: {
                Text("Unpair")
            })
            .confirmationDialog("Are you sure?",
              isPresented: $isPresentingConfirm) {
                Button("Yes, unpair", role: .destructive, action: { bm.unpair() })
             }
        }
    }
}

#if DEBUG
struct DisconnectedView_Previews : PreviewProvider {
    static let myEnvObject = BluetoothManager()
    static var previews: some View {
        DisconnectedView().environmentObject(myEnvObject)
    }

}
#endif
