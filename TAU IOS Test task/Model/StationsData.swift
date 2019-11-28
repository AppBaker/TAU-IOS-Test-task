//
//  StationData.swift
//  TAU IOS Test task
//
//  Created by Ivan Nikitin on 28.11.2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

struct StationsData: Decodable {
    let id: String
    let coordinates: Coordinates
    let evse_statuses: EvseStatus
}

struct Coordinates: Decodable {
    let lat: Double
    let lng: Double
}

struct EvseStatus: Decodable {
    let available: Int
    let busy: Int
    let offline: Int
    let faulted: Int
}
