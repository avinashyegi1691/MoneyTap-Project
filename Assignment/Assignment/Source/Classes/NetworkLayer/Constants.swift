//
//  Constants.swift
//  Assignment
//
//  Created by Avinash on 28/07/18.
//  Copyright © 2018 xyz. All rights reserved.
//

import Foundation

struct Server {
   static let baseURL = "https://en.wikipedia.org"
}

enum Result {
    case success
    case failure(String)
}

enum ViewState {
    case normal
    case loading
    case loaded
    case error(String)
}
