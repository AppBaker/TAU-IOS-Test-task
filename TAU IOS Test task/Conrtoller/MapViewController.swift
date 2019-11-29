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
    @IBOutlet weak var connectorsStackView: UIStackView!
    
    
    
    
    
    @IBOutlet var mapView: GMSMapView!
    var activityIndicator: UIActivityIndicatorView!
    var stationsManager = StationsManager()
    var markersDictionary: [String: StationDetailModel] = [:]
    var stationsList: [StationDetailModel] = [] {
        didSet {
            if let station = stationsList.last{

                let cameraPosition = GMSCameraPosition.camera(withLatitude: station.coordinates.lat,
                                                              longitude: station.coordinates.lng,
                                                              zoom: 12)
                DispatchQueue.main.async {
                    self.mapView.animate(to: cameraPosition)
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
        detailView.alpha = 0
        
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
        
        markersDictionary[station.id] = station
    }
    
    func  setDetailView(with detail: StationDetailModel) {
        for image in connectorsStackView.subviews {
            image.removeFromSuperview()
        }
        raitingLabel.text = "★ \(String(format: "%.01f", detail.rating))"
        locationNameLabel.text = detail.name
        locationAddress.text = "\(detail.street), \(detail.city), \(detail.country)"
        for connector in detail.connectors {
            if let connectorImage = UIImage(named: connector.type) {
                let imageView = UIImageView(image: connectorImage)
                imageView.setImageColor(color: #colorLiteral(red: 0.5487795472, green: 0.7857350111, blue: 0.2036821842, alpha: 1))
                connectorsStackView.addArrangedSubview(imageView)
            }
        }
    }
}

//MARK: - StationsManagerDelegate Recieve Stations Detail Methods
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

//MARK: - GMSMapViewDelegate GoogleMap methods
extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if let markerKey = marker.title {
            if let stationDetail = markersDictionary[markerKey] {
                setDetailView(with: stationDetail)
            }
        }
        
        detailView.isHidden = false
        
        mapView.animate(to: GMSCameraPosition.camera(withTarget: marker.position, zoom: 12))
        
        UIView.animate(withDuration: 0.2) {
            self.detailView.alpha = 1
        }
        
        return true
    }
    
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.detailView.alpha = 0
        }) { (bool) in
            self.detailView.isHidden = true
        }
        
    }
    
}
