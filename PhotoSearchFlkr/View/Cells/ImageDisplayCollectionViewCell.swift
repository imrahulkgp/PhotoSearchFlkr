//
//  ImageDisplayCollectionViewCell.swift
//  PhotoSearchFlkr
//
//  Created by Rahul Gupta on 25/03/20.
//  Copyright © 2020 Dunzo. All rights reserved.
//

import UIKit

class ImageDisplayCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setUp(dataModel: Photo?) {
        self.titleLabel.text = dataModel?.title
        if let urlStr = dataModel?.url {
            self.imageView.loadImageUsingCache(withUrl: urlStr, placeHolder: "placeHolder")
        } else {
            self.imageView.image = UIImage(named: "placeHolder")
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
