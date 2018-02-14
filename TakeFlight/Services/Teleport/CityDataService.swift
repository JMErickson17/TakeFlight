//
//  CityDataService.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/13/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation
import Alamofire

protocol CityDataService {
    
}

class TeleportCityDataService: CityDataService {
    
    // MARK: Properties
    
    private var rootURLComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.teleport.org"
        components.path = "/api/"
        return components
    }
    
//    private let allImagesURL = URL(string: "https://api.teleport.org/api/urban_areas/?embed=ua:item/ua:images")!
    
    init() {}
    
    func details(for destination: String, completion: @escaping (Destination?, Error?) -> Void) {
        let searchQuery = URLQueryItem(name: "search", value: destination)
        var urlComponents = rootURLComponents
        urlComponents.path += "cities"
        urlComponents.queryItems = [searchQuery]
        
        guard let url = urlComponents.url else { return completion(nil, nil) }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { response in
            guard let data = response.data else { return completion(nil, nil) }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print(json)
            } catch {
                print(error)
            }
        })
    }
}
