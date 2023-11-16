// ConnectFailedView.swift
//  TesKey Watch App
//
//  Created by aiden on 11/15/23.
//  
//

import SwiftUI

struct ConnectFailedView: View {
    @EnvironmentObject public var bm: BluetoothManager
    
    var body: some View {
        VStack {
            Text("Connection Failed")
                .font(.title3)
            Spacer()
                .frame(height: 10)
            Button(action: { bm.attemptConnection() }, label: {
                Text("Retry")
            })
        }
    }
}

#if DEBUG
struct ConnectFailedView_Previews : PreviewProvider {
    static let myEnvObject = BluetoothManager()
    static var previews: some View {
        ConnectFailedView().environmentObject(myEnvObject)
    }

}
#endif

