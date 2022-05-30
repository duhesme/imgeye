//
//  FeedViewModel.swift
//  imgeye
//
//  Created by Никита Владимирович on 22.05.2022.
//

import Foundation

protocol FeedViewModelDelegate: NSObjectProtocol {
    func didDownload(photos: [PhotoModel], to indexPaths: [IndexPath]?)
}

class FeedViewModel: NSObject {
    
    weak var delegate: FeedViewModelDelegate?
    
    var isRefreshing = false
    
    var photoManager = PhotoManager()
    var searchManager = SearchManager()
    var photosArray = [PhotoModel]()
    
    var selectedPhoto: PhotoModel?
    
    let downloadCount = 10
    var isDownloadingNewPhotos = false
    var searchPhrase = ""
    var currentSearchPage = 1
    var isInSearch = false
    
    override init() {
        super.init()
        
        photoManager.delegate = self
        searchManager.delegate = self
    }
    
    func refresh() {
        isRefreshing = true
        searchPhrase = ""
        currentSearchPage = 1
        isInSearch = false
        photoManager.downloadRandomPhotos()
    }
    
    func downloadRandomPhotos(count: Int = 10) {
        photoManager.downloadRandomPhotos()
    }
    
    func downloadPhotos(bySearchPhrase phrase: String) {
        if phrase != searchPhrase {
            currentSearchPage = 1
        }
        
        searchPhrase = phrase.split(separator: " ").joined(separator: "+")
        searchManager.searchPhotos(byKeyword: searchPhrase, page: currentSearchPage)
        currentSearchPage += 1
        isInSearch = true
    }
    
    func loadNewPageOfPhotos(indexOfLastVisiblePhoto index: Int) {
        guard index == photosArray.count - 2, !isDownloadingNewPhotos else { return }
        if isInSearch {
            isDownloadingNewPhotos = true
            searchManager.searchPhotos(byKeyword: searchPhrase, page: currentSearchPage)
            currentSearchPage += 1
        } else {
            isDownloadingNewPhotos = true
            photoManager.downloadRandomPhotos()
        }
    }
    
}

extension FeedViewModel: PhotoManagerDelegate {
    
    func didDownloadPhotos(_ photoManager: PhotoManager, photos: [PhotoModel]) {
        if isRefreshing {
            isRefreshing = false
            photosArray = photos
            delegate?.didDownload(photos: photosArray, to: nil)
        } else {
            let newPhotos = Set(photos).subtracting(Set(photosArray))
        
            var indexPathsToUpdate: [IndexPath] = []
            for index in photosArray.count..<(photosArray.count + downloadCount) {
                indexPathsToUpdate.append(IndexPath(row: index, section: 0))
            }
            
            photosArray.append(contentsOf: newPhotos)
            isDownloadingNewPhotos = false
            
            delegate?.didDownload(photos: photosArray, to: indexPathsToUpdate)
        }
    }
    
    func didFailDownloadingPhotosWithErrorMessage(_ photoManager: PhotoManager, errorData: ErrorData) {
        
    }
    
    func didFailWithErrorDownloadingPhotos(error: Error?) {
        
    }
    
}

extension FeedViewModel: SearchManagerDelegate {
    
    func didDownloadPhotosBySearch(_ searchManager: SearchManager, searchResult: SearchModel) {
        if searchResult.page == 1 {
            photosArray = searchResult.photos
            delegate?.didDownload(photos: photosArray, to: nil)
        } else {
            let newPhotos = searchResult.photos
        
            var indexPathsToUpdate: [IndexPath] = []
            for index in photosArray.count..<(photosArray.count + downloadCount) {
                indexPathsToUpdate.append(IndexPath(row: index, section: 0))
            }
            
            photosArray.append(contentsOf: newPhotos)
            isDownloadingNewPhotos = false
            delegate?.didDownload(photos: photosArray, to: indexPathsToUpdate)
        }
    }
    
    func didFailDownloadingPhotosBySearchWithErrorMessage(_ searchManager: SearchManager, errorData: ErrorData) {
        
    }
    
    func didFailWithErrorDownloadingPhotosBySearch(error: Error?) {
        
    }
    
}
