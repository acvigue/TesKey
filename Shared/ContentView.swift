// ContentView.swift
//  TesKey Watch App
//
//  Created by aiden on 11/15/23.
//  
//

import SwiftUI

struct ContentView: View {
    @StateObject var bluetoothManager = BluetoothManager()
    
    var body: some View {
        switch(bluetoothManager.state) {
        case .not_setup:
            GetStartedView().environmentObject(bluetoothManager)
        case .discovering:
            DiscoveryView().environmentObject(bluetoothManager)
        case .disconnected:
            DisconnectedView().environmentObject(bluetoothManager)
        case .connecting:
            ConnectingView()
        case .powered_off:
            Text("Bluetooth off!")
                .font(.title3)
        case .bt_unauthorized:
            Text("Bluetooth unauthorized!")
                .font(.title3)
        case .bt_unavailable:
            Text("Bluetooth unavailable!")
                .font(.title3)
        case .connect_failed:
            ConnectFailedView().environmentObject(bluetoothManager)
        case .connected:
            ConnectedView()
                .environmentObject(bluetoothManager.teslaPeripheral!)
                .environmentObject(bluetoothManager)
        }
        
    }
}

#Preview {
    ContentView()
}
