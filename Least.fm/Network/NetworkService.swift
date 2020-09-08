//
//  NetworkService.swift
//  Least.fm
//
//  Created by vivek.aj.sharma on 06/09/20.
//  Copyright © 2020 vivek.aj.sharma. All rights reserved.
//

import Foundation
import Alamofire

struct ParameterKeys {
    static let methodKey = "method"
    static let api_keyKey = "api_key"
    static let formatKey = "format"
    static let limitKey = "limit"
    static let pageKey = "page"
    static let albumKey = "album"
    static let artistKey = "artist"
    static let songKey = "track"
    static let autocorrectKey = "autocorrect"
    static let mbidKey = "mbid"
}

struct ParameterValues {
    static let apiKey = "2ff4ca54b33b002a40bbf429040a3f71"
    static let responseFormat = "json"
    static let itemsPerPage = "20"
    static let autocorrect = "1"
    static let albumSearchMethod = "album.search"
    static let albumGetinfoMethod = "album.getinfo"
    static let artistSearchMethod = "artist.search"
    static let artistGetinfoMethod = "artist.getinfo"
    static let songSearchMethod = "track.search"
    static let songGetinfoMethod = "track.getinfo"
}

class NetworkService {
    
    static let rootURL = "https://ws.audioscrobbler.com/2.0/"
    
    static let shared = NetworkService()
    
    func fetchMediaDetails(with parameters: Parameters,
                           completionHandler: @escaping ([String: Any]?, Error?) -> Void) -> DataRequest
    {
        return Alamofire.request(type(of: self).rootURL, parameters: parameters).responseJSON { response in
            
            if let jsonResponse = response.result.value as? [String: Any] {
                debugPrint("JSON: \(jsonResponse)") // Serialized json response
                completionHandler(jsonResponse, nil)
            } else {
                completionHandler(nil, response.error)
            }
            
        }
    }
    
}
