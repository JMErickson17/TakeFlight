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
    
    let cities = ["Albuquerque", "Fort Worth", "Bush Field", "Amarillo", "Anchorage", "Atlanta", "Austin", "Asheville", "Windsor Locks", "Seattle",
                  "Bangor", "Birmingham", "Billings", "Belleville", "Bloomington", "Nashville", "Boise", "Boston", "Baton Rouge", "Buffalo", "Baltimore",
                  "Columbia", "Chattanooga", "Cedar Rapids", "Cleveland", "Charlotte", "Columbus", "Colorado Springs", "Casper", "Corpus Christi",
                  "Charleston", "Cincinnati", "Daytona Beach", "Dallas", "Dayton", "Dubuque IA", "Washington", "Denver", "Dallas-Fort Worth", "Duluth",
                  "Des Moines", "Detroit", "Erie", "Newark", "Fairbanks", "Fort Lauderdale", "Fort Smith", "Fort Worth", "Fort Wayne", "Spokane",
                  "Gulfport", "Green Bay", "Greensboro", "Greenville", "Peru", "Hibbing", "Honolulu", "Houston", "Huntsville", "Huntington", "Washington",
                  "Houston", "Wichita", "Indianapolis", "Jackson", "Jacksonville", "New York", "Joplin", "Las Vegas", "Los Angeles", "Lubbock",
                  "Columbus", "Lexington KY", "Lafayette", "New York", "Little Rock", "Saginaw", "Kansas City", "Orlando", "Chicago", "Memphis", "Marietta",
                  "MONTGOMERY", "Manchester NH", "Miami", "Milwaukee", "Moline", "Monroe", "Mobile", "Madison", "Minneapolis", "New Orleans", "Oakland",
                  "Oklahoma City", "Ontario", "Chicago", "Norfolk", "West Palm Beach", "Portland", "Newport News", "Philadelphia", "Phoenix", "Peoria",
                  "Pittsburgh", "Portland", "Raleigh-durham", "Rockford", "Richmond", "Reno", "Roanoke VA", "Rochester", "Rochester", "Fort Myers",
                  "San Diego", "San Antonio", "Savannah", "South Bend", "Louisville", "Seattle", "Sanford", "San Francisco", "Springfield", "Shreveport",
                  "San Jose", "Salt Lake City", "Sacramento", "Santa Ana", "Springfield", "Sarasota", "St. Louis", "Null", "Sioux City", "Syracuse", "Tallahassee",
                  "Toledo", "Tampa", "BRISTOL", "Tulsa", "Tucson", "Knoxville", "Valparaiso"
    ]
    
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
