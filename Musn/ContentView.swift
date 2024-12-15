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
}


struct ContentView: View {
    
    @State private var selectedTab: Tab = .home
    
    
    var body: some View {
        VStack {
            switch selectedTab {
            case .home:
                NavigationView {
                    HomeView()
                }
            case .profile:
                NavigationView {
                    ProfileView()
                }
            }
            CustomTabView(selectedTab: $selectedTab)
                .frame(height: 50)
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
