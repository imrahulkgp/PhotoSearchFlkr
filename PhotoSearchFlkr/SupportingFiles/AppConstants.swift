//
//  AppConstants.swift
//  PhotoSearchFlkr
//
//  Created by Rahul Gupta on 25/03/20.
//  Copyright © 2020 Dunzo. All rights reserved.
//

import Foundation

struct APIHelper {
    static let baseUrl = "https://api.flickr.com/services/rest/"
    static let method = "method"
    static let methodVal = "flickr.photos.search"
    static let text = "text"
    static let apiKey = "api_key"
    static let apiKeyVal = "062a6c0c49e4de1d78497d13a7dbb360"
    static let format = "format"
    static let formatVal = "json"
    static let nojsoncallback = "nojsoncallback"
    static let nojsoncallbackVal = 1
    static let perPage = "per_page"
    static let perPageVal = 12
    static let page = "page"
}
