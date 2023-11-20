// ConnectedView.swift
//  TesKey
//
//  Created by aiden on 11/17/23.
//  
//

import SwiftUI

struct AddingKeyView: View {
    @EnvironmentObject var vehicle: Vehicle
    
    var body: some View {
        VStack {
            Text("Pairing request sent")
                .font(.headline)
                .multilineTextAlignment(.center)
            Spacer()
            Text("Tap an existing key to the center console")
                .font(.caption)
                .multilineTextAlignment(.center)
            Spacer()
            ProgressView()
            Button("Cancel", role: .destructive, action: vehicle.requestAuthorization)
        }
    }
}

struct UnauthorizedView: View {
    @EnvironmentObject public var vehicle: Vehicle
    @EnvironmentObject var bm: BluetoothManager
    
    var body: some View {
        VStack {
            Text("WatchKey Not Added to Vehicle")
                .font(.headline)
                .multilineTextAlignment(.center)
            Spacer()
            Button("Add Key", action: vehicle.requestAddKey)
            Button("Disconnect", role: .destructive, action: bm.disconnect)
        }
    }
}

struct ControllableView: View {
    @EnvironmentObject public var vehicle: Vehicle
    
    var body: some View {
        Text("Controllable")
    }
}

struct ConnectedView: View {
    @EnvironmentObject public var vehicle: Vehicle
    @EnvironmentObject public var bm: BluetoothManager
    
    var body: some View {
        switch(vehicle.vehicleAppState) {
        case .enumerating: ConnectingView()
        case .not_authenticated: 
            UnauthorizedView()
                .environmentObject(vehicle)
                .environmentObject(bm)
        case .adding_key:
            AddingKeyView()
                .environmentObject(vehicle)
        case .controllable: Text("Controllable!")
        }
    }
}

#if DEBUG
struct ConnectedView_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            ControllableView()
        }
    }

}
#endif
