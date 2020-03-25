//
//  UIImageViewExtension.swift
//  PhotoSearchFlkr
//
//  Created by Rahul Gupta on 25/03/20.
//  Copyright © 2020 Dunzo. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func loadImageUsingCache(withUrl urlString : String, placeHolder: String) {
        guard let url = URL(string: urlString) else { return }
        guard let _ = url.host else {
            DispatchQueue.main.async {
                self.image = UIImage.init(named: placeHolder)
            }
            return
        }
        self.image = nil
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.image = UIImage.init(named: placeHolder)
                }
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                } else {
                    self.image = UIImage.init(named: placeHolder)
                }
            }
            
        }).resume()
    }
}
