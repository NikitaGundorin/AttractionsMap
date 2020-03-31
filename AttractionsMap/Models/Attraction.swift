//
//  Attraction.swift
//  AttractionsMap
//
//  Created by Никита Гундорин on 31.03.2020.
//  Copyright © 2020 Никита Гундорин. All rights reserved.
//

import Foundation
import MapKit
import RealmSwift

class Attraction: Object {
    @objc dynamic var title: String?
    @objc dynamic var subtitle: String?
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    @objc dynamic var imageName: String?
}
