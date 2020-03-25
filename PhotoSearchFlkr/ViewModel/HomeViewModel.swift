//
//  HomeViewModel.swift
//  PhotoSearchFlkr
//
//  Created by Rahul Gupta on 25/03/20.
//  Copyright © 2020 Dunzo. All rights reserved.
//

import Foundation

protocol HomeViewModelDelegate: class {
    func failedToGetData()
    func fetchedImages()
}

class HomeViewModel {
    var photoList: [Photo] = []
    weak var delegate: HomeViewModelDelegate?
    var page = 0
    var searchStr: String?
    
    func fetchImages(withTag tag: String) {
        if let str = searchStr, str != tag {
            resetModel()
        }
        page += 1
        let dict:[String: Any] = [APIHelper.method: APIHelper.methodVal,
                                  APIHelper.apiKey: APIHelper.apiKeyVal,
                                  APIHelper.text: tag,
                                  APIHelper.format: APIHelper.formatVal,
                                  APIHelper.nojsoncallback: APIHelper.nojsoncallbackVal,
                                  APIHelper.perPage: APIHelper.perPageVal,
                                  APIHelper.page: page]
        
        searchStr = tag
        NetworkManager.sharedManager.sendUniqueRequest(.get, url: APIHelper.baseUrl, param: dict, headers: nil) { [weak self] (data, response, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(FlickrSearchDataModel.self, from: data)
                    if let list = response.photos?.photo {
                        self?.photoList.append(contentsOf: list)
                        self?.delegate?.fetchedImages()
                    } else {
                        self?.delegate?.failedToGetData()
                    }
                }
                catch {
                    self?.delegate?.failedToGetData()
                    print("Error: \(error)")
                }
            } else {
                //TODO:Error cases can be handled in better way, can pass error to VC and show alert or toast.
                self?.delegate?.failedToGetData()
            }
        }
    }
    
    func resetModel() {
        photoList = []
        page = 0
    }
}
