//
//  UserStorageService.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/16/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation

protocol UserStorageService {
    func upload(userProfileImage imageData: Data, forUser user: User, completion: ((URL?, Error?) -> Void)?)
    func download(userProfileImageWithUID uid: String, completion: @escaping (Data?, Error?) -> Void)
}
