//
//  DescriptionViewController.swift
//  Least.fm
//
//  Created by vivek.aj.sharma on 06/09/20.
//  Copyright © 2020 vivek.aj.sharma. All rights reserved.
//

import UIKit
import AlamofireImage
class DescriptionViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var banerImageView: UIImageView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var albumWikiLabel: UILabel!
    @IBOutlet private weak var waitViewLabel: UILabel!
    
    // MARK: - Variables
    var album: FMAlbum?
    var artist: FMArtist?
    var song: FMSong?
    var viewType: MediaType = .all
    
    private var mediaDetails: [String: Any]?
    
    // MARK: - View lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.waitViewLabel.isHidden = false
        self.setupDetailsView()
    }
    
    
    // MARK: - Private helper methods
    private func setupDetailsView() {
        switch self.viewType {
        case .albums:
            self.title = "Album Info"
            self.fetchAlbumInfo()
            
        case .artists:
            self.title = "Artist Info"
            self.fetchArtistInfo()
            
        case .songs:
            self.title = "Song Info"
            self.fetchSongInfo()
            
        default:
            self.title = "Media Info Not Found"
        }
    }
    
    private func getExploreUrl() -> String? {
        guard let mediaDetails = self.mediaDetails else { return nil }
        
        var mediaKey = ""
        switch self.viewType {
        case .albums:
            mediaKey = "album"
            
        case .artists:
            mediaKey = "artist"
            
        case .songs:
            mediaKey = "track"
            
        default:
            mediaKey = ""
        }
        
        guard let mediaData = mediaDetails[mediaKey] as? [String: Any],
            let urlString = mediaData["url"] as? String else {
                return nil
        }
        
        return urlString
    }
    
    private func setMediaImage(images: [[String: String]]) {
        let imgItems = images.filter { $0["size"] == "extralarge" }
        guard let imgItem = imgItems.first,
            let urlString = imgItem["#text"],
            let url = URL(string: urlString) else {
                return
        }
        
        self.imageView.af_setImage(withURL: url, imageTransition: .curlDown(0.4))
        self.banerImageView.af_setImage(withURL: url, filter: BlurFilter(blurRadius: 20), imageTransition: .crossDissolve(0.4))
    }
    
    // MARK: - Album setup methods
    private func fetchAlbumInfo() {
        guard let album = self.album else { return }
        
        FMAlbumSearch.fetchAlbumInfo(for: album, completionHandler: { response in
            guard let response = response else { return }
            
            if response["error"] != nil {
                self.waitViewLabel.text = response["message"] as? String
                return
            } else {
                self.mediaDetails = response
                self.setupAlbumDetails()
                self.waitViewLabel.isHidden = true
            }
        })
    }
    
    private func setupAlbumDetails() {
        guard let albumDetails = self.mediaDetails?["album"] as? [String: Any] else { return }
        
        self.titleLabel.text = albumDetails["name"] as? String
        self.subtitleLabel.text = albumDetails["artist"] as? String
        
        if let wiki = albumDetails["wiki"] as? [String: Any] {
            self.albumWikiLabel.text = wiki["content"] as? String
        }
        
        if let images = albumDetails["image"] as? [[String: String]] {
            self.setMediaImage(images: images)
        }
    }
    
    // MARK: - Artist setup methods
    private func fetchArtistInfo() {
        guard let artist = self.artist else { return }
        
        FMArtistSearch.fetchArtistInfo(for: artist, completionHandler: { response in
            guard let response = response else { return }
            
            if response["error"] != nil {
                self.waitViewLabel.text = response["message"] as? String
                return
            } else {
                self.mediaDetails = response
                self.setupArtistDetails()
                self.waitViewLabel.isHidden = true
            }
        })
    }
    
    private func setupArtistDetails() {
        guard let artistDetails = self.mediaDetails?["artist"] as? [String: Any] else { return }
        
        self.titleLabel.text = artistDetails["name"] as? String
        
       
        
        if let bio = artistDetails["bio"] as? [String: Any] {
            self.albumWikiLabel.text = bio["content"] as? String
        }
        
        if let images = artistDetails["image"] as? [[String: String]] {
            self.setMediaImage(images: images)
        }
    }
    
    // MARK: - Song setup methods
    private func fetchSongInfo() {
        guard let song = self.song else { return }
        
        FMSongSearch.fetchSongInfo(for: song, completionHandler: { response in
            guard let response = response else { return }
            
            if response["error"] != nil {
                self.waitViewLabel.text = response["message"] as? String
                return
            } else {
                self.mediaDetails = response
                self.setupSongDetails()
                self.waitViewLabel.isHidden = true
            }
        })
    }
    
    private func setupSongDetails() {
        guard let songDetails = self.mediaDetails?["track"] as? [String: Any] else { return }
        
        self.titleLabel.text = songDetails["name"] as? String
        
        if let album = songDetails["album"] as? [String: Any] {
            self.subtitleLabel.text = album["artist"] as? String
            if let images = album["image"] as? [[String: String]] {
                self.setMediaImage(images: images)
            }
        }
        
        
        if let wiki = songDetails["wiki"] as? [String: Any] {
            self.albumWikiLabel.text = wiki["content"] as? String
        }
        
    }

}
