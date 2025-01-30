//
//  MusicDropView.swift
//  Musn
//
//  Created by 권민재 on 12/28/24.
//

import SwiftUI
import Combine

struct LimitedTextEditor: View {
    @Binding var text: String
    let placeholder: String
    let characterLimit: Int
    
    @State private var remainingCharacters: Int
    
    @AppStorage("accessToken") var accessToken: String?
    
    
    
    
    init(text: Binding<String>, placeholder: String, characterLimit: Int) {
        self._text = text
        self.placeholder = placeholder
        self.characterLimit = characterLimit
        self._remainingCharacters = State(initialValue: characterLimit - text.wrappedValue.count)
    }
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 10)
                }
                
                TextEditor(text: $text)
                    .padding(4)
                    .background(Color(white: 0.15))
                    .cornerRadius(10)
                    .frame(height: 100)
                    .foregroundColor(.white)
                    .onChange(of: text) { newValue in
                        if newValue.count > characterLimit {
                            text = String(newValue.prefix(characterLimit))
                        }
                        remainingCharacters = characterLimit - text.count
                    }
            }
            
            // 글자수 표시
            Text("\(remainingCharacters)자 남음")
                .font(.caption)
                .foregroundColor(remainingCharacters < 0 ? .red : .gray)
        }
    }
}

struct MusicDropView: View {
    let song: Song
    @State private var contentDescription: String = ""
    @State private var title: String = ""
    @State private var location: String = ""
    
    var body: some View {
        VStack(spacing: 30) {
            // 상단 메시지
            Text("해당 지역에 음악을\n놓고 가시겠습니까?")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.purple)
                .multilineTextAlignment(.center)
                .padding(.top)
            
            VStack(spacing: 10) {
                if let artworkURL = song.artworkURL, let url = URL(string: artworkURL) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    } placeholder: {
                        Color.gray
                            .frame(width: 150, height: 150)
                            .cornerRadius(12)
                    }
                } else {
                    Color.gray
                        .frame(width: 150, height: 150)
                        .cornerRadius(12)
                }
                
                VStack(alignment: .center, spacing: 5) {
                    Text(song.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Text(song.artistName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            TextField("드랍 제목을 입력하세요",text: $title)
                .padding(8)
                .background(Color(white: 0.15))
                .cornerRadius(10)
                .foregroundColor(.white)
            
            
            LimitedTextEditor(
                text: $contentDescription,
                placeholder: "내용을 입력하세요.",
                characterLimit: 200
            )
                       

            Button(action: {
                handleRegistration()
            }) {
                Text("Register Music Drop")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .cornerRadius(10)
                    .shadow(color: .green.opacity(0.5), radius: 5, x: 0, y: 5)
            }
            .padding(.top, 10)
            
            Spacer()
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
