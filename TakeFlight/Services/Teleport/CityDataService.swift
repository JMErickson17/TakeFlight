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
    
    init() {
        getDetails()
    }
    
    struct Location: Codable {
        let coordinates: Coordinates
        
        enum CodingKeys: String, CodingKey {
            case coordinates = "latlon"
        }
    }
    
    struct City: Codable {
        let name: String
        let population: Int
        let location: Location
    }
    
    struct CityResource {
        let name: String
        let url: String
    }
    
    enum TeleportResource {
        case search
    }
    
    func getDetails() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let destinations = appDelegate.firebaseDestinationServive!.destinations
        let destinationService = appDelegate.firebaseDestinationServive
        
        for destination in destinations {
            details(for: destination.city, completion: { (resource, error) in
                if let error = error { print(error) }
                if let urlString = resource?.url, let url = URL(string: urlString) {
                    self.city(at: url, completion: { (city, error) in
                        if let error = error { print(error) }
                        if let city = city {
                            guard destination.city == city.name else { return }
                            
                            let updatedDestination = Destination(city: destination.city, state: destination.state, country: destination.country, coordinates: destination.coordinates, population: city.population, airports: destination.airports)
                            print(updatedDestination)
                            destinationService?.create(destination: updatedDestination, completion: { (error) in
                                if let error = error {
                                    print(error)
                                }
                            })
                        }
                    })
                }
            })
        }
    }
    
    let teleportURLString = "https://api.teleport.org"
    
    func urlComponents(for resource: TeleportResource) -> URLComponents? {
        guard var components = URLComponents(string: teleportURLString) else { return nil }
        components.path = "/api/cities"
        return components
    }
    
    func details(for city: String, completion: @escaping (CityResource?, Error?) -> Void) {
        guard var searchURLComponents = urlComponents(for: .search) else { return }
        let searchQuery = URLQueryItem(name: "search", value: city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        searchURLComponents.queryItems = [searchQuery]
        print(searchQuery)
        if let url = searchURLComponents.url {
            print(url)
            let session = URLSession.shared
            let request = URLRequest(url: url)
            let dataTask = session.dataTask(with: request, completionHandler: { data, response, error in
                if let error = error { print(error) }
                if let data = data {
                    guard let json = (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any] else {
                        return print("Could not create JSON")
                    }
                    guard let embedded = json["_embedded"] as? [String: Any] else { return }
                    guard let searchResults = embedded["city:search-results"] as? [[String: Any]] else { return }
                    guard searchResults.count > 0 else { print("No Results for \(city)"); return }
                    guard let cityName = searchResults[0]["matching_full_name"] as? String else { return }
                    guard let links = searchResults[0]["_links"] as? [String: Any] else { return }
                    guard let item = links["city:item"] as? [String: Any] else { return }
                    guard let url = item["href"] as? String else { return }
                    
                    let city = CityResource(name: cityName, url: url)
                    return completion(city, nil)
                }
            })
            dataTask.resume()
        }
    }
    
    
    func city(at url: URL, completion: @escaping (City?, Error?) -> Void) {
        let session = URLSession.shared
        let request = URLRequest(url: url)
        session.dataTask(with: request) { data, response, error in
            if let data = data {
                guard let json = (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any] else {
                    return print("Could not create JSON")
                }
                guard let name = json["name"] as? String else { return }
                guard let population = json["population"] as? Int else { return }
                guard let location = json["location"] as? [String: Any] else { return }
                guard let latLon = location["latlon"] as? [String: Any] else { return }
                guard let lat = latLon["latitude"] as? Double else { return }
                guard let lon = latLon["longitude"] as? Double else { return }
                
                let coords = Coordinates(latitude: lat, longitude: lon)
                
                let _location = Location(coordinates: coords)
                let city = City(name: name, population: population, location: _location)
                completion(city, nil)
            }
            }.resume()
    }

}
