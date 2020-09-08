//
//  FMSong.swift
//  Least.fm
//
//  Created by vivek.aj.sharma on 06/09/20.
//  Copyright © 2020 vivek.aj.sharma. All rights reserved.
//

import Foundation

struct FMSong : Decodable{

    // MARK: - Properties
     let name: String
     let artist: String
     let songUrl: URL
     let images: [ArtworkImage]
     let mbid: String?
     
     enum CodingKeys: String, CodingKey {
         case name = "name"
         case artist = "artist"
         case songUrl = "url"
         case images = "image"
         case mbid = "mbid"
     }
     
     // MARK: - Init methods
     init(with dictionary: [String: Any]) {
         
         self.name = dictionary["nama"] as? String ?? ""
         self.artist = dictionary["artist"] as? String ?? ""
         
         if let url = URL(string: dictionary["url"] as? String ?? "") {
             self.songUrl = url
         } else {
             self.songUrl = URL(fileURLWithPath: "")
         }
         
         if let imgItems = dictionary["image"] as? [[String: Any]] {
             var imgs: [ArtworkImage] = []
             for imgItem in imgItems {
                 imgs.append(ArtworkImage(with: imgItem))
             }
             self.images = imgs
         } else {
             self.images = []
         }
         
         self.mbid = dictionary["mbid"] as? String
     }
     
     // MARK: - Public methods
     func imageURL() -> URL {
         let imageItem = self.images.filter { $0.size == "extralarge" }
         return imageItem.first!.url
     }
}
