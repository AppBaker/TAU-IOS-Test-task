//
//  StationsManager.swift
//  TAU IOS Test task
//
//  Created by Ivan Nikitin on 28.11.2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol StationsManagerDelegate {
    func didRecieveListOfStations(_ stations: [StationsData])
    func didRecieveStationDetail(_ station: StationDetailModel)
}

struct StationsManager {
    let locationsURL = "https://api.tau.tools/v1/locations"
    let stationIdURL = "https://api.tau.tools/v1/locations/"
    var delegate: StationsManagerDelegate?
    
    
    func fetchListOfStations() {
        
        if let url = URL(string: locationsURL) {
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print ("Fetch list of stations error: \(error?.localizedDescription)")
                    return
                }
                if let safeData = data {
                    if let stations = self.parseStationsListJSON(data: safeData) {
                        self.delegate?.didRecieveListOfStations(stations)
                    }
                }
            }
            task.resume()
        }
    }
    
    func fetchStationDetail(with id: String) {
        let urlString = stationIdURL + id
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print ("Fetch station detail error: \(error?.localizedDescription)")
                    return
                }
                if let safeData = data {
                    if let station = self.parseStationDetailJSON(data: safeData) {
                        self.delegate?.didRecieveStationDetail(station)
                    }
                }
            }
            task.resume()
        }
    }

    
    func parseStationsListJSON(data: Data) -> [StationsData]? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode([StationsData].self, from: data)
            
            return decodeData
        }
        catch {
            print(error)
            return nil
        }
    }
    
    func parseStationDetailJSON(data: Data) -> StationDetailModel? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(StationDetailData.self, from: data)
            
            let station = StationDetailModel(
                id: decodeData.id,
                name: decodeData.name,
                country: decodeData.country,
                city: decodeData.city,
                street: decodeData.street,
                rating: decodeData.rating,
                connectors: decodeData.connectors

            )
            
            return station
        }
        catch {
            print(error)
            return nil
        }
    }
}
