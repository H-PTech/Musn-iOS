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
        ZStack(alignment: .bottom) {
            HStack {
                Spacer()
                
                Button {
                    selectedTab = .home
                } label: {
                    VStack {
                        Image(systemName: "house.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(selectedTab == .home ? .blue : .gray)
                        Text("Home")
                            .font(.caption)
                            .foregroundStyle(selectedTab == .home ? .blue : .gray)
                    }
                }
                
                Spacer()
                
                Button {

                } label: {
                    ZStack {
                        Circle()
                            .foregroundStyle(Color.blue.opacity(0.8))
                            .frame(width: 70, height: 70)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                    }
                    .offset(y: -20)
                }
                
                Spacer()
                
                Button {
                    selectedTab = .profile
                } label: {
                    VStack {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(selectedTab == .profile ? .blue : .gray)
                        Text("Profile")
                            .font(.caption)
                            .foregroundStyle(selectedTab == .profile ? .blue : .gray)
                    }
                }
                
                Spacer()
            }
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.8))
                    .ignoresSafeArea(edges: .bottom)
            )
            .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: -3)
        }
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabView(selectedTab: .constant(.home))
    }
    .background(Color.black)
    .preferredColorScheme(.dark) 
}
