//
//  Attraction.swift
//  AttractionsMap
//
//  Created by Никита Гундорин on 31.03.2020.
//  Copyright © 2020 Никита Гундорин. All rights reserved.
//

import Foundation
import MapKit

class Attraction: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
