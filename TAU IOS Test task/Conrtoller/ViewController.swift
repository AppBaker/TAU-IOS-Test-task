//
//  ViewController.swift
//  TAU IOS Test task
//
//  Created by Ivan Nikitin on 28.11.2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {
    
    @IBOutlet var mapView: GMSMapView!
    
    
    var stationsManager = StationsManager()
    var stationsList: [StationDetailModel] = [] {
        didSet {
            if let station = stationsList.last{
                print(station.id)
                let cameraPosition = GMSCameraPosition.camera(withLatitude: station.coordinates.lat,
                longitude: station.coordinates.lng,
                zoom: 9)
                DispatchQueue.main.async {
                    self.mapView.animate(to: cameraPosition)
//                    self.mapView.camera = cameraPosition
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stationsManager.delegate = self
        stationsManager.fetchListOfStations()
    }
    
//    func loadMap(with station: StationDetailModel) {
//        let camera = GMSCameraPosition.camera(withLatitude: station.coordinates.lat, longitude: station.coordinates.lng, zoom: 6.0)
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//
//        view = mapView
//    }
    
    
    func addMarker(to station: StationDetailModel, on map: GMSMapView) {
        
        let marker = GMSMarker()
        
        marker.position = CLLocationCoordinate2D(latitude: station.coordinates.lat, longitude: station.coordinates.lng)
        marker.title = station.name
        marker.snippet = station.country
        marker.map = map
        
        
    }
}


extension ViewController: StationsManagerDelegate {
    
    func didRecieveStationDetail(_ station: StationDetailModel) {
        
        stationsList.append(station)
        DispatchQueue.main.async {
//            self.loadMap(with: station)
            self.addMarker(to: station, on: self.view as! GMSMapView)
        }
    }
    
    func didRecieveListOfStations(_ stations: [StationsData]) {
        
        for station in stations {
            stationsManager.fetchStationDetail(with: station.id)
        }
    }
    
}

