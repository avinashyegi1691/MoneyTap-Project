//
//  HomeViewModel.swift
//  Assignment
//
//  Created by Avinash on 28/07/18.
//  Copyright © 2018 Avinash. All rights reserved.
//

import Foundation

class DetailViewModel {
    private var resultViewModel: ResultViewModel!
    typealias ResultCompletion = (Result)->()
    
    init(viewModel : ResultViewModel) {
        self.resultViewModel = viewModel
    }
    
    var pageID: NSNumber {
        return resultViewModel.pageID
    }
    
    var pageURL: String {
        return resultViewModel.pageURL
    }
    
    func getPageURL(for pageID:NSNumber, completion:@escaping ResultCompletion) {
        let manager = HomeDataManager()
        
        if(resultViewModel.pageURL.count > 0) {
            completion(.success)
            return
        }
        
        manager.getPage(for: pageID) {[weak self] (pageURL, error) in
            guard let weakSelf = self else {return}
            if (error != nil) {
                completion(.failure("Invalid URL"))
                return
            }
            
            if let pageURL = pageURL {
                weakSelf.resultViewModel.setPageURL(urlString: pageURL)
                completion(.success)
                return
            }
            
            completion(.failure("Invalid URL"))
        }
    }
}

extension DetailViewModel: BaseViewModel {
    var screenTitle: String {
        return resultViewModel.titleText
    }
    
    var itemCount: Int {
        return 1
    }
    
    func clear() {
        //Nothing to implement
    }
}
