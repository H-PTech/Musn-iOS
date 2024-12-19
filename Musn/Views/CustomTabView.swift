//
//  CustomTabView.swift
//  Musn
//
//  Created by 권민재 on 12/15/24.
//
import SwiftUI

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
                            .foregroundStyle(selectedTab == .home ? .green : .gray)
                        Text("Home")
                            .font(.caption)
                            .foregroundStyle(selectedTab == .home ? .green : .gray)
                    }
                }

                Spacer()

                ZStack {
                    if isExpanded {
                        // Music Button
                        Button {
                            // Handle Music Action
                            isExpanded = false
                        } label: {
                            ZStack {
                                Circle()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.green)
                                Image(systemName: "music.note")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 20)
                            }
                            .offset(x: -70, y: -70)
                        }

                        // Video Button
                        Button {
                            // Handle Video Action
                            isExpanded = false
                        } label: {
                            ZStack {
                                Circle()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.green)
                                Image(systemName: "video.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 20)
                            }
                            .offset(x: 70, y: -70)
                        }
                    }

                    // Plus Button with rotation effect
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                            isExpanded.toggle()
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .foregroundStyle(Color.green.opacity(0.8))
                                .frame(width: 70, height: 70)
                                .shadow(color: .green.opacity(0.5), radius: 10, x: 0, y: 3)
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .rotationEffect(.degrees(isExpanded ? 45 : 0)) // Rotate when expanded
                        }
                        .offset(y: -20)
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
                            .foregroundStyle(selectedTab == .profile ? .green : .gray)
                        Text("Video")
                            .font(.caption)
                            .foregroundStyle(selectedTab == .profile ? .green : .gray)
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
