//
//  ImageManager.swift
//  SearchAndStoreDemo
//
//  Created by Avinash on 28/07/18.
//  Copyright © 2018 Avinash. All rights reserved.
//

import Foundation
import UIKit

typealias ImageDownloadCompletion = (UIImage?, Error?) -> ()

class ImageManager {
    
    func downloadImage(with urlString: String, completion: @escaping ImageDownloadCompletion) {
        if let downLoadURL = URL(string: urlString) {
            URLSession.shared.dataTask(with: downLoadURL) { (data, response, error) in
                DispatchQueue.main.async {
                    //guard let weakSelf = self else {return}
                    self.didDownloadImage(data: data, error: error, completion: completion)
                }
            }.resume()
        }
    }
    
    func didDownloadImage(data: Data?, error: Error?, completion: ImageDownloadCompletion) {
        if let _ = error {
            completion(nil, error)
        } else {
            if let imageData = data, let image = UIImage(data: imageData) {
                completion(image, nil)
            } else {
                completion(nil, nil)
            }
        }
    }
}
