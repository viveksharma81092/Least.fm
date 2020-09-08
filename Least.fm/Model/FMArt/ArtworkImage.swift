//
//  ArtworkImage.swift
//  Least.fm
//
//  Created by vivek.aj.sharma on 06/09/20.
//  Copyright © 2020 vivek.aj.sharma. All rights reserved.
//

import Foundation
struct ArtworkImage: Decodable {
    
    let url: URL
    let size: String
    
    enum CodingKeys : String, CodingKey {
        case url = "#text"
        case size = "size"
    }
    
    init(with dictionary: [String: Any]) {
        if let url = URL(string: dictionary["#text"] as? String ?? "") {
            self.url = url
        } else {
            self.url = URL(fileURLWithPath: "")
        }
        self.size = dictionary["size"] as? String ?? ""
    }
}
