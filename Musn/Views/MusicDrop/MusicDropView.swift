//
//  MusicDropView.swift
//  Musn
//
//  Created by 권민재 on 12/28/24.
//

import SwiftUI

struct MusicDropView: View {
    let song: Song
    @State private var contentDescription: String = ""
    @State private var location: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                if let artworkURL = song.artworkURL, let url = URL(string: artworkURL) {
                   
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .cornerRadius(8)
                    } placeholder: {
                        Color.gray
                            .frame(width: 50, height: 50)
                            .cornerRadius(8)
                    }
                } else {
                    Color.gray
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)
                }
                
                VStack(alignment: .leading) {
                    Text(song.title)
                        .font(.headline)
                    Text(song.artistName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(song.artworkURL ?? "없음")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding()
            
            // 등록 내용 입력
            TextField("드롭에 대한 내용을 입력하세요.", text: $contentDescription)
                .padding()
                .background(Color(white: 0.15))
                .cornerRadius(10)
            
            TextField("위치를 입력하세요.", text: $location)
                .padding()
                .background(Color(white: 0.15))
                .cornerRadius(10)
            
            // 등록 버튼
            Button(action: {
                handleRegistration()
            }) {
                Text("Register Music Drop")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color.black.ignoresSafeArea())
    }
    
    private func handleRegistration() {
        print("곡 등록: \(song.title) - \(song.artistName)")
        print("내용: \(contentDescription)")
        print("위치: \(location)")
    }
}
