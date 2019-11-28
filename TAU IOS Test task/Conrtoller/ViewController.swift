//
//  ViewController.swift
//  TAU IOS Test task
//
//  Created by Ivan Nikitin on 28.11.2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var stationsManager = StationsManager()
    var stations: [StationsData]?

    override func viewDidLoad() {
        super.viewDidLoad()
        stationsManager.delegate = self
        stationsManager.fetchListOfStations()
    }
}

extension ViewController: StationsManagerDelegate {
    
    func didRecieveStationDetail(_ station: StationDetailModel) {
        print(station.id)
        for connector in station.connectors {
            print(connector.type)
        }
    }
    
    func didRecieveListOfStations(_ stations: [StationsData]) {
        self.stations = stations
        for station in stations {
            stationsManager.fetchStationDetail(with: station.id)
        }
    }

}

