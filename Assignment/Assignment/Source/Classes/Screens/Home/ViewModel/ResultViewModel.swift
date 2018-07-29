//
//  HomeViewModel.swift
//  Assignment
//
//  Created by Avinash on 28/07/18.
//  Copyright © 2018 xyz. All rights reserved.
//

import Foundation
import UIKit

class ResultViewModel {
    private let model: ResultModel
    var image: UIImage?

    init(model: ResultModel) {
        self.model = model
    }

    func setPageURL(urlString: String) {
        self.model.pageURL = urlString
        self.model.saveModel()
    }

    var titleText: String{
        var text = ""
        
        if let title = model.title {
                text = title
        }
        return text
    }

    var descriptionText: String{
        var text = ""
        
        if let descriptionMessage = model.itemDescription {
            text = descriptionMessage
        }
        return text
    }
    
    var pageID: NSNumber {
        var pageID:NSNumber = 0
        
        if let identifier = model.pageID {
            pageID = identifier
        }
        return pageID
    }

    var pageURL: String {
        var url = ""
        
        if let urlString = model.pageURL {
            url = urlString
        }
        return url
    }

    func downloadImage(completion: @escaping (Result)-> ()) {
        let imageManager = ImageManager()
        
        if let image = self.image {
            completion(.success)
            return
        }
        
        
        if let url = model.imageURL {
            imageManager.downloadImage(with: url) { (image, error) in
                if let _ = error {
                    completion(.failure("Failed to download"))
                }
                else {
                    if let image = image {
                        let size = CGSize(width: 80,
                                          height: 80)
                        self.image = UIImage.resizeImage(image: image, size: size)
                        completion(.success)
                    }
                }
            }
        }
    }
}


