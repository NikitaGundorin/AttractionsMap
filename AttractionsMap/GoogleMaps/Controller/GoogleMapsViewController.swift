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
    
    var attractions: Results<Attraction>!
    var attractionMarkers: [AttractionMarker] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attractions = DBManager.shared.getAttractions()

        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView.camera = camera
        
        for attraction in attractions {
            attractionMarkers.append(AttractionMarker(attraction: attraction,
                                                      mapView: mapView))
        }
    }
}
