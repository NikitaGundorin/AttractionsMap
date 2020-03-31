//
//  ViewController.swift
//  AttractionsMap
//
//  Created by Никита Гундорин on 30.03.2020.
//  Copyright © 2020 Никита Гундорин. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class AppleMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var myLocationButton: UIButton!
    @IBOutlet weak var nearbyAttractionButton: UIButton!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    
    var attractions: Results<Attraction>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myLocationButton.layer.cornerRadius = 20
        nearbyAttractionButton.layer.cornerRadius = 20
        
        mapView.delegate = self
        checkLocationServices()
        attractions = DBManager.shared.getAttractions()
        
        for attraction in attractions {
            let annotation = AttractionAnnotation(attraction: attraction)
            mapView.addAnnotation(annotation)
        }
    }
    @IBAction func myLocationButtonPressed(_ sender: Any) {
        guard let coordinate = locationManager.location?.coordinate else { return }
        centerViewOn(coordinate: coordinate)
    }
    
    @IBAction func nearbyButtonPressed(_ sender: Any) {
        guard let location = locationManager.location else { return }
        
        var locations: [CLLocation] = []
        
        for annotation in mapView.annotations {
            guard let annotation = annotation as? AttractionAnnotation else { continue }
            locations.append(CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude))
        }
        
        if let closestLocation = locations.min(by: { location.distance(from: $0) < location.distance(from: $1) }) {
            centerViewOn(coordinate: closestLocation.coordinate)
        }
    }
    
    func closestLocationToUser() -> CLLocation? {
        guard let location = locationManager.location else { return nil }
        
        var locations: [CLLocation] = []
        
        for annotation in mapView.annotations {
            guard let annotation = annotation as? AttractionAnnotation else { continue }
            locations.append(CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude))
        }
        
        if let closestLocation = locations.min(by: { location.distance(from: $0) < location.distance(from: $1) }) {
            return closestLocation
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
        let region = MKCoordinateRegion.init(center: location,
                                             latitudinalMeters: regionInMeters,
                                             longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    func centerViewOn(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion.init(center: coordinate,
                                             latitudinalMeters: regionInMeters,
                                             longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
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
            mapView.showsUserLocation = true
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

extension AppleMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension AppleMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? AttractionAnnotation else { return nil }
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
        
        guard let imageName = annotation.imageName,
            let image = UIImage(named: imageName) else {
                let defaultImage = UIImage(named: "")
                annotationView.image = defaultImage
                return annotationView
        }
        
        annotationView.image = image

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let selectedAnnotation = view.annotation else { return }
        
        let location = selectedAnnotation.coordinate
        centerViewOn(coordinate: location)
        
        print(String(describing: view.annotation?.title))
    }
}
