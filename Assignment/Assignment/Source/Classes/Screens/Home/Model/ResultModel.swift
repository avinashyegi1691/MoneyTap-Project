//
//  ResultModel.swift
//  Assignment
//
//  Created by Avinash on 28/07/18.
//  Copyright © 2018 xyz. All rights reserved.
//

import UIKit
import CoreData

class ResultModel: NSManagedObject {
    @NSManaged var title: String?
    @NSManaged var itemDescription: String?
    @NSManaged var imageURL: String?
    @NSManaged var pageID: NSNumber?
    @NSManaged var pageURL: String?
    @NSManaged var queryText: String?
    
    func setModel(with dictionary:[String: AnyObject]){
        
        title = dictionary["title"] as? String
        pageID = dictionary["pageid"] as? NSNumber
        
        if let thumbnail = dictionary["thumbnail"] as? [String : AnyObject] {
            imageURL = thumbnail["source"] as? String
        }
        
        if let terms = dictionary["terms"] as? [String : AnyObject] {
            if let descriptions = terms["description"] as? [String]{
                itemDescription = descriptions.first
            }
        }
    }
}
