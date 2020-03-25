//
//  ActivityIndicatable.swift
//  PhotoSearchFlkr
//
//  Created by Rahul Gupta on 26/03/20.
//  Copyright © 2020 Dunzo. All rights reserved.
//

import Foundation
import UIKit

public protocol ActivityIndicatable {
    var activityIndicator: UIActivityIndicatorView { get }
    func showActivityIndicator()
    func hideActivityIndicator()
}

public extension ActivityIndicatable where Self: UIViewController {
    
    func showActivityIndicator() {
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                self.activityIndicator.style = .medium
            } else {
                self.activityIndicator.style = .gray
                // Fallback on earlier versions
            }
            self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80) //or whatever size you would like
            self.activityIndicator.center = CGPoint(x: self.view.bounds.size.width / 2, y: self.view.bounds.height / 2)
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        }
    }
}

