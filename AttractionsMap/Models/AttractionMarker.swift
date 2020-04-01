//
//  AttractionMarker.swift
//  AttractionsMap
//
//  Created by Никита Гундорин on 01.04.2020.
//  Copyright © 2020 Никита Гундорин. All rights reserved.
//

import Foundation
import GoogleMaps

class AttractionMarker: GMSMarker {
    init(attraction: Attraction, mapView: GMSMapView) {
        super.init()
        self.title = attraction.title
        self.snippet = attraction.subtitle
        self.position = CLLocationCoordinate2D(latitude: attraction.latitude,
                                               longitude: attraction.longitude)
        self.map = mapView
        
        if let imageName = attraction.imageName,
            let image = UIImage(named: imageName) {
            self.icon = image
        }
    }
}
