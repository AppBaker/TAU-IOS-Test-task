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
    
    var stationsManager = StationsManager()
    var stationsList: [StationDetailModel]?
    let mapView = GMSMapView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stationsManager.delegate = self
        stationsManager.fetchListOfStations()
        view = mapView
    }
    
    override func loadView() {
        super.loadView()
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        
    }
    
    func loadMap() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
        //        let marker = GMSMarker()
        //        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        //        marker.title = "Sydney"
        //        marker.snippet = "Australia"
        //        marker.map = mapView
        
    }
    
    func addMarkers(to station: StationDetailModel, on map: GMSMapView) {
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: station.coordinates.lat, longitude: station.coordinates.lng)
        marker.title = station.name
        marker.snippet = station.country
        marker.map = map
        
    }
}


extension ViewController: StationsManagerDelegate {
    
    func didRecieveStationDetail(_ station: StationDetailModel) {
        stationsList?.append(station)
        DispatchQueue.main.async {
            self.addMarkers(to: station, on: self.view as! GMSMapView)
        }
    }
    
    func didRecieveListOfStations(_ stations: [StationsData]) {
        
        for station in stations {
            stationsManager.fetchStationDetail(with: station.id)
        }
    }
    
}

