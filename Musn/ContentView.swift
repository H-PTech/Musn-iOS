//
//  ContentView.swift
//  Musn
//
//  Created by 권민재 on 12/15/24.
//

import SwiftUI

enum Tab {
    case home
    case profile
    case search
}


struct ContentView: View {
    @State private var selectedTab: Tab = .home
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        NavigationStack {
            VStack {
                switch selectedTab {
                case .home:
                    HomeView()
                        .navigationBarTitle(locationManager.currentAddress, displayMode: .inline)
                case .profile:
                    ReelsPagingView()
                case .search:
                    SearchView()
                }

                CustomTabView(selectedTab: $selectedTab)
                    .frame(height: 50)
            }
        }
        .environmentObject(locationManager)
    }
}


#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
