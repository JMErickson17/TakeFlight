//
//  TeleportDestinationDetailService.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/28/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation

struct TeleportDestinationDetailService: DestinationDetailsService {
    
    // MARK: Constants
    
    private enum API {
        static let endpoint = "https://api.teleport.org/api/cities/"
    }
    
    // MARK: Resources
    
    private enum TeleportResource {
        case search(String)
        case geoname(String)
        
        var queryString: String {
            switch self {
            case .search(_):
                return ""
            case .geoname(let geoname):
                return "geonameid:\(geoname)"
            }
        }
    }
    
    private func url(for resource: TeleportResource) -> URL? {
        if let url = URL(string: API.endpoint)?.appendingPathComponent(resource.queryString) {
            return url
        }
        return nil
    }
    
    // MARK: Public API
    
    func details(forGeoname geoname: String, completion: @escaping (DestinationDetails?, Error?) -> ()) {
        let resource = TeleportResource.geoname(geoname)
        if let url = url(for: resource) {
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error { return print(error) }
                guard let data = data else { return print("No Data") }
                guard let json = (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? JSONRepresentable else {
                    return print("Could not create JSON")
                }
                guard let name = json["name"] as? String else { return }
                guard let population = json["population"] as? Int else { return }
                guard let location = json["location"] as? [String: Any] else { return }
                guard let latLon = location["latlon"] as? [String: Any] else { return }
                guard let lat = latLon["latitude"] as? Double else { return }
                guard let lon = latLon["longitude"] as? Double else { return }
                
                let coordinates = Coordinates(latitude: lat, longitude: lon)
                
                guard let links = json["_links"] as? JSONRepresentable else { return }
                guard let timezoneObject = links["city:timezone"] as? JSONRepresentable else { return }
                guard let timeZone = timezoneObject["name"] as? String else { return }
                guard let urbanArea = links["city:urban_area"] as? JSONRepresentable else { return }
                guard let urbanAreaURL = urbanArea["href"] as? String else { return }
                
                guard let urbanDataURL = URL(string: urbanAreaURL) else { return }
                
                URLSession.shared.dataTask(with: urbanDataURL) { data, response, error in
                    if let error = error { return print(error) }
                    guard let data = data else { return print("No Data") }
                    guard let json = (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? JSONRepresentable else {
                        return print("Could not create JSON")
                    }
                    
                    guard let links = json["_links"] as? JSONRepresentable else { return }
                    
                    guard let boundingBox = json["bounding_box"] as? JSONRepresentable else { return }
                    guard let finalBoundingBox = self.parseBoundingBox(with: boundingBox) else { return }
            
                    guard let details = links["ua:details"] as? JSONRepresentable else { return }
                    guard let detailsURLString = details["href"] as? String else { return }
                    
                    guard let scores = links["ua:scores"] as? JSONRepresentable else { return }
                    guard let scoresURLString = scores["href"] as? String else { return }
            
                    guard let detailsURL = URL(string: detailsURLString) else { return }
                    URLSession.shared.dataTask(with: detailsURL) { data, _, error in
                        if let error = error { return print(error) }
                        guard let data = data else { return print("No Data") }
                        guard let json = (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? JSONRepresentable else {
                            return print("Could not create JSON")
                        }
                        
                        guard let categories = json["categories"] as? [JSONRepresentable] else { return }
                        guard let climateIndex = categories.index(where: { $0["id"] as! String == "CLIMATE" }) else { return }
                        guard let climateData = categories[climateIndex]["data"] as? [JSONRepresentable] else { return }
                        guard let weatherData = self.parseWeatherData(with: climateData) else { return }
                        
                        guard let scoresURL = URL(string: scoresURLString) else { return }
                        
                        URLSession.shared.dataTask(with: scoresURL) { data, _, error in
                            if let error = error { return print(error) }
                            guard let data = data else { return print("No Data") }
                            guard let json = (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? JSONRepresentable else {
                                return print("Could not create JSON")
                            }
                            
                            guard let scores = self.parseScores(with: json) else { return }
                            
                            let destinationDetails = DestinationDetails(name: name, geonameId: geoname, timezone: timeZone, scores: scores, boundingBox: finalBoundingBox, weather: weatherData, coordinates: coordinates, population: population)
                            completion(destinationDetails, nil)
                            
                        }.resume()
                    }.resume()
                }.resume()
            }.resume()
        }
    }
    
    // MARK: Convenience
    
    private func parseBoundingBox(with json: JSONRepresentable) -> BoundingBox? {
        guard let latlon = json["latlon"] as? JSONRepresentable else { return nil }
        guard let north = latlon["north"] as? Double else { return nil }
        guard let east = latlon["east"] as? Double else { return nil }
        guard let south = latlon["south"] as? Double else { return nil }
        guard let west = latlon["west"] as? Double else { return nil }
        
        return BoundingBox(north: north, east: east, south: south, west: west)
    }
    
    private func parseWeatherData(with json: [JSONRepresentable]) -> Weather? {
        let climateData = json
        guard let averageDayLengthIndex = climateData.index(where: { $0["id"] as! String == "WEATHER-AV-DAY-LENGTH" }) else { return nil }
        guard let averageDayLength = climateData[averageDayLengthIndex]["float_value"] as? Double else { return nil }
        
        guard let averageRainyDaysIndex = climateData.index(where: { $0["id"] as! String == "WEATHER-AV-NUMBER-RAINY-DAYS" }) else { return nil }
        guard let averageRainyDays = climateData[averageRainyDaysIndex]["float_value"] as? Int else { return nil }
        
        guard let averageSunshineIndex = climateData.index(where: { $0["id"] as! String == "WEATHER-AV-POSSIBILITY-SUNSHINE" }) else { return nil }
        guard let averageSunshine = climateData[averageSunshineIndex]["percent_value"] as? Double else { return nil }
        
        guard let averageHighTempIndex = climateData.index(where: { $0["id"] as! String == "WEATHER-AVERAGE-HIGH" }) else { return nil }
        guard let averageHigh = climateData[averageHighTempIndex]["string_value"] as? String else  { return nil }
        
        guard let averageLowTempIndex = climateData.index(where: { $0["id"] as! String == "WEATHER-AVERAGE-LOW" }) else { return nil }
        guard let averageLow = climateData[averageLowTempIndex]["string_value"] as? String else { return nil }
        
        guard let typeIndex = climateData.index(where: { $0["id"] as! String == "WEATHER-TYPE" }) else { return nil }
        guard let type = climateData[typeIndex]["string_value"] as? String else { return nil }
        
        return Weather(type: type, averageDayLength: averageDayLength, averageNumberOfRainyDays: averageRainyDays,
                       averagePossibilityOfSunshine: averageSunshine, averageHighTemp: Double(averageHigh)!, averageLowTemp: Double(averageLow)!)
    }
    
    private func parseScores(with json: JSONRepresentable) -> [Score]? {
        guard let categories = json["categories"] as? [JSONRepresentable] else { return nil }
        return categories.flatMap { category -> Score? in
            guard let name = category["name"] as? String else { return nil }
            guard let score = category["score_out_of_10"] as? Double else { return nil }
            return Score(name: name, score: score)
        }
    }
}
