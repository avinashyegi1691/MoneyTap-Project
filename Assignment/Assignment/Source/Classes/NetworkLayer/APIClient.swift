//
//  APIClient.swift
//  Assignment
//
//  Created by Avinash on 28/07/18.
//  Copyright © 2018 xyz. All rights reserved.
//

import Foundation

protocol APIRouter {
    var endPoint: String{get}
    var httpMethod: String{get}
    var params: [String: AnyObject]{get}
}

class APIClient {
    
    static let shared = APIClient()
    
    func getURLRequest(for router:APIRouter, cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy, timeoutInterval: TimeInterval = 10) -> URLRequest? {
        var urlRequest: URLRequest?
        if let url = getURL(for: router) {
            urlRequest = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
            urlRequest?.httpMethod = router.httpMethod
        }
        return urlRequest
    }
    
   private func getURL(for router:APIRouter) -> URL? {
        let baseURL = URL(string: Server.baseURL)
        let relativeURL = URL(string: router.endPoint, relativeTo: baseURL)
        var urlComponents = URLComponents(url: relativeURL!, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = getQueryParams(for: router)
        
        return urlComponents?.url
    }
    
   private func getQueryParams(for router:APIRouter) -> [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        
        for (key, value) in router.params {
            let queryItem = URLQueryItem(name: key, value: value as? String)
            queryItems += [queryItem]
        }
        return queryItems
    }
    
}
