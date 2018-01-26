//
//  QPXExpressBuilder.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/1/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation
import Firebase

enum QPXExpressError: Error {
    case corruptData
    case parseError
    
    public var localizedDescription: String {
        switch self {
        case .corruptData:
            return "The data is currupted"
        case .parseError:
            return "The response could not be parsed"
        }
    }
}

class QPXExpress {
    
    // MARK: Properties
    
    let networkManager: NetworkManager
    private lazy var carrierService: CarrierService = FirebaseCarrierService(database: Firestore.firestore())
    private lazy var airportService: AirportService = FirebaseAirportService(database: Firestore.firestore())
    
    // MARK: Life Cycle
    
    init() {
        self.networkManager = NetworkManager()
    }
    
    func fetch(qpxRequest request: Request, completion: @escaping (([FlightData]?, Error?) -> Void)) {
        var request = request
        networkManager.load(request.url, headers: request.headers, payload: request.dictionaryRepresentaion) { (data, error) in
            guard error == nil else { return completion(nil, error!) }
            guard let data = data else { return completion(nil, QPXExpressError.corruptData as Error) }
            do {
                let flightData = try self.makeFlightData(from: data)
                completion(flightData, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    private func decodeResponse(from data: Data) throws -> QPXExpress.Response {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(QPXExpress.Response.self, from: data)
        } catch {
            throw error
        }
    }
    
    private func makeFlightData(from data: Data) throws -> [FlightData]? {
        var flightDataArray = [FlightData]()
        
        do {
            let response = try decodeResponse(from: data)
            let supportingData = response.trips.data
            
            carrierService.handleNewCarriers(newCarriers: response.trips.data.carrier)
            airportService.handleNewAirports(newAirports: response.trips.data.airport)

            for trip in response.trips.tripOption {
                if let flightData = try? parseTripOption(tripOption: trip, supportingData: supportingData) {
                    flightDataArray.append(flightData)
                }
            }
        } catch {
            throw error
        }
        return flightDataArray
    }
    
    private func timeZoneToSeconds(_ timeZone: String) -> Int? {
        let hours = Double(timeZone.replacingOccurrences(of: ":", with: "."))
        if let hours = hours {
            let seconds = hours * 60 * 60
            return Int(seconds)
        }
        return 0
    }
    
    private func convertToDate(fromString string: String) -> DateAndTimeZone? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mmZZZZZ"
        let timeZoneString = string.suffix(6)
        
        if let date = formatter.date(from: string), let seconds = timeZoneToSeconds(String(timeZoneString)) {
            return DateAndTimeZone(date: date, timeZone: seconds)
        }
        return nil
    }
    
    private func parseTripOption(tripOption option: Response.TripOption, supportingData: Response.Data) throws -> FlightData {
        guard let pricing = option.pricing.first else { throw QPXExpressError.parseError }
        
        let uid = option.id
        let saleTotal = Double(option.saleTotal.alphanumericCharacters) ?? 0
        let baseFareTotal = Double(pricing.baseFareTotal.alphanumericCharacters) ?? 0
        let saleFareTotal = Double(pricing.saleFareTotal.alphanumericCharacters) ?? 0
        let saleTaxTotal = Double(pricing.saleTaxTotal.alphanumericCharacters) ?? 0
        let fareCalculation = pricing.fareCalculation.alphanumericCharacters
        guard let latestTicketingTime = convertToDate(fromString: pricing.latestTicketingTime) else { throw QPXExpressError.parseError }
        let refundable = pricing.refundable ?? false
        let taxCountry = pricing.tax.first?.country ?? ""
        var sliceArray = [[FlightSegment]]()
        
        for slice in option.slice {
            var flightSegments = [FlightSegment]()
            
            for segment in slice.segment {
                let id = segment.id
                let duration = segment.duration
                let flightNumber = segment.flight.number
                let carrierCode = segment.flight.carrier
                let cabin = segment.cabin
                let bookingCode = segment.bookingCode
                let bookingCodeCount = segment.bookingCodeCount
                let marriedSegmentGroup = segment.marriedSegmentGroup
                let subjectToGovernmentApproval = segment.subjectToGovernmentApproval
                let connectionDuration = segment.connectionDuration
                var legs = [FlightSegment.Leg]()
                
                guard let carrierIndex = supportingData.carrier.index(where: { $0.code == carrierCode }) else { throw QPXExpressError.parseError }
                let carrier = Carrier(name: supportingData.carrier[carrierIndex].name, code: carrierCode)
                
                for leg in segment.leg {
                    let id = leg.id
                    guard let aircraftIndex = supportingData.aircraft.index(where: { $0.code == leg.aircraft }) else { throw QPXExpressError.parseError }
                    let aircraft = supportingData.aircraft[aircraftIndex]
                    guard let arrivalTime = convertToDate(fromString: leg.arrivalTime) else { throw QPXExpressError.parseError }
                    guard let departureTime = convertToDate(fromString: leg.departureTime) else { throw QPXExpressError.parseError }
                    let origin = leg.origin
                    let originTerminal = leg.originTerminal
                    let destination = leg.destination
                    let destinationTerminal = leg.destinationTerminal
                    let duration = leg.duration
                    let onTimePerformance = leg.onTimePerformance
                    let mileage = leg.mileage
                    let meal = leg.meal
                    let secure = leg.secure
                    let connectionDuration = leg.connectionDuration
                    
                    let leg = FlightSegment.Leg(id: id, aircraft: aircraft.name, departureTime: departureTime, arrivalTime: arrivalTime, origin: origin, originTerminal: originTerminal, destination: destination, destinationTerminal: destinationTerminal, duration: duration, onTimePerformance: onTimePerformance, mileage: mileage, meal: meal, secure: secure, connectionDuration: connectionDuration)
                    legs.append(leg)
                }
                
                let flightSegment = FlightSegment(id: id, flightNumber: flightNumber, carrier: carrier, cabin: cabin, bookingCode: bookingCode, bookingCodeCount: bookingCodeCount, marriedSegmentGroup: marriedSegmentGroup, subjectToGovernmentApproval: subjectToGovernmentApproval, duration: duration, connectionDuration: connectionDuration, legs: legs)
                flightSegments.append(flightSegment)
            }
            sliceArray.append(flightSegments)
        }
        assert(sliceArray.count <= 2, "QPXExpress.parseTripOption() The slice array contains more than two elements.")
        
        guard let departingFlight = sliceArray.first else { throw QPXExpressError.parseError }
        let returningFlight: [FlightSegment]?
        
        if sliceArray.count == 2 {
            returningFlight = sliceArray[1]
        } else {
            returningFlight = nil
        }
        
        let flightData = FlightData(uid: uid, createdTimeStamp: Date(), baseFareTotal: baseFareTotal, saleFareTotal: saleFareTotal, saleTaxTotal: saleTaxTotal, saleTotal: saleTotal, fareCalculation: fareCalculation, latestTicketingTime: latestTicketingTime, refundable: refundable, taxCountry: taxCountry, departingFlightSegments: departingFlight, returningFlightSegments: returningFlight)
        
        return flightData
    }
}
