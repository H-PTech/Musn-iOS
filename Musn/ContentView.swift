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
    
    
    var body: some View {
        VStack {
            switch selectedTab {
            case .home:
                NavigationView {
                    HomeView()
                }
            case .profile:
                NavigationView {
                    ReelsPagingView()
                }
            case .search:
                NavigationView {
                    SearchView()
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
