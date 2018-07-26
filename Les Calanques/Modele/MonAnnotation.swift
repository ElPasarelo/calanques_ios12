//
//  MonAnnotation.swift
//  Les Calanques
//
//  Created by Matthieu PASSEREL on 26/07/2018.
//  Copyright © 2018 Matthieu PASSEREL. All rights reserved.
//

import UIKit
import MapKit

class MonAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var calanque: Calanque
    var title: String?
    
    init(_  calanque: Calanque) {
        self.calanque = calanque
        coordinate = self.calanque.coordonnee
        title = self.calanque.nom
    }
}
