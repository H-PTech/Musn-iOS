//
//  SearchView.swift
//  Musn
//
//  Created by 권민재 on 12/16/24.
//
import SwiftUI
import MusicKit

struct SearchView: View {
    @State private var searchText = ""
    @State private var searchResults: [Song] = []
    @State private var isSearching = false
    @State private var permissionError = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(alignment: .leading) {
                    // 검색 입력
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("드랍할 음악 검색", text: $searchText)
                            .onSubmit {
                                performSearch(query: searchText)
                            }
                            .foregroundColor(.white)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    .padding()
                    .background(Color(white: 0.15))
                    .cornerRadius(10)
                    .padding(.horizontal)

                    if permissionError {
                        Text("Apple Music 권한이 필요합니다.")
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    } else if isSearching {
                        Text("검색 중...")
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                            .padding(.top, 10)
                    } else if searchResults.isEmpty {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("검색 결과가 없습니다😢.\n다른 검색어를 시도해보세요.")
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            Spacer()
                        }
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 10) {
                                // 검색 결과 표시
                                ForEach(searchResults) { song in
                                    NavigationLink(destination: MusicDropRegistrationView(song: song)) {
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
                                                    .foregroundColor(.white)
                                                    .font(.headline)
                                                Text(song.artistName)
                                                    .foregroundColor(.gray)
                                                    .font(.subheadline)
                                            }
                                            Spacer()
                                        }
                                        .padding()
                                        .background(Color(white: 0.2))
                                        .cornerRadius(10)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    await requestMusicAuthorization()
                }
            }
            .navigationTitle("음악 검색")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func performSearch(query: String) {
        guard !query.isEmpty else { return }

        isSearching = true
        Task {
            do {
                let results = try await searchMusic(query: query)
                searchResults = results
            } catch {
                print("검색 오류: \(error.localizedDescription)")
            }
            isSearching = false
        }
    }

    private func searchMusic(query: String) async throws -> [Song] {
        var searchRequest = MusicCatalogSearchRequest(term: query, types: [MusicKit.Song.self])
        searchRequest.limit = 10

        let searchResponse = try await searchRequest.response()
        return searchResponse.songs.map { Song(from: $0) }
    }

    private func requestMusicAuthorization() async {
        let status = await MusicAuthorization.request()
        if status != .authorized {
            permissionError = true
        }
    }
}


// MusicDropRegistrationView: 음악 드롭 등록 뷰
struct MusicDropRegistrationView: View {
    let song: Song
    @State private var contentDescription: String = ""
    @State private var location: String = ""

    var body: some View {
        VStack(spacing: 20) {
            // 곡 정보 표시
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
        .navigationTitle("음악 드롭 등록")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func handleRegistration() {
        print("곡 등록: \(song.title) - \(song.artistName)")
        print("내용: \(contentDescription)")
        print("위치: \(location)")
    }
}

#Preview {
    SearchView()
}
