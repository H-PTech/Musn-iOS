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
            
            Text("해당 지역에 음악을\n 놓고 가시겠습니까?")
                .font(Font.system(size: 20,weight: .bold))
                .foregroundStyle(Color.green)
                
            
                if let artworkURL = song.artworkURL, let url = URL(string: artworkURL) {
                   
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
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
                Spacer()
                VStack(alignment: .leading) {
                    Text(song.title)
                        .font(.headline)
                    Text(song.artistName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            
        
            TextField("드롭에 대한 내용을 입력하세요.", text: $contentDescription)
                .padding()
                .background(Color(white: 0.15))
                .cornerRadius(10)
            
            TextField("위치를 입력하세요.", text: $location)
                .padding()
                .background(Color(white: 0.15))
                .cornerRadius(10)
            
            
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

#Preview {
    let sampleSong = Song(
        id: "1",
        title: "거리에서",
        artistName: "Sung Si Kyung",
        artworkURL: "https://is1-ssl.mzstatic.com/image/thumb/Music124/v4/21/7c/88/217c88ed-80bf-adfa-7cdf-a5c219daf9f7/8809784722939.jpg/100x100bb.jpg"
    )
    MusicDropView(song: sampleSong)
        .preferredColorScheme(.dark)
}
