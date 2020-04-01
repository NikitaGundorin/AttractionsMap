//
//  YandexMapViewController.swift
//  AttractionsMap
//
//  Created by Никита Гундорин on 01.04.2020.
//  Copyright © 2020 Никита Гундорин. All rights reserved.
//

import UIKit
import MapKit
import YandexMapKit
import RealmSwift

class YandexMapViewController: UIViewController {
    
    @IBOutlet weak var nearbyButton: UIButton!
    @IBOutlet weak var mapView: YMKMapView!
    @IBOutlet weak var myLocationButton: UIButton!
    
    var attractions: Results<Attraction>!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nearbyButton.layer.cornerRadius = 20
        myLocationButton.layer.cornerRadius = 20
        
        attractions = DBManager.shared.getAttractions()
        let mapObjects = mapView.mapWindow.map.mapObjects
        for attraction in attractions {
            let point = YMKPoint(latitude: attraction.latitude, longitude: attraction.longitude)
            let placemark = mapObjects.addPlacemark(with: point)
            guard let imageName = attraction.imageName,
                let image = UIImage(named: imageName) else { continue }
            placemark.setIconWith(image)
        }
        
        mapObjects.addTapListener(with: self)
        
        let userLocationLayer = YMKMapKit.sharedInstance().createUserLocationLayer(with: mapView.mapWindow)

        userLocationLayer.setVisibleWithOn(true)
        userLocationLayer.isHeadingEnabled = true
        
        checkLocationServices()
    }
    
    @IBAction func nearbyButtonPressed(_ sender: Any) {
        guard let attraction = closestLocationToUser() else {
            return
        }
        centerViewOn(coordinate: CLLocationCoordinate2D(latitude: attraction.latitude,
                                                        longitude: attraction.longitude))
    }
    
    @IBAction func myLocationPressed(_ sender: Any) {
        guard let coordinate = locationManager.location?.coordinate else {
            return
        }
        centerViewOn(coordinate: coordinate)
    }
    
    func closestLocationToUser() -> Attraction? {
        guard let location = locationManager.location else { return nil }
        
        if let closestLocation = attractions
            .map({ CLLocation(latitude: $0.latitude,
                              longitude: $0.longitude) })
            .min(by: { location.distance(from: $0) < location.distance(from: $1) }) {
            let point = attractions.first(where: { $0.latitude == closestLocation.coordinate.latitude &&
                $0.longitude == closestLocation.coordinate.longitude })
            
            return point
        } else {
            return nil
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOn(coordinate: CLLocationCoordinate2D) {
        let point = YMKPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
        mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: point,
                                         zoom: 15,
                                         azimuth: 0,
                                         tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth,duration: 0.5),
            cameraCallback: nil)
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
            locationManager.startUpdatingLocation()
            guard let coordinate = locationManager.location?.coordinate else { break }
            centerViewOn(coordinate: coordinate)
            mapView.isUserInteractionEnabled = true
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
        let alert = UIAlertController(title: "Location is not awailable",
                                      message: "Pless allow to use location in Settings",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

extension YandexMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension YandexMapViewController: YMKMapObjectTapListener {
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        guard let coordinate = (mapObject as? YMKPlacemarkMapObject)?.geometry,
            let attraction = attractions.first(where: { $0.latitude == coordinate.latitude &&
                $0.longitude == coordinate.longitude })
            else { return true }
        centerViewOn(coordinate: CLLocationCoordinate2D(latitude: attraction.latitude,
                                                        longitude: attraction.longitude))
        print(String(describing: attraction.title))
        return true
    }
}
