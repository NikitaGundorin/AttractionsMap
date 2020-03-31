//
//  AttractionAnnotation.swift
//  AttractionsMap
//
//  Created by Никита Гундорин on 31.03.2020.
//  Copyright © 2020 Никита Гундорин. All rights reserved.
//

import Foundation
import MapKit

class AttractionAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var imageName: String?
    
    init(attraction: Attraction) {
        self.title = attraction.title
        self.subtitle = attraction.subtitle
        self.imageName = attraction.imageName
        coordinate = CLLocationCoordinate2D(latitude: attraction.latitude,
                                            longitude: attraction.longitude)
    }
}
