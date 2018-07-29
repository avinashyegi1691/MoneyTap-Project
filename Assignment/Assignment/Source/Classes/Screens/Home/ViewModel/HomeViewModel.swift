//
//  HomeViewModel.swift
//  Assignment
//
//  Created by Avinash on 28/07/18.
//  Copyright © 2018 xyz. All rights reserved.
//

import Foundation

protocol BaseViewModel {
    var screenTitle: String{get}
    var itemCount: Int{get}
    func clear()
}


class HomeViewModel {
    private var resultViewModels = [ResultViewModel]()
    typealias ResultCompletion = (Result)->()
    
    func viewModel(index:Int) -> ResultViewModel{
        return resultViewModels[index]
    }
    
    func getResults(for query:String, completion:@escaping ResultCompletion) {
        let manager = HomeDataManager()
        manager.getResults(for: query) {[weak self] (viewModels, error) in
            guard let weakSelf = self else {return}
            if (error != nil) || viewModels.count == 0 {
                completion(.failure("No results found"))
                return
            }
            
            weakSelf.resultViewModels = viewModels
            completion(.success)
        }
    }
}

extension HomeViewModel: BaseViewModel {
    var screenTitle: String {
        return "Home"
    }
    
    var itemCount: Int {
        return resultViewModels.count
    }
    
    func clear() {
        resultViewModels.removeAll()
    }
}
