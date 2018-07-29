//
//  HomeDataManager.swift
//  Assignment
//
//  Created by Avinash on 29/07/18.
//  Copyright © 2018 xyz. All rights reserved.
//

import Foundation
import CoreData

enum HomeAPIRouter: APIRouter {
    case titleQuery(String)
    case pageQuery(String)

    var endPoint: String {
        var endpoint = ""
        
        switch self {
        case .titleQuery:
            fallthrough
        case .pageQuery:
            endpoint = "w/api.php"
        }
        return endpoint
    }
    
    var httpMethod: String {
        var method = ""
        
        switch self {
        case .titleQuery:
            fallthrough
        case .pageQuery:
            method = "GET"
        }
        return method
    }
    
    var params: [String : AnyObject] {
        var params = [String: AnyObject]()
        
        switch self {
        case .titleQuery(let title):
            params["action"] = "query" as AnyObject
            params["prop"] = "pageterms|pageimages" as AnyObject
            params["formatversion"] = "2" as AnyObject
            params["titles"] = title as AnyObject
            params["format"] = "json" as AnyObject
            params["generator"] = "prefixsearch" as AnyObject
            params["redirects"] = "1" as AnyObject
            params["piprop"] = "thumbnail" as AnyObject
            params["pithumbsize"] = "50" as AnyObject
            params["pilimit"] = "10" as AnyObject
            params["wbpterms"] = "description" as AnyObject
            params["gpssearch"] = title as AnyObject
            params["gpslimit"] = "10" as AnyObject
            
        case .pageQuery(let pageID):
            params["action"] = "query" as AnyObject
            params["prop"] = "info" as AnyObject as AnyObject
            params["formatversion"] = "2" as AnyObject
            params["pageids"] = pageID as AnyObject
            params["format"] = "json" as AnyObject
            params["inprop"] = "url" as AnyObject

        }
        return params
    }
}

class HomeDataManager {
    
    func getResults(for query: String, completion:@escaping ([ResultViewModel], APIError?)->()) {
        
        let searchPredicate = NSPredicate(format: "SELF.queryText = %@", query)
        let results = ResultModel.fetchAllObjects(predicate: searchPredicate) as! [ResultModel]
        if results.count > 0 {
            completion(getResultViewModels(for: results), nil)
            return
        }
        
        if let urlRequest = APIClient.shared.getURLRequest(for: HomeAPIRouter.titleQuery(query)){
            URLSession.dataTask(with: urlRequest, completionHandler: { (result) in
               // guard let weakSelf = self else {return}

                switch result{
                    case .success(let feed):
                        print("Response:\(feed)")
                        var resultModels = [ResultModel]()
                        if let queryDictionary = feed["query"] as? [String:AnyObject] {
                            if let pages = queryDictionary["pages"] as? [[String : AnyObject]] {
                                for eachPage in pages {
                                    let model = ResultModel.createLocalModel() as! ResultModel
                                    model.setModel(with: eachPage)
                                    model.queryText = query
                                    model.saveModel()
                                    resultModels += [model]
                                }
                            }
                        }
                        completion(self.getResultViewModels(for: resultModels), nil)
                    case .failure(let error):
                        completion([],error)
                }
            })
        }
    }

    func getPage(for pageID: NSNumber, completion:@escaping (String?, APIError?)->()) {

        if let urlRequest = APIClient.shared.getURLRequest(for: HomeAPIRouter.pageQuery("\(pageID)")){
            URLSession.dataTask(with: urlRequest, completionHandler: { (result) in
                switch result{
                case .success(let feed):
                    print("Response:\(feed)")
                    
                    var pageURL = ""
                    if let query = feed["query"] as? [String:AnyObject] {
                        if let pages = query["pages"] as? [[String : AnyObject]] {
                            for page in pages {
                                if let url = page["fullurl"] as? String {
                                    pageURL = url
                                }
                            }
                        }
                    }
                    completion(pageURL, nil)
                case .failure(let error):
                    completion(nil,error)
                }
            })
        }
    }
    
    private func getResultViewModels(for models: [ResultModel]) -> [ResultViewModel] {
        
        var viewModels = [ResultViewModel]()
        
        for model in models {
            let viewModel = ResultViewModel(model: model)
            viewModels += [viewModel]
        }
        return viewModels
    }
}
