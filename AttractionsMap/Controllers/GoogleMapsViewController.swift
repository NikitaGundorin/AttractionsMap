//
//  GoogleMapsViewController.swift
//  AttractionsMap
//
//  Created by Никита Гундорин on 01.04.2020.
//  Copyright © 2020 Никита Гундорин. All rights reserved.
//

import UIKit
import GoogleMaps
import RealmSwift

class GoogleMapsViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var nearbyButton: UIButton!
    
    var attractions: Results<Attraction>!
    var attractionMarkers: [AttractionMarker] = []
    
    let locationManager = CLLocationManager()
    let zoom: Float = 14.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNearbyButton()
        
        mapView.delegate = self
        attractions = DBManager.shared.getAttractions()
        
        for attraction in attractions {
            attractionMarkers.append(AttractionMarker(attraction: attraction,
                                                      mapView: mapView))
        }
        
        checkLocationServices()
    }
    
    @IBAction func nearbyButtonPressef(_ sender: Any) {
        guard let marker = closestLocationToUser() else {
            return
        }
        mapView.selectedMarker = marker
        centerViewOn(coordinate: marker.position)
    }
    
    func setUpNearbyButton() {
        nearbyButton.layer.cornerRadius = 20
        nearbyButton.layer.masksToBounds = false
        nearbyButton.layer.shadowColor = UIColor.black.cgColor
        nearbyButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        nearbyButton.layer.shadowRadius = CGFloat(2)
        nearbyButton.layer.shadowOpacity = 0.24
    }
    
    func closestLocationToUser() -> AttractionMarker? {
        guard let location = locationManager.location else { return nil }
        
        if let closestLocation = attractionMarkers
            .map({ CLLocation(latitude: $0.position.latitude,
                              longitude: $0.position.longitude) })
            .min(by: { location.distance(from: $0) < location.distance(from: $1) }) {
            let marker = attractionMarkers.first(where: { $0.position.latitude == closestLocation.coordinate.latitude && $0.position.longitude == closestLocation.coordinate.longitude })
            return marker
        } else {
            return nil
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        guard let location = locationManager.location?.coordinate else { return }
        
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude,
                                              longitude: location.longitude,
                                              zoom: zoom)
        mapView.camera = camera
    }
    
    func centerViewOn(coordinate: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude,
                                              longitude: coordinate.longitude,
                                              zoom: zoom)
        mapView.animate(to: camera)
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            showLocationDisabledAlert()
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
            locationManager.startUpdatingLocation()
            guard let coordinate = locationManager.location?.coordinate else { break }
            centerViewOn(coordinate: coordinate)
            break
        case .denied:
            showLocationDisabledAlert()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            showLocationDisabledAlert()
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
    func showLocationDisabledAlert() {
        let alert = UIAlertController(title: "Location is not awailable", message: "Pless allow to use location in Settings", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

extension GoogleMapsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension GoogleMapsViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let marker = marker as? AttractionMarker else {
            return false
        }
        centerViewOn(coordinate: marker.position)
        print(String(describing: marker.title))
        return false
    }
}
