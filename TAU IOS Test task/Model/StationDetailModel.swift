//
//  StationModel.swift
//  TAU IOS Test task
//
//  Created by Ivan Nikitin on 28.11.2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

struct StationDetailModel {
    
    let id: String
    let name: String
    let country: String
    let city: String
    let street: String
    let rating: Double
    let connectors: [Connectors]
    let coordinates: Coordinates
}
