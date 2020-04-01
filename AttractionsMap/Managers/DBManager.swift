//
//  DBManager.swift
//  AttractionsMap
//
//  Created by Никита Гундорин on 31.03.2020.
//  Copyright © 2020 Никита Гундорин. All rights reserved.
//

import RealmSwift
import MapKit

class DBManager {
    static var shared = DBManager()
    
    let realm = try! Realm()
    
    init() {
        if getAttractions().count == 0 {
            loadDefaultAttractions()
        }
    }
    
    func getAttractions() -> Results<Attraction> {
        return realm.objects(Attraction.self)
    }
    
    func saveAttraction(title: String?, subtitle: String?, latitude: Double, longitude: Double, imageName: String?) {
        try! realm.write {
            let attraction = Attraction()
            attraction.title = title
            attraction.subtitle = subtitle
            attraction.latitude = latitude
            attraction.longitude = longitude
            attraction.imageName = imageName
            
            realm.add(attraction)
        }
    }
    
    func loadDefaultAttractions() {
        saveAttraction(title: "Palace Square",
                       subtitle: "Palace Square",
                       latitude: 59.938838,
                       longitude: 30.315744,
                       imageName: "Palace")
        saveAttraction(title: "Saint Isaac's Cathedral",
                       subtitle: "Saint Isaac's Cathedral",
                       latitude: 59.934101,
                       longitude: 30.306160,
                       imageName: "Isaac")
        saveAttraction(title: "Kazan Cathedral",
                       subtitle: "Kazan Cathedral",
                       latitude: 59.934195,
                       longitude: 30.324543,
                       imageName: "Kazan")
        saveAttraction(title: "Church of the Savior on Spilled Blood",
                       subtitle: "Church of the Savior on Spilled Blood",
                       latitude: 59.940017,
                       longitude: 30.328750,
                       imageName: "SaviorOnSpilledBlood")
        saveAttraction(title: "Peter and Paul Fortress",
                       subtitle: "Peter and Paul Fortress",
                       latitude: 59.950187,
                       longitude: 30.316476,
                       imageName: "PeterAndPaul")
    }
}
