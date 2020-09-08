//
//  FMSongSearch.swift
//  Least.fm
//
//  Created by vivek.aj.sharma on 06/09/20.
//  Copyright © 2020 vivek.aj.sharma. All rights reserved.
//

import Foundation
import  Alamofire

class FMSongSearch {
    
    // MARK: - Properties
    var currentpage = 1
    var searchKeyword: String
    var dataRequest: DataRequest?
    
    // MARK: - Init methods
    init(with keyword: String = "A") {
        self.searchKeyword = keyword
    }
    
    // MARK: - Public Methods
    func searchSong(with keyword: String? = nil,
                    nextPageSearch: Bool = false,
                    completionHandler: @escaping ([FMSong]?) -> Void) {
        
        if self.dataRequest != nil {
            self.dataRequest?.cancel()
        }
        
        self.searchKeyword = keyword ?? self.searchKeyword
        self.currentpage = nextPageSearch ? self.currentpage + 1 : 1
        
        let params: Parameters = [ParameterKeys.methodKey: ParameterValues.songSearchMethod,
                                  ParameterKeys.api_keyKey: ParameterValues.apiKey,
                                  ParameterKeys.formatKey: ParameterValues.responseFormat,
                                  ParameterKeys.limitKey: ParameterValues.itemsPerPage,
                                  ParameterKeys.pageKey: self.currentpage,
                                  ParameterKeys.songKey: self.searchKeyword]
        
        self.dataRequest = NetworkService.shared.fetchMediaDetails(with: params, completionHandler: { response, error in
            
            guard let response = response,
                let results = response["results"] as? [String: Any],
                let trackMatches = results["trackmatches"] as? [String: Any],
                let trackArray = trackMatches["track"] as? [[String: Any]],
                let trackData = try? JSONSerialization.data(withJSONObject: trackArray, options: []) else {
                    return
            }
            guard let trackList = try? JSONDecoder().decode([FMSong].self, from: trackData) else {
                var tracks: [FMSong] = []
                for item in trackArray {
                    tracks.append(FMSong(with: item))
                }
                completionHandler(tracks.isEmpty ? nil : tracks)
                return
            }
            
            completionHandler(trackList)
        })
    }
    
    // MARK: - Static methods
    static func fetchSongInfo(for song: FMSong,
                              completionHandler: @escaping ([String: Any]?) -> Void) {
        
        var params: Parameters = [ParameterKeys.methodKey: ParameterValues.songGetinfoMethod,
                                  ParameterKeys.api_keyKey: ParameterValues.apiKey,
                                  ParameterKeys.formatKey: ParameterValues.responseFormat]
        
        if let mbidValue = song.mbid {
            params[ParameterKeys.mbidKey] = mbidValue
        } else {
            params[ParameterKeys.songKey] = song.name
            params[ParameterKeys.artistKey] = song.artist
            params[ParameterKeys.autocorrectKey] = ParameterValues.autocorrect
        }
        
        _ = NetworkService.shared.fetchMediaDetails(with: params, completionHandler: { response, error in
            
            guard let response = response else {
                completionHandler(nil)
                return
            }
            
            completionHandler(response)
        })
    }
}
