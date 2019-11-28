//
//  ViewController.swift
//  TAU IOS Test task
//
//  Created by Ivan Nikitin on 28.11.2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController {
    
    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var raitingLabel: UILabel!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var bykeImage: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationAddress: UILabel!
    @IBOutlet weak var connectorType1: UIImageView!
    @IBOutlet weak var connectorType2: UIImageView!
    @IBOutlet weak var connectorChademo: UIImageView!
    @IBOutlet weak var connectorCCS: UIImageView!
    @IBOutlet weak var connectorSchuko: UIImageView!
    
    
    
    
    @IBOutlet var mapView: GMSMapView!
    var activityIndicator: UIActivityIndicatorView!
    var stationsManager = StationsManager()
    var stationsList: [StationDetailModel] = [] {
        didSet {
            if let station = stationsList.last{
                print(station.id)
                let cameraPosition = GMSCameraPosition.camera(withLatitude: station.coordinates.lat,
                longitude: station.coordinates.lng,
                zoom: 12)
                DispatchQueue.main.async {
                    self.mapView.animate(to: cameraPosition)
//                    self.mapView.camera = cameraPosition
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.mapType = .normal
        
        stationsManager.delegate = self
        stationsManager.fetchListOfStations()
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = view.center
        activityIndicator.style = .large
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        view.alpha = 0.4
        
        detailView.layer.cornerRadius = 20
        detailView.clipsToBounds = true
        detailView.isHidden = true
    
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
        marker.title = station.id
        marker.snippet = station.country
        marker.icon = UIImage(named: "point")
        
        marker.map = map
        
    }
}


extension MapViewController: StationsManagerDelegate {
    
    func didRecieveStationDetail(_ station: StationDetailModel) {
        
        stationsList.append(station)
        DispatchQueue.main.async {
            self.addMarker(to: station, on: self.mapView)
            self.activityIndicator.stopAnimating()
            UIView.animate(withDuration: 0.7) {
                self.view.alpha = 1
            }
        }
    }
    
    func didRecieveListOfStations(_ stations: [StationsData]) {
        
        for station in stations {
            stationsManager.fetchStationDetail(with: station.id)
        }
    }
}


extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        detailView.isHidden = false
        locationNameLabel.text = marker.title
        return true
    }
    
}
