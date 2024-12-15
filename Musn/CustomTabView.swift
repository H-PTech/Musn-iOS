//
//  CustomTabView.swift
//  Musn
//
//  Created by 권민재 on 12/15/24.
//

import SwiftUI

struct CustomTabView: View {
    
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                selectedTab = .home
            } label: {
                Image(systemName: "house.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                Text("Home")
                    .foregroundStyle(.primary)
            }
            Spacer()
            Button {
                
            } label: {
                ZStack {
                    Circle()
                        .foregroundStyle(.white)
                        .frame(width: 80,height: 80)
                        .shadow(radius: 2)
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .foregroundStyle(.primary)
                        .frame(width: 72,height: 72)
                }
                .offset(y: -32)
            }
            Spacer()
            Button {
                selectedTab = .profile
            } label: {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                Text("profile")
                    .foregroundStyle(.primary)
            }
            Spacer()
        }
    }
}

#Preview {
    CustomTabView(selectedTab: .constant(.home))
}
