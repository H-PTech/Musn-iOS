//
//  Song.swift
//  Musn
//
//  Created by 권민재 on 12/21/24.
//
import Foundation
import MusicKit


struct Song: Identifiable, Codable {
    let id: String
    let title: String
    let artistName: String
    let artworkURL: String?
    
    
    //preview 테스트
    init(id: String, title: String, artistName: String, artworkURL: String? = nil) {
        self.id = id
        self.title = title
        self.artistName = artistName
        self.artworkURL = artworkURL
    }

    
    init(from musicSong: MusicKit.Song) {
        self.id = musicSong.id.rawValue
        self.title = musicSong.title
        self.artistName = musicSong.artistName
        self.artworkURL = musicSong.artwork?.url(width: 100, height: 100)?.absoluteString
    }
    
    
    
}
