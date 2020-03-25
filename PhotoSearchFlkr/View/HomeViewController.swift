//
//  HomeViewController.swift
//  PhotoSearchFlkr
//
//  Created by Rahul Gupta on 25/03/20.
//  Copyright © 2020 Dunzo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, ActivityIndicatable {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var activityIndicator = UIActivityIndicatorView()
    var viewModel: HomeViewModel!
    var isFetching: Bool = false
    var scrollOffset:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = HomeViewModel()
        self.viewModel.delegate = self
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:_ scrollview delegate methods
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        //check whether we are at the bottom edge and then fetch again
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if bottomEdge >= scrollView.contentSize.height, !isFetching {
            if maximumOffset-currentOffset <= 20,
                self.scrollOffset <= currentOffset,
                let searchStr = searchBar.text {
                self.showActivityIndicator()
                self.viewModel.fetchImages(withTag: searchStr)
                isFetching = true
            }
        }
        self.scrollOffset = currentOffset
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.photoList.count == 0 && !isFetching {
            collectionView.setEmptyMessage("No images to show.\nPlease search to get started.")
        } else {
            collectionView.restore()
        }
        return viewModel.photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ImageDisplayCollectionViewCell.self), for: indexPath) as? ImageDisplayCollectionViewCell
        cell?.setUp(dataModel: viewModel.photoList[indexPath.row])
        return cell ?? UICollectionViewCell()
    }
    
}

extension HomeViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 3.2
        let hardCodedPadding:CGFloat = 2
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = (itemWidth*1.7)
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func failedToGetData() {
        DispatchQueue.main.async {
            self.isFetching = false
            self.hideActivityIndicator()
            //Show Alert for error.
            self.showAlert(title: "Alert", message: "Failed to fetch images, Please try again later.")
        }
    }
    
    func fetchedImages() {
        DispatchQueue.main.async {
            self.isFetching = false
            self.hideActivityIndicator()
            self.collectionView.reloadData()
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let txt = searchBar.text, txt.isEmpty || searchBar.text == nil {
            viewModel.resetModel()
            collectionView.reloadData()
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchStr = searchBar.text, !searchStr.isEmpty {
            self.showActivityIndicator()
            viewModel.fetchImages(withTag: searchStr)
            isFetching = true
            searchBar.resignFirstResponder()
        } else {
            showAlert(title: "Alert", message: "Please type some keyword to search.")
        }
    }
}
