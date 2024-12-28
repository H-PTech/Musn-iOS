//
//  ContentView.swift
//  Musn
//
//  Created by 권민재 on 12/15/24.
//

import SwiftUI


struct ContentView: View {
    @State private var selectedTab: Tab = .home
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        NavigationStack {
            VStack {
                switch selectedTab {
                case .home:
                    HomeView()
                case .video:
                    ReelsPagingView()
                case .dropMusic:
                    SearchView()
                case .dropVideo:
                    VideoDropView()
                }

                CustomTabView(selectedTab: $selectedTab)
                    .frame(height: 50)
                    .zIndex(1)
            }
        }
        .environmentObject(locationManager)
    }
}


#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
