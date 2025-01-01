//
//  CustomTabView.swift
//  Musn
//
//  Created by 권민재 on 12/15/24.
//
import SwiftUI

enum Tab {
    case home
    case video
    case dropMusic
    case dropVideo
}

extension ShapeStyle where Self == Color {
    static var neonGreen: Color {
        Color.green.opacity(0.95)
    }
}

struct CustomTabView: View {
    @Binding var selectedTab: Tab
    @State private var isExpanded = false

    var body: some View {
        ZStack(alignment: .bottom) {
            HStack {
                Spacer()

                Button {
                    print("Home tapped")
                    selectedTab = .home
                } label: {
                    VStack {
                        Image(systemName: "house.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(selectedTab == .home ? .neonGreen : .white)
                        Text("Home")
                            .font(.caption)
                            .foregroundStyle(selectedTab == .home ? .neonGreen : .white)
                    }
                }

                
                Spacer()
                Spacer()
                Spacer()

                // Video Button
                Button {
                    print("Video tab tapped")
                    selectedTab = .video
                } label: {
                    VStack {
                        Image(systemName: "video.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(selectedTab == .video ? .neonGreen : .white)
                        Text("Video")
                            .font(.caption)
                            .foregroundStyle(selectedTab == .video ? .neonGreen : .white)
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
            .shadow(color: .black.opacity(0.6), radius: 5, x: 0, y: -3)

            ZStack {
                if isExpanded {
                    Button {
                        print("Music tapped")
                        selectedTab = .dropMusic
                        withAnimation {
                            isExpanded = false
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(.neonGreen)
                                .shadow(color: .neonGreen.opacity(0.6), radius: 10, x: 0, y: 3)
                            Image(systemName: "music.note")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                        }
                    }
                    .offset(x: -70, y: -70)

                    Button {
                        print("Video tapped")
                        selectedTab = .dropVideo
                        withAnimation {
                            isExpanded = false
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(.neonGreen)
                                .shadow(color: .neonGreen.opacity(0.6), radius: 10, x: 0, y: 3)
                            Image(systemName: "video.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                        }
                    }
                    .offset(x: 70, y: -70)
                }

                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        isExpanded.toggle()
                    }
                } label: {
                    ZStack {
                        Circle()
                            .foregroundStyle(.neonGreen)
                            .frame(width: 70, height: 70)
                            .shadow(color: .neonGreen.opacity(0.8), radius: 15, x: 0, y: 5)


                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                            .rotationEffect(.degrees(isExpanded ? 135 : 0)) // +에서 x로 변경
                            .animation(.easeInOut(duration: 0.3), value: isExpanded)
                    }
                    .offset(y: -20)
                }
            }
        }
    }
}
