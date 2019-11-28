//
//  ViewController.swift
//  TAU IOS Test task
//
//  Created by Ivan Nikitin on 28.11.2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarItem.title = "Map"
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        tabBarItem.title = ""
    }
    
    
    func addMarker(to station: StationDetailModel, on map: GMSMapView) {
        
        let marker = GMSMarker()
        
        marker.position = CLLocationCoordinate2D(latitude: station.coordinates.lat, longitude: station.coordinates.lng)
        marker.title = station.name
        marker.snippet = station.country
        marker.map = map
        
        
    }
}


extension MapViewController: StationsManagerDelegate {
    
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


extension MapViewController: GMSMapViewDelegate {
    
}
