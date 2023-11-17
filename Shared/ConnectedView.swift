// ConnectedView.swift
//  TesKey
//
//  Created by aiden on 11/17/23.
//  
//

import SwiftUI

struct ConnectedView: View {
    @EnvironmentObject public var vehicle: Vehicle
    
    var body: some View {
        switch(vehicle.vehicleAppState) {
        case .enumerating: ConnectingView()
        case .not_authenticated: 
            VStack {
                Text("Not Authorized")
                Button("add key", action: vehicle.requestAddKey)
            }
        case .controllable: Text("Controllable!")
        }
    }
}
