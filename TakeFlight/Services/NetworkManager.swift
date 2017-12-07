//
//  NetworkManager.swift
//  TakeFlight
//
//  Created by Justin Erickson on 11/30/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    func load(_ url: URL, headers: [String: String]?, payload: [String: Any]?, completion: @escaping (Data?, Error?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            Alamofire.request(url, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                guard response.error == nil else { return completion(nil, response.error) }
                
                if let data = response.data {
                    completion(data, nil)
                }
            }
        }
    }
}
