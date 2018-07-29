//
//  URLSession+Additions.swift
//  SearchAndStoreDemo
//
//  Created by Avinash on 28/07/18.
//  Copyright © 2018 Avinash. All rights reserved.
//

import Foundation

enum APIError: String, Error  {
    case badRequest //400
    case internalServerError //500
    case notFound //404
    
    case invalidURL //Error returned by URLSession
    case jsonParsingError //Error in parsing the response, catch block of JSONSerialization
    case nilRequest //URLRequest is nil
    case invalidResponse //No error but data/response is nil
    case nilResponse // Response after parsing (feed) is nil
    case unknownError //Unknown Error
}

enum APIResult{
    case success([String: AnyObject])
    case failure(APIError)
}

extension URLSession {
    class func dataTask(with request:URLRequest?, completionHandler: @escaping (APIResult) -> Void) {
        guard let theRequest = request else {
            completionHandler(.failure(.nilRequest))
            return
        }

        URLSession.shared.dataTask(with: theRequest) { (data, response, error) in
            
            if let _ = error {
                completionHandler(.failure(.invalidURL))
            }

            guard let theData = data else {
                completionHandler(.failure(.invalidResponse))
                return
            }

            guard let theResponse = response as? HTTPURLResponse else {
                completionHandler(.failure(.invalidResponse))
                return
            }

            switch theResponse.statusCode {
                case 200 :
                    do {
                    if let feed = try JSONSerialization.jsonObject(with: theData, options: []) as? [String: AnyObject] {
                        print(feed)
                        completionHandler(.success(feed))
                    } else {
                        completionHandler(.failure(.nilResponse))
                        }
                    }
                    catch {
                        completionHandler(.failure(.jsonParsingError))
                    }
                case 400 :
                    completionHandler(.failure(.badRequest))

                case 404 :
                    completionHandler(.failure(.notFound))

                case 500 :
                    completionHandler(.failure(.internalServerError))

                default:
                    completionHandler(.failure(.unknownError))
            }
            
        }.resume()
    }
}
