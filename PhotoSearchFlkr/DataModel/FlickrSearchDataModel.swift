//
//  FlickrSearchDataModel.swift
//  PhotoSearchFlkr
//
//  Created by Rahul Gupta on 25/03/20.
//  Copyright © 2020 Dunzo. All rights reserved.
//

import Foundation

// MARK: - FlickrSearchDataModel
struct FlickrSearchDataModel: Codable {
    let photos: Photos?
    let stat: String?
}

// MARK: - Photos
struct Photos: Codable {
    let page, pages, perpage: Int?
    let total: String?
    let photo: [Photo]?
}

// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String?
    let farm: Int?
    let title: String?
    let ispublic, isfriend, isfamily: Int?
    
    var url: String? {
        get {
            if let farm = farm,
                let server = server,
                let id = id,
                let secret = secret {
                return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg"
            }
            return nil
        }
    }
}
