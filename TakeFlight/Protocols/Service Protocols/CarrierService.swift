//
//  CarrierService.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/16/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation

protocol CarrierService {
    
    var carriers: [Carrier] { get }
    
    func create(carrier: Carrier, completion: ErrorCompletionHandler?)
    func get(carrierWithCode code: String, completion: @escaping (Carrier?, Error?) -> Void)
    func getCarriers(completion: @escaping ([Carrier]?, Error?) -> Void)
    func handleNewCarriers(newCarriers: [QPXExpress.Response.Carrier])
}
