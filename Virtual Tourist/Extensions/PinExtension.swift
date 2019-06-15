//
//  PinExtension.swift
//  Virtual Tourist
//
//  Created by KHALID ALSUBAIE on 15/06/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import UIKit
import MapKit

extension Pin {
    
    var coord: CLLocationCoordinate2D {
        set {
            lat = newValue.latitude
            long = newValue.longitude
        }
        get {
            return CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
    }
    
    func compare(coord: CLLocationCoordinate2D) -> Bool {
        return (lat == coord.latitude && long == coord.longitude)
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
    
}
