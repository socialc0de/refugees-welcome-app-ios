//
//  RequestHelper.swift
//  RefugeesWelcome
//
//  Created by Anna on 24.10.15.
//  Copyright © 2015 socialc0de. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RequestHelper {
    
    static func loadDataFromUrl(url: String, callback: JSON->Void) {
        Alamofire.request(.GET, url)
            .response {
                (_, response, data, error) in
                if (error != nil) {
                    print(error)
                } else {
                    if let jsonData = data {
                        callback(JSON(data: jsonData))
                    }
                }
        }
    }
    
}