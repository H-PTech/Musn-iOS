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

    // 추천 곡 데이터
    private let recommendedSongs = [
        Song(id: "1", title: "너였다면", artistName: "정승환", artworkURL: nil),
        Song(id: "2", title: "너를 만나", artistName: "폴킴", artworkURL: nil),
        Song(id: "3", title: "거리에서", artistName: "성시경", artworkURL: nil),
        Song(id: "4", title: "헤어지자 말해요", artistName: "박재정", artworkURL: nil),
        Song(id: "5", title: "너를 너를 너를", artistName: "성시경", artworkURL: nil)
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(alignment: .leading) {
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

                    if searchText.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("가끔 너 생각 나는 날에는\n이 노래를 들어")
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding(.horizontal)

                            VStack(spacing: 10) {
                                ForEach(recommendedSongs) { song in
                                    Button(action: {
                                        searchText = song.title
                                        performSearch(query: song.title)
                                    }) {
                                        HStack {
                                            Text("\(song.title)")
                                                .foregroundColor(.white)
                                                .font(.headline)
                                            Spacer()
                                            Text(song.artistName)
                                                .foregroundColor(.gray)
                                                .font(.subheadline)
                                        }
                                        .padding()
                                        .background(Color(white: 0.2))
                                        .cornerRadius(10)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                    }

                    if searchResults.isEmpty {
                        Spacer()
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(searchResults) { song in
                                    NavigationLink(destination: MusicDropView(song: song)) {
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
            .navigationTitle("드랍할 음악 검색")
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


#Preview {
    SearchView()
}
