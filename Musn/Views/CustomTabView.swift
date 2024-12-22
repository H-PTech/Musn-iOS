//
//  CustomTabView.swift
//  Musn
//
//  Created by 권민재 on 12/15/24.
//
import SwiftUI

extension ShapeStyle where Self == Color {
    static var tonedDownMint: Color {
        Color(red: 0.70, green: 0.62, blue: 0.86) // 톤다운 민트 색상 정의
    }
}

struct CustomTabView: View {
    @Binding var selectedTab: Tab
    @State private var isExpanded = false

    var body: some View {
        ZStack(alignment: .bottom) {
            HStack {
                Spacer()

                // Home Button
                Button {
                    selectedTab = .home
                } label: {
                    VStack {
                        Image(systemName: "house.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(selectedTab == .home ? .tonedDownMint : .gray)
                        Text("Home")
                            .font(.caption)
                            .foregroundStyle(selectedTab == .home ? .tonedDownMint : .gray)
                    }
                }
                Spacer()

                ZStack {
                    if isExpanded {
                        // Music Button
                        Button {
                            print("Music tapped")
                            selectedTab = .search
                            isExpanded = false
                        } label: {
                            ZStack {
                                Circle()
                                    .frame(width: 50, height: 50)
                                    .foregroundStyle(.tonedDownMint)
                                Image(systemName: "music.note")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 20)
                            }
                            .offset(x: -70, y: -70)
                            .zIndex(2)
                            .contentShape(Circle())
                        }

                        // Video Button
                        Button {
                            print("Video tapped")
                            selectedTab = .profile
                            isExpanded = false
                        } label: {
                            ZStack {
                                Circle()
                                    .frame(width: 50, height: 50)
                                    .foregroundStyle(.tonedDownMint)
                                Image(systemName: "video.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 20)
                            }
                            .offset(x: 70, y: -70)
                            .zIndex(2)
                            .contentShape(Circle())
                        }
                    }

                    // Floating Action Button
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                            isExpanded.toggle()
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .foregroundStyle(.tonedDownMint.opacity(0.8))
                                .frame(width: 70, height: 70)
                                .shadow(color: .tonedDownMint.opacity(0.5), radius: 10, x: 0, y: 3)
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .rotationEffect(.degrees(isExpanded ? 45 : 0))
                        }
                        .offset(y: -20)
                        .zIndex(3) // Always on top
                        .contentShape(Circle()) // Ensure touch area matches visual
                    }
                }

                Spacer()

                // Profile Button
                Button {
                    selectedTab = .profile
                } label: {
                    VStack {
                        Image(systemName: "video.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(selectedTab == .profile ? .tonedDownMint : .gray)
                        Text("Video")
                            .font(.caption)
                            .foregroundStyle(selectedTab == .profile ? .tonedDownMint : .gray)
                    }
                }
                Spacer()
            }
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.7))
                    .ignoresSafeArea(edges: .bottom)
            )
            .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: -3)
        }
    }
}


#Preview {
    NavigationStack {
        VStack {
            Spacer()
            CustomTabView(selectedTab: .constant(.home))
        }
        .background(Color.black)
        .preferredColorScheme(.dark)
    }
}
