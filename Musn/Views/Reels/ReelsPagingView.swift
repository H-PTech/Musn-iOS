//
//  ProfileView.swift
//  Musn
//
//  Created by 권민재 on 12/16/24.
import SwiftUI
import AVKit
import Combine

struct ReelsPagingView: View {
    
    let videoURLs = [
        URL(string: "https://d2asm33oixcd9g.cloudfront.net//musn/KakaoTalk_Video_2024-12-16-21-10-40.mp4")!,
        URL(string: "https://www.w3schools.com/html/movie.mp4")!,
    ]
    
    @State private var currentIndex = 0
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentIndex) {
                ForEach(videoURLs.indices, id: \.self) { index in
                    ReelsVideoPlayer(videoURL: videoURLs[index], isPlaying: currentIndex == index)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    struct ReelsVideoPlayer: View {
        let videoURL: URL
        @State private var player = AVPlayer()
        @State private var cancellable: AnyCancellable?
        let isPlaying: Bool
        
        var body: some View {
            ZStack {
                VideoPlayer(player: player)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .onAppear {
                        if isPlaying {
                            player = AVPlayer(url: videoURL)
                            player.play()
                            player.volume = 0
                            player.actionAtItemEnd = .none
                            cancellable = player.publisher(for: \.timeControlStatus)
                                .sink { status in
                                    if status == .paused {
                                        if let currentItem = player.currentItem,
                                           currentItem.currentTime() >= currentItem.duration {
                                            player.seek(to: .zero)
                                            player.play()
                                        }
                                    }
                                }
                        }
                    }
                    .onDisappear {
                        player.pause()
                        cancellable?.cancel()
                    }
                
                VStack {
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(Color.white)
                            
                            VStack(alignment: .leading) {
                                Text("Heo Inju")
                                    .font(.headline)
                                    .foregroundStyle(Color.white)
                                
                                Text("iOS Developer | Music Lover 🎵")
                                    .font(.subheadline)
                                    .foregroundStyle(Color.gray)
                            }
                            
                            Spacer()
                        }
                    }
                    .padding()
                }
            }
            .background(Color.black)
        }
    }
}

#Preview {
    ReelsPagingView()
}
